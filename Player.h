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

@property Track *currentTrack;
@property int playerPosition;

@end
