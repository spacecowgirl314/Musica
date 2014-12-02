//
//  Player.h
//  Musica
//
//  Created by Chloe Stars on 6/27/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"

@interface Player : NSObject

typedef void (^voidBlock)();
typedef void (^voidBlockWithInt)(double position);

- (void)playPause;
- (void)play;
- (void)pause;
- (void)previousTrack;
- (void)nextTrack;
- (NSNumber*)rating;

@property (copy) voidBlock playPauseCallback;
@property (copy) voidBlock playCallback;
@property (copy) voidBlock pauseCallback;
@property (copy) voidBlock previousTrackCallback;
@property (copy) voidBlock nextTrackCallback;
@property (copy) voidBlockWithInt playerPositionCallback;
@property Track *currentTrack;
@property NSNumber *playerPosition;
@property NSNumber *playState;
@property NSNumber *ratingNumber;

@end
