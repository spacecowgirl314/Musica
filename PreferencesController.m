//
//  PreferencesController.m
//  Musica
//
//  Created by Chloe Stars on 9/10/10.
//  Copyright 2010 Ozipto. All rights reserved.
//

#import "PreferencesController.h"
#import "Theme.h"
#import "NSFileManager+DirectoryLocations.h"

#define kFakePBoardType @"fakePBoardType"

@implementation PreferencesController
@synthesize musicaWindowButton;

-(id)init
{
	if (![super initWithWindowNibName:@"Preferences"]) {
		return nil;
	}
	return self;
}

- (void)setStartAtLogin:(NSURL *)bundleURL enabled:(BOOL)enabled {
	// Creating helper app complete URL
	NSURL *url = [bundleURL URLByAppendingPathComponent:
                  @"Contents/Library/LoginItems/MusicaHelper.app"];
    
	// Registering helper app
	if (LSRegisterURL((__bridge_retained CFURLRef)url, true) != noErr) {
		NSLog(@"PreferencesController LSRegisterURL failed!");
	}
    
	// Setting login
	if (!SMLoginItemSetEnabled((CFStringRef)@"com.ozipto.MusicaHelper",
                               enabled)) {
		NSLog(@"PreferencesController SMLoginItemSetEnabled failed!");
	}
}

-(void)awakeFromNib {
	// Bring the window above Musica.
	[[self window] setLevel:NSModalPanelWindowLevel];
	NSLog(@"PreferencesController Preferences awoke from Nib");
    
    // Select default view toolbar button
    [toolbar setSelectedItemIdentifier:@"generalPreferences"];
    //mojo to get the right frame for the new window.
    NSRect newFrame = [[self window] frame];
    float vdiff = ([generalView frame].size.height - [[[self window] contentView] frame].size.height) * [[self window] userSpaceScaleFactor];
    newFrame.origin.y -= vdiff;
    newFrame.size.height += vdiff;
    float hdiff = ([generalView frame].size.width - [[[self window] contentView] frame].size.width) * [[self window] userSpaceScaleFactor];
    newFrame.size.width += hdiff;
    
    //set the frame to newFrame and animate it. (change animate:YES to animate:NO if you don't want this)
    [[self window] setShowsResizeIndicator:YES];
    [[self window] setFrame:newFrame display:YES animate:YES];
    //set the main content view to the new view we have picked through the if structure above.
    [[self window] setContentView:generalView];
    
	[musicaWindowButton selectItemAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"musicaWindowMode"]];
    // make sure key exists or ignore it
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"musicaAutostart"]==Nil) {
        // switch to off by default if never been set before
        loginSwitch.selectedSegment = 1;
    } else {
        loginSwitch.selectedSegment = (int)[[NSUserDefaults standardUserDefaults] boolForKey:@"musicaAutostart"];
    }
}

-(IBAction)segmentAction:(id)sender {
    // The segmented control was clicked, handle it here
    NSSegmentedControl *segmentedControl = (NSSegmentedControl *)sender;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:(BOOL)segmentedControl.selectedSegment forKey:@"musicaAutostart"];
    [standardUserDefaults synchronize];
    // and update login item
    NSLog(@"PreferencesController Action for the segment");
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"musicaAutostart"]) {
        NSLog(@"PreferencesController Being set to login");
        NSLog(@"PreferencesController Path thingy: %@", [[NSBundle mainBundle] bundlePath]);
        [self setStartAtLogin:[[NSBundle mainBundle] bundleURL] enabled:YES];
	} else {
        NSLog(@"PreferencesController Being remove from login");
        [self setStartAtLogin:[[NSBundle mainBundle] bundleURL] enabled:NO];
	}
}

-(IBAction)relaunch:(id)sender {
	NSLog(@"PreferencesController Relauching");
	//[NSApp relaunch:sender];
}

/*-(IBAction)toggleLoginItem:(id)sender {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaAutostart"]) {
		LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
		[launchController setLaunchAtLogin:YES];
	} else {
		LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
		[launchController setLaunchAtLogin:NO];
	}
}*/

-(IBAction)toggleShowingMusica:(id)sender
{
    NSLog(@"PreferencesController toggling showing Musica");
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    //simply update the global instance reading of defaults
    [standardUserDefaults synchronize];
}

-(IBAction)toggleDockArt:(id)sender {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaEnableDockArt"]) {
		//[super updateArtwork];
	}
}

-(IBAction)selectedWindowMode:(id)sender {
	NSInteger selectedIndex = [musicaWindowButton indexOfSelectedItem];
	NSLog(@"PreferencesController Selected Index (%ld)",selectedIndex);
	[[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:@"musicaWindowMode"];
	// Send notice that we have changed window mode an that it needs to be reloaded to reflect this
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeWindowMode" object:self];
}

-(IBAction)gotoPluginWebpage:(id)sender {
	NSURL *url = [ [ NSURL alloc ] initWithString: @"http://ozipto.com/?page_id=347" ];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

//called everytime a toolbar item is cilcked. If nil, return the default ("General").
- (IBAction)switchViews:(NSToolbarItem *)item
{
    NSLog(@"PreferencesController We Got Called from %@", [item label]);
    NSString *sender;
    if(item == nil){  //set the pane to the default.
        sender = @"General";
        [toolbar setSelectedItemIdentifier:sender];
    }else{
        sender = [item label];
    }
    
    //make a temp pointer.
    NSView *prefsView;
    
    NSLog(@"PreferencesController Sender: %@", sender);
    
    //set the title to the name of the Preference Item.
    [[self window] setTitle:sender];
    
    if([sender isEqualToString:@"General"]){
        //assign the temp pointer to the generalView we set up in IB.
        prefsView = generalView;
    }else if([sender isEqualToString:@"Themes"]){
		[themeLoader reload];
        //assign the temp pointer to the appearanceView we set up in IB.
        prefsView = themesView;
    }
    
    //to stop flicker, we make a temp blank view.
    NSView *tempView = [[NSView alloc] initWithFrame:[[[self window] contentView] frame]];
    [[self window] setContentView:tempView];
    
    //mojo to get the right frame for the new window.
    NSRect newFrame = [[self window] frame];
    float vdiff = [prefsView frame].size.height - [[[self window] contentView] frame].size.height;
    newFrame.origin.y -= vdiff;
    newFrame.size.height += vdiff;
    float hdiff = [prefsView frame].size.width - [[[self window] contentView] frame].size.width;
    newFrame.size.width += hdiff;
    
    //set the frame to newFrame and animate it. (change animate:YES to animate:NO if you don't want this)
    [[self window] setShowsResizeIndicator:YES];
    [[self window] setFrame:newFrame display:YES animate:YES];
    //set the main content view to the new view we have picked through the if structure above.
    [[self window] setContentView:prefsView];
}

@end
