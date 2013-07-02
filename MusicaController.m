//
//  MusicaController.m
//  Musica
//
//  Created by Chloe Stars on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MusicaController.h"
#import "Track.h"

@implementation MusicaController

@synthesize window;
@synthesize preferencesController;

#pragma mark -
#pragma mark Dock Hackery

/* Hide in Dock hackery
 We use this method of not changing the plist because
 Apple requires us to sign our code.
 That wouldn't work right if we modified our own code.
 */

-(void)setFront; {
	ProcessSerialNumber psn = { 0, kCurrentProcess };
	SetFrontProcess(&psn);
}

#pragma mark -

-(id)init {
	if (self == [super init]) {
        mouseInWindow = TRUE;
		#ifndef DEBUG
		NSLog(@"MusicaController Compiled as RELEASE");
		// First run code. Set default settings here
		if (![[NSUserDefaults standardUserDefaults] boolForKey:@"musicaFirstRun"]) {
			[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"musicaEnableNotifications"];
			[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"musicaFirstRun"];
		}
		#else
		NSLog(@"MusicaController Not compiled as RELEASE");
		#endif
		// Load in menu bar mode if that's what we chose
		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaMenuBar"]) {
			NSLog(@"MusicaController Menu bar should be loading.");
			NSStatusBar *bar = [NSStatusBar systemStatusBar];
			
			theItem = [bar statusItemWithLength:NSVariableStatusItemLength];
            
			//TrayMenu *menu = [[TrayMenu alloc] init];
            menu = [[TrayMenu alloc] init];
			
			[theItem setImage:[NSImage imageNamed:@"trayIcon"]];
			[theItem setHighlightMode:YES];
			[theItem setMenu:[menu createMenu]];
		}
		else {
			// this should be called from the application delegate's applicationDidFinishLaunching
			// method or from some controller object's awakeFromNib method
			if (![[NSUserDefaults standardUserDefaults] boolForKey:@"LaunchAsAgentApp"]) {
				ProcessSerialNumber psn = { 0, kCurrentProcess };
				// display dock icon
				TransformProcessType(&psn, kProcessTransformToForegroundApplication);
				// enable menu bar
				SetSystemUIMode(kUIModeNormal, 0);
				// switch to Dock.app
				[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.dock" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:nil launchIdentifier:nil];
				// switch back
				[[NSApplication sharedApplication] activateIgnoringOtherApps:TRUE];
			}
		}
	}
	return self;
}

- (void)fadeOut:(NSTimer *)theTimer
{
    if ([window alphaValue] > 0.0) {
        // If window is still partially opaque, reduce its opacity.
        [window setAlphaValue:[window alphaValue] - 0.2];
    } else {
        // Otherwise, if window is completely transparent, destroy the timer and close the window.
        [fadeOutTimer invalidate];
        fadeOutTimer = nil;
        
        //[window close];
        
        //Hide the window because iTunes is no longer running
        [window orderOut:nil];
        
        // Make the window fully opaque again for next time.
        //[window setAlphaValue:1.0];
    }
}

-(void)applicationWillTerminate:(id)sender {
	NSLog(@"MusicaController Quitting now");
	NSRect windowFrame = [[self window] frame];
	[[NSUserDefaults standardUserDefaults] setObject:NSStringFromRect(windowFrame) forKey:@"musicaWindowFrame"];
	//NSRectFromString();
}

#pragma mark -
#pragma mark Prepare Application

-(void)awakeFromNib {
    
	// Give us features we need that EyeTunes doesn't
	//iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    Rdio = [SBApplication applicationWithBundleIdentifier:@"com.rdio.desktop"];
    Spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
    Radium = [SBApplication applicationWithBundleIdentifier:@"com.catpigstudios.Radium3"];
	
	[webView setDrawsBackground:NO];
	[webView setFrameLoadDelegate:self];
	[webView setUIDelegate:self];
	[webView setEditingDelegate:self];
	
	float width = [themeDictionary[@"BTWindowWidth"] doubleValue];
	float height = [themeDictionary[@"BTWindowHeight"] doubleValue];
	//NSRect frame = NSMakeRect(webView.frame.origin.x, webView.frame.origin.y, width, height);
	NSRect windowFrame = NSMakeRect(self.window.frame.origin.x, self.window.frame.origin.y, width, height);
	//[window setFrame:windowFrame display:NO];
	[window setOpaque:NO];
	[window setBackgroundColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.0]];  //Tells the window to use a transparent colour.
	//[webView setFrame:frame];
	//[window center];
	player = [[Player alloc] init];
	
	NSLog(@"MusicaController Awoken from Nib");
	// Begin the fadeIn
	//[window setAlphaValue:0.0];
	// Fade In timer also loads the welcome screen after its done fading in.
	//fadeInTimer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fadeIn:) userInfo:nil repeats:YES] retain];
	// Load window position from memory.
	[self restoreWindowPosition];
	// Monitor application quit
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
	// Begin monitoring iTunes
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(monitorTunes) userInfo:nil repeats:YES];
	// Allow for controls to disappear when mouse isn't in window.
	/*NSTrackingAreaOptions trackingOptions =
	NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveAlways;
	NSTrackingArea *myTrackingArea1 = [[NSTrackingArea alloc]
					   initWithRect: [imageView bounds] // in our case track the entire view
					   options: trackingOptions
					   owner: self
					   userInfo: nil];
	[imageView addTrackingArea: myTrackingArea1];*/
	[self updateTrackingArea];
}

-(void)restoreWindowPosition {
	if ([[NSUserDefaults standardUserDefaults] stringForKey:@"musicaWindowFrame"]!=nil) {
		NSRect windowFrame = NSRectFromString([[NSUserDefaults standardUserDefaults] stringForKey:@"musicaWindowFrame"]);
		[[self window] setFrame:windowFrame display:YES animate:YES];
	}
	else {
		NSLog(@"MusicaController No position to restore from.");
	}
	
}

// Necessary for when album artwork is resized
-(void)updateTrackingArea {
	// Allow for controls to disappear when mouse isn't in window.
	if (myTrackingArea!=nil) {
		[imageView removeTrackingArea:myTrackingArea];
	}
	NSTrackingAreaOptions trackingOptions =
	NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveAlways;
	/*NSTrackingArea *myTrackingArea = [[NSTrackingArea alloc]
	 initWithRect: [imageView bounds] // in our case track the entire view
	 options: trackingOptions
	 owner: self
	 userInfo: nil];*/
	myTrackingArea = [[NSTrackingArea alloc]
					  initWithRect: [imageView bounds] // in our case track the entire view
					  options: trackingOptions
					  owner: self
					  userInfo: nil];
   NSTrackingArea *buttonArea = [[NSTrackingArea alloc]
                  initWithRect: [buttonBar bounds] // in our case track the entire view
                  options: trackingOptions
                  owner: self
                  userInfo: nil];
	[imageView addTrackingArea: myTrackingArea];
    [buttonBar addTrackingArea: buttonArea];
}

- (void)fadeIn:(NSTimer *)theTimer
{
    if ([window alphaValue] < 1.0) {
        // If window is still partially opaque, reduce its opacity.
        [window setAlphaValue:[window alphaValue] + 0.2];
    } else {
        // Otherwise, if window is completely transparent, destroy the timer and close the window.
        [fadeInTimer invalidate];
        fadeInTimer = nil;
        
        //[window close];
        
        // Make the window fully opaque again for next time.
        [window setAlphaValue:1.0];
		// Load the welcome window if hasn't been unchecked.
		//[self openWelcomeWindow:nil];
    }
}

#pragma mark -
#pragma mark NSTrackingArea

- (void)mouseEntered:(NSEvent *)theEvent {
    NSLog(@"MusicaController <%p>%s:", self, __PRETTY_FUNCTION__);
	// Only show all the controls if we arne't showing an ad.
	//[self showControls];
	/*[window makeKeyAndOrderFront:self];
	[window setOrderedIndex:0];*/
	// Worst solution. Brings it to front.
	//[NSApp activateIgnoringOtherApps:YES];
	// Best and perfect solution. Makes the window accept mouse events without it being forefront.
	[[self window] becomeKeyWindow];
	mouseInWindow = TRUE;
}

- (void)mouseExited:(NSEvent *)theEvent {
    NSLog(@"MusicaController <%p>%s:", self, __PRETTY_FUNCTION__);
	//[self hideControls];
	//mouseInWindow = FALSE;
}

- (void)mouseMoved:(NSEvent *)theEvent {
    //NSLog(@"<%p>%s:", self, __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark The Juicy Bits

-(void)monitorTunes {
    DescType playerState;
    RdioEPSS rdioPlayerState;
    SpotifyEPlS spotifyPlayerState;
    BOOL radiumPlayerState;
    if ([EyeTunes isRunning]) {
        //iTunesEPlS playerState;
        //ETTrack *track = [[ETTrack alloc] init];
        EyeTunes *e = [EyeTunes sharedInstance];
        playerState = [e playerState];
        //track = [e currentTrack];
        //playerState = [iTunes playerState];
    }
    if ([Rdio isRunning]) {
        rdioPlayerState = [Rdio playerState];
        NSLog(@"MusicaController Playing: %@", [[Rdio currentTrack] name]);
    }
    if ([Spotify isRunning]) {
        spotifyPlayerState = [Spotify playerState];
    }
    if ([Radium isRunning]) {
        radiumPlayerState = [Radium playing];
    }
    
    // Analyzing the current running programs
    NSMutableArray *array=[[NSMutableArray alloc] init];
    if ([EyeTunes isRunning]) {
        [array addObject:@"iTunes"];
    }
    if ([Rdio isRunning]) {
        [array addObject:@"Rdio"];
    }
    if ([Spotify isRunning]) {
        [array addObject:@"Spotify"];
    }
    if ([Radium isRunning]) {
        [array addObject:@"Radium"];
    }
    // No players have opened or closed
    if ([audioPlayers isEqualToArray:array]) {
        // do nothing
    }
    else {
        // something has changed
        NSLog(@"MusicaController descr: %@, count: %lu", [array description], [array count]);
        if ([array count]>1) {
            // conditionally do the right thing with fading
            // show the window again
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaAlwaysShow"]) {
                [window orderFront:nil];
                fadeInTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fadeIn:) userInfo:nil repeats:YES];
            }
            NSLog(@"MusicaController more than program is open");
            //ask dialog
            resolvingConflict=YES;
            NSInteger response = NSRunAlertPanel(@"Please resolve conflict", @"You have multiple sources open please choose one:", [array objectAtIndex:0], [array objectAtIndex:1], nil);
            // for some reason the answers are reversed
            if (response==1) {
                response=0;
            }
            else {
                response=1;
            }
            NSString *chosenString = [array objectAtIndex:response];
            NSLog(@"MusicaController response:%ld string:%@", response, chosenString);
            // decode choice and choose it
            if ([chosenString isEqualToString:@"iTunes"]) {
                chosenPlayer=audioPlayeriTunes;
            }
            if ([chosenString isEqualToString:@"Rdio"]) {
                chosenPlayer=audioPlayerRdio;
            }
            if ([chosenString isEqualToString:@"Spotify"]) {
                chosenPlayer=audioPlayerSpotify;
            }
            if ([chosenString isEqualToString:@"Radium"]) {
                chosenPlayer=audioPlayerRadium;
            }
        }
        // only one program is loaded
        else {
            resolvingConflict=NO;
            // no programs are loaded if user has decided to hide Musica now is the time
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaAlwaysShow"]) {
                if ([array count]==0) {
                    fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fadeOut:) userInfo:nil repeats:YES];
                }
                else {
                    // show the window again
                    [window orderFront:nil];
                    fadeInTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fadeIn:) userInfo:nil repeats:YES];
                }
            }
        }
    }
    // set up for previus referencing
    audioPlayers = array;
    
    // Preset conditionals to simplify the way the code looks and make it easier to read
    BOOL iTunesUsable = ([EyeTunes isRunning] && chosenPlayer==audioPlayeriTunes) || ([EyeTunes isRunning] && resolvingConflict==NO);
    BOOL rdioUsable = ([Rdio isRunning] && chosenPlayer==audioPlayerRdio) || ([Rdio isRunning] && resolvingConflict==NO);
    BOOL spotifyUsable = ([Spotify isRunning] && chosenPlayer==audioPlayerSpotify) || ([Spotify isRunning] && resolvingConflict==NO);
    BOOL radiumUsable = ([Radium isRunning] && chosenPlayer==audioPlayerRadium) || ([Radium isRunning] && resolvingConflict==NO);
    
    // REALLY NEED TO CLEAN THIS UP. UNECESSARY CONDITIONALS
    if (iTunesUsable) [glossOverlay setAudioPlayer: audioPlayeriTunes];
    if (rdioUsable) [glossOverlay setAudioPlayer: audioPlayerRdio];
    if (spotifyUsable) [glossOverlay setAudioPlayer: audioPlayerSpotify];
    if (radiumUsable) [glossOverlay setAudioPlayer: audioPlayerRadium];
    
    // Change the playing button to the appropriate state
    // Detect is iTunes is paused and set button image
    if ((iTunesUsable==TRUE && playerState == kETPlayerStatePaused) || (rdioUsable==TRUE && rdioPlayerState == RdioEPSSPaused) || (spotifyUsable==TRUE && spotifyPlayerState == SpotifyEPlSPaused) || (radiumUsable==TRUE && radiumPlayerState==FALSE)) {
        [pauseButton setImage:[NSImage imageNamed:@"Play@2x.png"]];
        [pauseButton setAlternateImage:[NSImage imageNamed:@"Play-Pressed@2x.png"]];
		// update theme playState variable
		player.playState=@2;
        //NSLog(@"MusicaController iTunes is paused");
    }
    if ((iTunesUsable==TRUE && playerState == kETPlayerStatePlaying) || (rdioUsable==TRUE && rdioPlayerState == RdioEPSSPlaying) || (spotifyUsable==TRUE && spotifyPlayerState == SpotifyEPlSPlaying) || (radiumUsable==TRUE && radiumPlayerState==TRUE)) {
        [pauseButton setImage:[NSImage imageNamed:@"Pause@2x.png"]];
        [pauseButton setAlternateImage:[NSImage imageNamed:@"Pause-Pressed@2x.png"]];
		player.playState=@1;
        //NSLog(@"MusicaController iTunes is playing");
    }
    if ((iTunesUsable==TRUE && playerState == kETPlayerStateStopped) || (rdioUsable==TRUE && rdioPlayerState == RdioEPSSStopped) || (spotifyUsable==TRUE && spotifyPlayerState == SpotifyEPlSStopped)) {
        [pauseButton setImage:[NSImage imageNamed:@"Play@2x.png"]];
        [pauseButton setAlternateImage:[NSImage imageNamed:@"Play-Pressed@2x.png"]];
		player.playState=@0;
        //NSLog(@"MusicaController iTunes is stopped");
    }
    
    //temp fix for waiting for app to load artwork
    //NSImage *artwork = [self updateArtwork];
    if (iTunesUsable) {
        EyeTunes *e = [EyeTunes sharedInstance];
        ETTrack *track = [e currentTrack];
		// register variables and callbacks with the theme
		player.playerPosition = [NSNumber numberWithInt:[e playerPosition]];
		[player setPlayCallback:^(){
			[e play];
		}];
		[player setPlayPauseCallback:^(){
			[e playPause];
		}];
		[player setPauseCallback:^(){
			[e play];
		}];
        if ([track name]==NULL) {
            NSLog(@"MusicaController No music is playing");
            //[self updateArtwork];
            // Reset these values because nothing is playing
            previousAlbum = nil;
            previousTrack = nil;
            NSLog(@"MusicaController Did we get called after animation has started");
        }
        if (![[track album] isEqualToString:previousAlbum] && [track album] != NULL) {
            // Bounce the window when the album changes.
            // http://www.allocinit.net/blog/2005/12/06/ripplin/
            //[self updateArtwork];
            AWRippler *rippler;
            rippler = [[AWRippler alloc] init];
            [rippler rippleWindow:window];
            
            NSLog(@"MusicaController Did we get called after animation has started");
            previousAlbum = [track album];
			[self trackChanged:track];
			[self updateArtwork];
        }
        if (![[track name] isEqualToString:previousTrack] && [track name] != NULL) {
            NSLog(@"MusicaController Track changed to: %@", [track name]);
            previousTrack = [track name];
			[self trackChanged:track];
			//NSImage *artwork = [self updateArtwork];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableNotifications"]) {
                NSUserNotification *notification = [[NSUserNotification alloc] init];
                [notification setTitle:[track name]];
				[notification setSubtitle:[track artist]];
				[notification setContentImage:previousTrackArtwork];
				[notification setInformativeText:[track album]];
                NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
                [center scheduleNotification:notification];
            }
        }
    }
    if (rdioUsable) {
        RdioTrack *track = [Rdio currentTrack];
        if ([track name]==NULL) {
            NSLog(@"MusicaController No music is playing");
            //[self updateArtwork];
            // Reset these values because nothing is playing
            previousAlbum = nil;
            previousTrack = nil;
            NSLog(@"MusicaController Did we get called after animation has started");
        }
        if (![[track album] isEqualToString:previousAlbum] && [track album] != NULL) {
            // Bounce the window when the album changes.
            // http://www.allocinit.net/blog/2005/12/06/ripplin/
            //[self updateArtwork];
            AWRippler *rippler;
            rippler = [[AWRippler alloc] init];
            [rippler rippleWindow:window];
            
            NSLog(@"MusicaController Did we get called after animation has started");
            previousAlbum = [track album];
			[self updateArtwork];
        }
        if (![[track name] isEqualToString:previousTrack] && [track name] != NULL) {
            NSLog(@"MusicaController Track changed to: %@", [track name]);
            previousTrack = [track name];
			//[self updateArtwork];
        }
    }
    if (spotifyUsable) {
        SpotifyTrack *track = [Spotify currentTrack];
		// register variables and callbacks with the theme
		player.playerPosition = [NSNumber numberWithDouble:[Spotify playerPosition]];
		__weak typeof(Spotify) weakSpotify = Spotify;
		[player setPlayCallback:^(){
			[weakSpotify play];
		}];
		[player setPlayPauseCallback:^(){
			[weakSpotify playpause];
		}];
		[player setPauseCallback:^(){
			[weakSpotify pause];
		}];
        if ([track name]==NULL) {
            NSLog(@"MusicaController No music is playing");
            //[self updateArtwork];
            // Reset these values because nothing is playing
            previousAlbum = nil;
            previousTrack = nil;
            NSLog(@"MusicaController Did we get called after animation has started");
        }
        if (![[track album] isEqualToString:previousAlbum] && [track album] != NULL) {
            // Bounce the window when the album changes.
            // http://www.allocinit.net/blog/2005/12/06/ripplin/
            //[self updateArtwork];
            AWRippler *rippler;
            rippler = [[AWRippler alloc] init];
            [rippler rippleWindow:window];
            
            NSLog(@"MusicaController Did we get called after animation has started");
            previousAlbum = [track album];
			[self updateArtwork];
        }
        if (![[track name] isEqualToString:previousTrack] && [track name] != NULL) {
            NSLog(@"MusicaController Track changed to: %@", [track name]);
            previousTrack = [track name];
			[self trackChanged:track];
			//NSImage *artwork = [self updateArtwork];
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableNotifications"]) {
                NSUserNotification *notification = [[NSUserNotification alloc] init];
                [notification setTitle:[track name]];
				[notification setSubtitle:[track artist]];
				[notification setContentImage:previousTrackArtwork];
				[notification setInformativeText:[track album]];
                NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
                [center scheduleNotification:notification];
            }
        }
    }
    if (radiumUsable) {
        //RadiumRplayer *track = [Radium player];
		// register variables and callbacks with the theme
		__weak typeof(Radium) weakRadium = Radium;
		[player setPlayCallback:^(){
			[weakRadium play];
		}];
		[player setPlayPauseCallback:^(){
			[weakRadium playpause];
		}];
		[player setPauseCallback:^(){
			[weakRadium pause];
		}];
        if ([Radium trackName]==NULL) {
            NSLog(@"MusicaController No music is playing");
            //[self updateArtwork];
            // Reset these values because nothing is playing
            previousAlbum = nil;
            previousTrack = nil;
            NSLog(@"MusicaController Did we get called after animation has started");
        }
        if (![[Radium trackName] isEqualToString:previousTrack] && [Radium trackName] != NULL) {
            if ([Radium trackArtwork]!=nil) {
                // Bounce the window when the album changes.
                // http://www.allocinit.net/blog/2005/12/06/ripplin/
                [self updateArtwork];
                AWRippler *rippler;
                rippler = [[AWRippler alloc] init];
                [rippler rippleWindow:window];
            }
            NSLog(@"MusicaController Track changed to: %@", [Radium trackName]);
            previousTrack = [Radium trackName];
			[self trackChanged:Radium];
			[self updateArtwork];
        }
    }
	// update theme status
	[webView stringByEvaluatingJavaScriptFromString:[[NSString alloc] initWithFormat:@"%@()",themeDictionary[@"BTStatusFunction"]]];
}

- (BOOL)image:(NSImage *)image1 isEqualTo:(NSImage *)image2
{
    NSData *data1 = [image1 TIFFRepresentation];
    NSData *data2 = [image2 TIFFRepresentation];
	
    return [data1 isEqual:data2];
}

-(NSImage*)updateArtwork {
    if (([EyeTunes isRunning] && chosenPlayer==audioPlayeriTunes) || ([EyeTunes isRunning] && resolvingConflict==NO)) {
		EyeTunes *e = [EyeTunes sharedInstance];
		ETTrack *currentTrack = [e currentTrack];
		NSArray *artworks = [currentTrack artwork];
		
		if ([artworks count] > 0) 
		{
			NSLog(@"MusicaController Artwork found");
			
			if ([self image:previousTrackArtwork isEqualTo:[artworks objectAtIndex:0]])
			{
				return previousTrackArtwork;
			}
			NSImage *albumImage = [artworks objectAtIndex:0];
			previousTrackArtwork = albumImage;
			albumData = [albumImage TIFFRepresentation];
			[webView stringByEvaluatingJavaScriptFromString:[[NSString alloc] initWithFormat:@"%@('data:image/tiff;base64,%@')", themeDictionary[@"BTArtworkFunction"], [albumData base64Encoding]]];
			[imageView setImage:albumImage];
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableDockArt"]) {
				// Overlay icon over album art
				/*NSImage *resultImage = [albumImage copy];
                 [resultImage lockFocus];
                 
                 NSImage* defaultImage = [NSImage imageNamed: @"Overlay"];
                 [defaultImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
                 // Or any of the other about 6 options; see Apple's guide to pick.
                 
                 [resultImage unlockFocus];
                 [NSApp setApplicationIconImage: resultImage];*/
				[NSApp setApplicationIconImage: albumImage];
			}
			return albumImage;
		}
		else {
			NSLog(@"MusicaController No artwork found");
			if ([self image:previousTrackArtwork isEqualTo:[NSImage imageNamed:@"MissingArtwork.png"]])
			{
				return previousTrackArtwork;
			}
			NSImage *albumImage = [NSImage imageNamed:@"MissingArtwork.png"];
			previousTrackArtwork = albumImage;
			albumData = [albumImage TIFFRepresentation];
			[imageView setImage:albumImage];
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableDockArt"]) {
				//[NSApp setApplicationIconImage: albumImage];
				[NSApp setApplicationIconImage:[NSImage imageNamed:@"NSImageNameApplicationIcon"]];
			}
			return albumImage;
		}
	}
    if (([Rdio isRunning] && chosenPlayer==audioPlayerRdio) || ([Rdio isRunning] && resolvingConflict==NO)) {
        //NSLog(@"RDIO IMAGE DATA!!!");
        //NSData *data = [[Rdio currentTrack] artwork];
        //NSLog(@"data: %@", data);
		if ([self image:previousTrackArtwork isEqualTo:[[Rdio currentTrack] artwork]])
		{
			return previousTrackArtwork;
		}
        NSImage *albumImage = [[Rdio currentTrack] artwork]; //[[NSImage alloc] initWithData:data];
		previousTrackArtwork = albumImage;
        albumData = [albumImage TIFFRepresentation];
		[webView stringByEvaluatingJavaScriptFromString:[[NSString alloc] initWithFormat:@"%@('data:image/tiff;base64,%@')", themeDictionary[@"BTArtworkFunction"], [albumData base64Encoding]]];
        [imageView setImage:albumImage];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableDockArt"]) {
            [NSApp setApplicationIconImage: albumImage];
        }
        if ([[Rdio currentTrack] artwork]==nil) {
            NSLog(@"MusicaController No artwork found");
            // ignore the warning here. it makes no sense the type returned is actually NSImage
            if ([self image:previousTrackArtwork isEqualTo:[NSImage imageNamed:@"MissingArtwork.png"]])
			{
				return previousTrackArtwork;
			}
			NSImage *albumImage = [NSImage imageNamed:@"MissingArtwork.png"];
			previousTrackArtwork = albumImage;
            albumData = [albumImage TIFFRepresentation];
            [imageView setImage:albumImage];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableDockArt"]) {
                //[NSApp setApplicationIconImage: albumImage];
                [NSApp setApplicationIconImage:[NSImage imageNamed:@"NSImageNameApplicationIcon"]];
            }
        }
		return albumImage;
    }
    if (([Spotify isRunning] && chosenPlayer==audioPlayerSpotify) || ([Spotify isRunning] && resolvingConflict==NO)) {
        //NSLog(@"SPOTIFY IMAGE DATA!!!");
		if ([self image:previousTrackArtwork isEqualTo:[[Spotify currentTrack] artwork]])
		{
			return previousTrackArtwork;
		}
        NSImage *albumImage = [[Spotify currentTrack] artwork];
		previousTrackArtwork = albumImage;
        albumData = [albumImage TIFFRepresentation];
		[webView stringByEvaluatingJavaScriptFromString:[[NSString alloc] initWithFormat:@"%@('data:image/tiff;base64,%@')", themeDictionary[@"BTArtworkFunction"], [albumData base64Encoding]]];
        [imageView setImage:albumImage];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableDockArt"]) {
            [NSApp setApplicationIconImage: albumImage];
        }
        if ([[Spotify currentTrack] artwork]==nil) {
            NSLog(@"MusicaController No artwork found");
            if ([self image:previousTrackArtwork isEqualTo:[NSImage imageNamed:@"MissingArtwork.png"]])
			{
				return previousTrackArtwork;
			}
			NSImage *albumImage = [NSImage imageNamed:@"MissingArtwork.png"];
			previousTrackArtwork = albumImage;
            albumData = [albumImage TIFFRepresentation];
            [imageView setImage:albumImage];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableDockArt"]) {
                //[NSApp setApplicationIconImage: albumImage];
                [NSApp setApplicationIconImage:[NSImage imageNamed:@"NSImageNameApplicationIcon"]];
            }
        }
		return albumImage;
    }
    if (([Radium isRunning] && chosenPlayer==audioPlayerRadium) || ([Radium isRunning] && resolvingConflict==NO)) {
        //NSLog(@"Radium awesomeness");
		if ([self image:previousTrackArtwork isEqualTo:[Radium trackArtwork]])
		{
			return previousTrackArtwork;
		}
        NSImage *albumImage = [Radium trackArtwork];
		previousTrackArtwork = albumImage;
        albumData = [albumImage TIFFRepresentation];
		[webView stringByEvaluatingJavaScriptFromString:[[NSString alloc] initWithFormat:@"%@('data:image/tiff;base64,%@')", themeDictionary[@"BTArtworkFunction"], [albumData base64Encoding]]];
        [imageView setImage:albumImage];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableDockArt"]) {
            [NSApp setApplicationIconImage: albumImage];
        }
        if ([Radium trackArtwork]==nil) {
            NSLog(@"MusicaController No artwork found");
            if ([self image:previousTrackArtwork isEqualTo:[NSImage imageNamed:@"MissingArtwork.png"]])
			{
				return previousTrackArtwork;
			}
			NSImage *albumImage = [NSImage imageNamed:@"MissingArtwork.png"];
			previousTrackArtwork = albumImage;
            albumData = [albumImage TIFFRepresentation];
            [imageView setImage:albumImage];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableDockArt"]) {
                //[NSApp setApplicationIconImage: albumImage];
                [NSApp setApplicationIconImage:[NSImage imageNamed:@"NSImageNameApplicationIcon"]];
            }
        }
		return albumImage;
    }
	return nil;
}

#pragma mark -
#pragma mark Theming

- (IBAction)loadThemeFromFile:(id)sender
{
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setCanChooseFiles:YES];
	[panel setCanChooseDirectories:YES];
	[panel setAllowsMultipleSelection:NO]; // yes if more than one dir is allowed
	
	NSInteger clicked = [panel runModal];
	
	if (clicked == NSFileHandlingPanelOKButton) {
		// TODO: read the plist's location for the main html file
		themeDictionary = [NSDictionary dictionaryWithContentsOfURL:[[panel URL] URLByAppendingPathComponent:@"Info.plist"]];
		NSURL *indexFile = [[panel URL] URLByAppendingPathComponent:themeDictionary[@"BTMainFile"]];
		[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:indexFile]];
	}
}

- (void)trackChanged:(id)track
{
	WebScriptObject *scriptObject = [webView windowScriptObject];
	Track *theTrack = [[Track alloc] init];
	if ([track isMemberOfClass:[ETTrack class]]) {
		[theTrack setTitle:((ETTrack*)track).name];
		[theTrack setAlbum:((ETTrack*)track).album];
		[theTrack setArtist:((ETTrack*)track).albumArtist];
		[theTrack setGenre:((ETTrack*)track).genre];
		[theTrack setLength:[NSNumber numberWithInt:((ETTrack*)track).duration]];
	}
	if ([[track className] isEqualToString:@"SpotifyTrack"])
	{
		[theTrack setTitle:((SpotifyTrack*)track).name];
		[theTrack setAlbum:((SpotifyTrack*)track).album];
		[theTrack setArtist:((SpotifyTrack*)track).artist];
		[theTrack setGenre:@""];
		[theTrack setLength:[NSNumber numberWithInt:((SpotifyTrack*)track).duration]];
	}
	if ([[track className] isEqualToString:@"Radium"])
	{
		[theTrack setTitle:[Radium trackName]];
		[theTrack setAlbum:@""];
		[theTrack setArtist:[Radium stationName]];
		[theTrack setGenre:@""];
		[theTrack setLength:@0];
	}
	player.currentTrack = theTrack;
	[scriptObject setValue:theTrack forKey:@"theTrack"];
	NSString *trackScript = [[NSString alloc] initWithFormat:@"%@(window.theTrack);",themeDictionary[@"BTTrackFunction"]];
	[webView stringByEvaluatingJavaScriptFromString:trackScript];
	[scriptObject removeWebScriptKey:@"theTrack"];
	// redraw the screen.. keep artifcats from gathering
	[webView display];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
	[[webView windowScriptObject] setValue:player forKey:@"Player"];
	[webView stringByEvaluatingJavaScriptFromString:@"var Player = window.Player; var iTunes = window.Player;"];
	// reset the previous track and artwork so that it force a reload of the info into the theme
	previousTrack = nil;
	previousTrackArtwork = nil;
	[self updateArtwork];
	[webView stringByEvaluatingJavaScriptFromString:[[NSString alloc] initWithFormat:@"%@();",themeDictionary[@"BTReadyFunction"]]];
}

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element
    defaultMenuItems:(NSArray *)defaultMenuItems
{
    // disable right-click context menu
    return nil;
}

- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange
	 toDOMRange:(DOMRange *)proposedRange
	   affinity:(NSSelectionAffinity)selectionAffinity
 stillSelecting:(BOOL)flag
{
    // disable text selection
    return NO;
}

#pragma mark -
#pragma mark IBActions

- (IBAction) prev:(id)sender
{
	if (([EyeTunes isRunning] && chosenPlayer==audioPlayeriTunes) || ([EyeTunes isRunning] && resolvingConflict==NO)) {
		[[EyeTunes sharedInstance] previousTrack];
	}
    if (([Rdio isRunning] && chosenPlayer==audioPlayerRdio) || ([Rdio isRunning] && resolvingConflict==NO)) {
        [Rdio previousTrack];
    }
    if (([Spotify isRunning] && chosenPlayer==audioPlayerSpotify) || ([Spotify isRunning] && resolvingConflict==NO)) {
        [Spotify previousTrack];
    }
}

- (IBAction) next:(id)sender
{
	if (([EyeTunes isRunning] && chosenPlayer==audioPlayeriTunes) || ([EyeTunes isRunning] && resolvingConflict==NO)) {
		[[EyeTunes sharedInstance] nextTrack];
	}
    if (([Rdio isRunning] && chosenPlayer==audioPlayerRdio) || ([Rdio isRunning] && resolvingConflict==NO)) {
        [Rdio nextTrack];
    }
    if (([Spotify isRunning] && chosenPlayer==audioPlayerSpotify) || ([Spotify isRunning] && resolvingConflict==NO)) {
        [Spotify nextTrack];
    }
}

- (IBAction) playPause:(id)sender
{
	if (([EyeTunes isRunning] && chosenPlayer==audioPlayeriTunes) || ([EyeTunes isRunning] && resolvingConflict==NO)) {
        [[EyeTunes sharedInstance] playPause];
    }
    if (([Rdio isRunning] && chosenPlayer==audioPlayerRdio) || ([Rdio isRunning] && resolvingConflict==NO)) {
        [Rdio playpause];
    }
    if (([Spotify isRunning] && chosenPlayer==audioPlayerSpotify) || ([Spotify isRunning] && resolvingConflict==NO)) {
        [Spotify playpause];
    }
    if (([Radium isRunning] && chosenPlayer==audioPlayerRadium) || ([Radium isRunning] && resolvingConflict==NO)) {
        [Radium playpause];
    }
}

- (IBAction)openPreferences:(id)sender {
	// lazy load the PreferencesController
	if (!self.preferencesController) {
		PreferencesController *pC = [[PreferencesController alloc] init];
		self.preferencesController =  pC;
	}
	
	[self.preferencesController showWindow:self];
}

- (IBAction)resizeWindow:(id)sender {
	NSLog(@"MusicaController Resizing window");
	NSRect windowFrame = [[self window] frame];
	if (windowFrame.size.width < 170*4) {
		windowFrame.size.width = windowFrame.size.width*2;
		windowFrame.size.height = windowFrame.size.height*2;
		[[self window] setFrame:windowFrame display:YES animate:YES];
	}
	else {
		windowFrame.size.width = 170;
		windowFrame.size.height = 170;
		[[self window] setFrame:windowFrame display:YES animate:YES];
		// Window will never detect mouse leave because the window resizes to a smaller size
		// So hide the controls
		// Putting it here and not the when getting bigger makes more sense
		// People are less likely to move the mouse cursor out really fast
	}
	// Might have to remove previous tracking area by setting it as a instance variable
	[self updateTrackingArea];
}

#pragma mark -

// Play/pause on Dock Icon Click if we are in minimal mode
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender
                    hasVisibleWindows:(BOOL)flag
{
    /*NSBeep();
    NSLog(@"Hi");*/
    // play/pause music here
    //[self playPause:nil];
    
    return YES;
}

@end
