//
//  MusicaController.h
//  Musica
//
//  Created by Chloe Stars on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import <EyeTunes/EyeTunes.h>
#import <WebKit/WebKit.h>
#import <Scribbler/Scribbler.h>
#import "PreferencesController.h"
#import "TrayMenu.h"
#import "iTunes.h"
#import "Instacast.h"
#import "Rdio.h"
#import "Spotify.h"
#import "Radium.h"
#import "Vox.h"
#import "Player.h"
#import "Bowtie.h"
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

@interface MusicaController : NSObject <NSApplicationDelegate> {
	IBOutlet NSWindow *window;
	IBOutlet WebView *webView;
	NSString *previousTrack;
	NSString *previousAlbum;
	NSImage *previousTrackArtwork;
	NSData *albumData;
	NSStatusItem *theItem;
	NSTimer *fadeInTimer;
    NSTimer *fadeOutTimer;
	NSMutableArray *musicaServices;
	NSDictionary *themeDictionary;
	NSMutableDictionary *themeStore;
    
    // Bridges
	//iTunesApplication *iTunes;
    InstacastApplication *Instacast;
    RdioApplication *Rdio;
    SpotifyApplication *Spotify;
    RadiumApplication *Radium;
    VoxApplication *Vox;

    TrayMenu *menu;
	Player *player;
	Bowtie *bowtie;
	LFWebService *lfmWebService;
	
	// Controllers
	PreferencesController *preferencesController;
    
    NSMutableArray *audioPlayers;
    BOOL resolvingConflict;
    audioPlayer chosenPlayer;
}

-(id)init;

-(void)monitorTunes;
-(NSImage*)updateArtwork;
-(void)restoreWindowPosition;

@property IBOutlet NSWindow *window; //unsafe_unretained
@property (strong, nonatomic) PreferencesController *preferencesController;

- (IBAction)openPreferences:(id)sender;
- (IBAction)loadThemeFromFile:(id)sender;

@end
