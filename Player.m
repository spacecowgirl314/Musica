//
//  Player.m
//  Musica
//
//  Created by Chloe Stars on 6/27/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize playerPosition;
@synthesize playState;
@synthesize ratingNumber;
@synthesize currentTrack;
@synthesize playPauseCallback;
@synthesize playCallback;
@synthesize pauseCallback;
@synthesize previousTrackCallback;
@synthesize nextTrackCallback;

- (id)init
{
    self = [super init];
	if (self) {
		ratingNumber = @0;
	}
	return self;
}

- (void)play
{
	NSLog(@"play");
    if (playCallback!=nil)
    {
        playCallback();
    }
}

- (void)playPause
{
	NSLog(@"playPause");
    if (playPauseCallback!=nil)
    {
        playPauseCallback();
    }
}

- (void)pause
{
	NSLog(@"pause");
    if (pauseCallback!=nil)
    {
        pauseCallback();
    }
}

- (void)previousTrack
{
	NSLog(@"previousTrack");
    if (previousTrackCallback!=nil)
    {
        previousTrackCallback();
    }
	
}

- (void)nextTrack
{
	NSLog(@"nextTrack");
    if (nextTrackCallback!=nil)
    {
        nextTrackCallback();
    }
}

// Returns a number 0-100. Every 20 units reprents a star.
- (NSNumber*)rating
{
	return ratingNumber;
}

+ (NSString *) webScriptNameForSelector:(SEL)sel
{
    NSString *name = nil;
    if (sel == @selector(playerPosition))
		name = @"playerPosition";
	if (sel == @selector(playState))
		name = @"playState";
	if (sel == @selector(currentTrack))
		name = @"currentTrack";
	if (sel == @selector(play))
		name = @"play";
	if (sel == @selector(playPause))
		name = @"playPause";
	if (sel == @selector(pause))
		name = @"pause";
	if (sel == @selector(previousTrack))
		name = @"previousTrack";
	if (sel == @selector(nextTrack))
		name = @"nextTrack";
	if (sel == @selector(rating))
		name = @"rating";
	
    return name;
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
    if (aSelector == @selector(playerPosition)) return NO;
	if (aSelector == @selector(playState)) return NO;
	if (aSelector == @selector(currentTrack)) return NO;
	if (aSelector == @selector(play)) return NO;
	if (aSelector == @selector(playPause)) return NO;
	if (aSelector == @selector(pause)) return NO;
	if (aSelector == @selector(previousTrack)) return NO;
	if (aSelector == @selector(nextTrack)) return NO;
	if (aSelector == @selector(rating)) return NO;
    return YES;
}

@end
