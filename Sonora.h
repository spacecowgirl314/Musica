/*
 * Sonora.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class SonoraApplication, SonoraApplication;



/*
 * Standard Suite
 */

// The application's top level scripting object.
@interface SonoraApplication : SBApplication

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the frontmost (active) application?
@property (copy, readonly) NSString *version;  // The version of the application.

- (void) quit;  // Quit an application.
- (void) pause;  // Pause playback.
- (void) play;  // Begin playback.
- (void) playpause;  // Toggle playback between playing and paused.
- (void) stop;  // Stop playback and clear the queue.
- (void) next;  // Skip to the next track in the queue.
- (void) previous;  // Skip to the previous track in the queue.
- (void) shuffle;  // Shuffle the tracks in the queue.

@end



/*
 * Sonora Suite
 */

// The application's top-level scripting object.
@interface SonoraApplication (SonoraSuite)

@property (readonly) NSInteger playerState;  // Player state (playing = 2, paused = 1, or stopped = 0)
@property (copy, readonly) NSString *track;  // Current track title.
@property (copy, readonly) NSString *artist;  // Current track artist.
@property (copy, readonly) NSString *albumArtist;  // Current track album artist.
@property (copy, readonly) NSString *album;  // Current track album.
@property (copy, readonly) NSData *jpegArtworkData;  // Current track artwork data in JPEG format.
@property (copy, readonly) NSData *tiffArtworkData;  // Current track artwork data in TIFF format.
@property (copy, readonly) NSImage *artworkImage;  // Current track artwork as an image.
@property (copy, readonly) NSString *uniqueID;  // Unique identifier for the current track.
@property double currentTime;  // The current playback position.
@property (readonly) double totalTime;  // The total time of the currenty playing track.
@property double playerVolume;  // Player volume (0.0 to 1.0)
@property NSInteger repeatState;  // Player repeat state (none = 0, repeat one = 1, repeat all = 2)

@end

