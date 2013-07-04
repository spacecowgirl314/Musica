/*
 * Ecoute.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class EcouteApplication, EcouteWindow, EcouteTrack;

enum EcouteECMediaKind {
	EcouteECMediaKindMusic = 'KdMs' /* Music */,
	EcouteECMediaKindMovie = 'KdMv' /* Movie */,
	EcouteECMediaKindTVShow = 'KdTV' /* TV Show */,
	EcouteECMediaKindPodcast = 'KdPc' /* Podcast */,
	EcouteECMediaKindMusicVideo = 'KdMV' /* Music Video */,
	EcouteECMediaKindAudiobook = 'KdAB' /* Audiobook */
};
typedef enum EcouteECMediaKind EcouteECMediaKind;

enum EcouteECPlayerState {
	EcouteECPlayerStateStopped = 'PSTs',
	EcouteECPlayerStatePaused = 'PSTp' /* Paused */,
	EcouteECPlayerStatePlaying = 'PSTl' /* Playing */
};
typedef enum EcouteECPlayerState EcouteECPlayerState;

enum EcouteECPlayerRepeatMode {
	EcouteECPlayerRepeatModeRepeatNone = 'PRMn' /* Repeat None */,
	EcouteECPlayerRepeatModeRepeatAll = 'PRMa' /* Repeat All */,
	EcouteECPlayerRepeatModeRepeatOne = 'PRMo' /* Repeat One */
};
typedef enum EcouteECPlayerRepeatMode EcouteECPlayerRepeatMode;



/*
 * Standard Suite
 */

// The application's top-level scripting object.
@interface EcouteApplication : SBApplication

- (SBElementArray *) windows;

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the frontmost (active) application?
@property (copy, readonly) NSString *version;  // The version of the application.

- (void) quit;  // Quit the application.
- (void) backTrack;  // reposition to beginning of current track or go to previous track if already at start of current track
- (void) nextTrack;  // advance to the next track in the current playlist
- (void) pause;  // pause playback
- (void) playpause;  // toggle the playing/paused state of the current track
- (void) resume;  // resume playback

@end

// A window.
@interface EcouteWindow : SBObject

@property (copy, readonly) NSString *name;  // The full title of the window.
- (NSInteger) id;  // The unique identifier of the window.
@property NSInteger index;  // The index of the window, ordered front to back.
@property NSRect bounds;  // The bounding rectangle of the window.
@property (readonly) BOOL closeable;  // Whether the window has a close box.
@property (readonly) BOOL minimizable;  // Whether the window can be minimized.
@property BOOL minimized;  // Whether the window is currently minimized.
@property (readonly) BOOL resizable;  // Whether the window can be resized.
@property BOOL visible;  // Whether the window is currently visible.
@property (readonly) BOOL zoomable;  // Whether the window can be zoomed.
@property BOOL zoomed;  // Whether the window is currently zoomed.


@end



/*
 * Ecoute Suite
 */

@interface EcouteApplication (EcouteSuite)

@property (copy, readonly) EcouteTrack *currentTrack;  // the current playing track
@property NSInteger playerPosition;  // the player’s position within the currently playing track in seconds.
@property (readonly) EcouteECPlayerState playerState;  // is Ecoute stopped, paused, or playing, as ECPlayerState value
@property (copy, readonly) NSString *playerStateValue;  // is Ecoute stopped, paused, or playing, as text value
@property EcouteECPlayerRepeatMode repeatMode;  // repeat mode kind
@property NSInteger soundVolume;  // the sound output volume (from 0 to 100)
@property BOOL shuffle;  // is shuffle currently enabled?

@end

// This class represents a track.
@interface EcouteTrack : SBObject

@property (copy, readonly) NSString *album;  // the album artist of the track
@property (copy, readonly) NSString *albumArtist;  // the artist of the track
@property (readonly) NSInteger albumRating;  // the rating of the album for this track (0 to 100)
@property (copy, readonly) NSString *artist;  // the artist of the track
@property (readonly) NSInteger discCount;  // the total number of discs in the source album
@property (readonly) NSInteger discNumber;  // the index of the disc containing this track on the source album
@property (readonly) NSInteger duration;  // the length of the track in seconds
@property (readonly) NSInteger episodeNumber;  // the episode number of the track
@property (copy, readonly) NSString *genre;  // the genre of the track
@property (readonly) EcouteECMediaKind kind;  // the kind of the track
@property (copy, readonly) NSString *location;  // the URL where the track is located
@property (copy, readonly) NSString *name;  // the track name
@property (readonly) NSInteger playedCount;  // number of times this track has been played
@property (copy, readonly) NSDate *playedDate;  // the date and time this track was last played
@property NSInteger rating;  // the rating of the track (0 to 100)
@property (copy, readonly) NSDate *releaseDate;  // the release date of this track
@property (readonly) NSInteger seasonNumber;  // the season number of the track
@property (readonly) NSInteger trackCount;  // the total number of tracks on the source album
@property (readonly) NSInteger trackNumber;  // the index of the track on the source album
@property (readonly) NSInteger year;  // the year the track was recorded/released
@property (copy) NSData *artwork;  // The artwork in TIFF format and 128*128 size


@end

