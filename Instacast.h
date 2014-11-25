/*
 * Instacast.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class InstacastApplication, InstacastPodcast, InstacastEpisode;



/*
 * Instacast Script Suite
 */

// The application's top-level scripting object.
@interface InstacastApplication : SBApplication

- (SBElementArray *) podcasts;

@property (readonly) BOOL playing;
@property double audioVolume;  // Playback volume between 0 and 1
@property (copy, readonly) InstacastEpisode *currentEpisode;
@property (readonly) double playableDuration;
@property double playerTime;

- (void) play;  // Starts playing if possible
- (void) pause;  // Stops playing
- (void) playpause;
- (void) skipForward;
- (void) skipBackward;
- (void) volumeUp;
- (void) volumeDown;

@end

@interface InstacastPodcast : SBObject

- (SBElementArray *) episodes;

@property (copy, readonly) NSString *title;
@property (copy, readonly) NSString *author;
@property (copy, readonly) NSString *link;


@end

@interface InstacastEpisode : SBObject

@property (copy, readonly) NSString *title;
@property (copy, readonly) InstacastPodcast *podcast;
@property (copy, readonly) NSString *cleanTitle;
@property NSInteger duration;
@property (copy, readonly) NSData *artwork;


@end

