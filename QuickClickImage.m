//
//  QuickClickImage.m
//  Musica
//
//  Created by Chloe Stars on 12/1/11.
//  Copyright (c) 2011 Ozipto. All rights reserved.
//

#import <ScriptingBridge/ScriptingBridge.h>
#import "QuickClickImage.h"

@implementation QuickClickImage
@synthesize audioPlayer;

- (void)mouseDown:(NSEvent *)theEvent {
    // detect appropriately displayed music app and ACTIVATE!!
    NSLog(@"clickCount:%ld", [theEvent clickCount]);
    if ([theEvent clickCount]==2) {
        SBApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
        SBApplication *Rdio = [SBApplication applicationWithBundleIdentifier:@"com.rdio.desktop"];
        SBApplication *Spotify = [SBApplication applicationWithBundleIdentifier:@"com.spotify.client"];
        SBApplication *Radium = [SBApplication applicationWithBundleIdentifier:@"com.catpigstudios.Radium"];
        switch (audioPlayer) {
            case audioPlayeriTunes:
                [iTunes activate];
                break;
            case audioPlayerRadium:
                [Radium activate];
                break;
            case audioPlayerRdio:
                [Rdio activate];
                break;
            case audioPlayerSpotify:
                [Spotify activate];
                break;
        }
    }
}

@end
