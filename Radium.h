/*
 * Radium.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class RadiumApplication, RadiumApplication, RadiumRplayer;



/*
 * Standard Suite
 */

// Radium's top level scripting object.
@interface RadiumApplication : SBApplication

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the frontmost (active) application?
@property (copy, readonly) NSString *version;  // The version of the application.

- (void) quit;  // Quit an application.

@end



/*
 * Radium Suite
 */

// Radium's top level scripting object
@interface RadiumApplication (RadiumSuite)

@property (copy, readonly) RadiumRplayer *player;  // Player

@end

// Radium's playback component
@interface RadiumRplayer : SBObject

@property (copy, readonly) NSString *songTitle;  // Currently playing song
@property (copy, readonly) NSImage *songArtwork;  // Currently playing song artwork (if available)
@property (copy, readonly) NSString *channelName;  // Currently playing channel
@property (copy, readonly) NSString *networkName;  // Radio network the currently playing channel belongs to
@property (readonly) BOOL playing;  // Is Radium playing anything?

- (void) playPause;  // Play/pause.
- (void) tuneInTo:(NSString *)to;  // Tune in to a media URL or magnet link.

@end

