//
//  MusicaAppDelegate.h
//  Musica
//
//  Created by Chloe Stars on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MusicaAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *__unsafe_unretained window;
}

@property (unsafe_unretained) IBOutlet NSWindow *window;

@end
