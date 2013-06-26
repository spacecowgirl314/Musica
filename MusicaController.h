//
//  MusicaController.h
//  Musica
//
//  Created by Chloe Stars on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import <EyeTunes/EyeTunes.h>
#import <Carbon/Carbon.h>
#import "PreferencesController.h"
#import "TrayMenu.h"
#import "iTunes.h"
#import "Rdio.h"
#import "Spotify.h"
#import "Radium.h"
#import "AWRippler.h"
#import "QuickClickImage.h"
#import "EnumDefinitions.h"

/**
 Preferences keys
 
 musicaDocked dock musica to the sides of the screen X
 musicaAutostart start on login
 musicaMenuBar put musica in menu bar
 musicaWindowMode an integer from NSPopUpButton selection
 musicaAlwaysShow don't show musica if no music is playing
 musicaEnableNotifications Enables Growl notifications
 musicaFirstRun Used to set up the default settings
 */

/*typedef enum {
    audioPlayeriTunes = 'iTunes',
    audioPlayerSpotify = 'Spotify',
    audioPlayerRdio = 'Rdio',
    audioPlayerRadium = 'Radium'
} audioPlayer;*/

@interface MusicaController : NSObject <NSNetServiceDelegate, NSNetServiceBrowserDelegate, NSConnectionDelegate, NSApplicationDelegate> {
	IBOutlet NSImageView *imageView;
    IBOutlet NSImageView *buttonBar;
	IBOutlet NSButton *pauseButton;
	IBOutlet NSButton *previousButton;
	IBOutlet NSButton *nextButton;
	IBOutlet NSButton *resizeButton;
    IBOutlet NSButton *infoButton;
	IBOutlet NSWindow *__unsafe_unretained window;
    IBOutlet QuickClickImage *glossOverlay;
	NSString *previousTrack;
	NSString *previousAlbum;
	NSData *albumData;
	NSStatusItem *theItem;
	NSTimer *fadeInTimer;
    NSTimer *fadeOutTimer;
	NSMutableArray *pluginInstances;
	NSManagedObjectContext *remoteMusicaContext;
	NSMutableArray *musicaServices;
	NSTrackingArea *myTrackingArea;
	//iTunesApplication *iTunes;
    RdioApplication *Rdio;
    SpotifyApplication *Spotify;
    RadiumApplication *Radium;
	BOOL mouseInWindow;
    TrayMenu *menu;
	
	// controllers
	PreferencesController *preferencesController;
    
    //title bar
    NSButton *closeButton;
    NSMutableArray *audioPlayers;
    BOOL resolvingConflict;
    audioPlayer chosenPlayer;
}

-(id)init;

- (NSDictionary *) registrationDictionaryForGrowl;

-(void)monitorTunes;
-(NSImage*)updateArtwork;
-(void)loadBundles;
-(void)restoreWindowPosition;
-(void)updateTrackingArea;
-(int)updateArtistInfoWindow;

-(NSString*)currentTrack;

@property (unsafe_unretained) IBOutlet NSWindow *window; //unsafe_unretained
@property (strong, nonatomic) PreferencesController *preferencesController;

- (IBAction) prev:(id)sender;
- (IBAction) next:(id)sender;
- (IBAction) playPause:(id)sender;
- (IBAction) openPreferences:(id)sender;
- (IBAction) openArtistInfo:(id)sender;
- (IBAction) resizeWindow:(id)sender;

@end
