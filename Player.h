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

- (void)playPause;
- (void)play;
- (void)pause;

@property (copy) voidBlock playPauseCallback;
@property (copy) voidBlock playCallback;
@property (copy) voidBlock pauseCallback;
@property Track *currentTrack;
@property NSNumber *playerPosition;
@property NSNumber *playState;

@end
