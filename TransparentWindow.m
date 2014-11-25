//
//  TransparentWindow.m
//  Musica
//
//  Created by Chloe Stars on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TransparentWindow.h"
#import "ThemeLoader.h"
#import "Theme.h"

#define WINDOW_DOCKING_DISTANCE 	12	//Distance in pixels before the window is snapped to an edge

@interface TransparentWindow (PRIVATE)
- (NSRect)dockWindowFrame:(NSRect)inFrame toScreenFrame:(NSRect)screenFrame;
@end

@implementation TransparentWindow
@synthesize initialLocation;

/*
 In Interface Builder, the class for the window is set to this subclass. Overriding the initializer provides a mechanism for controlling how objects of this class are created.
 */
- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    // Using NSBorderlessWindowMask results in a window without a title bar.
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if (self != nil) {
        // Start with no transparency for all drawing into the window
        [self setAlphaValue:1.0];
        // Show in all spaces... this also might not be desired. Consider turning this into a preference.
        // [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
        // Set the window mode
		[self updateWindowMode];
        // Turn off opacity so that the parts of the window that are not drawn into are transparent.
        [self setOpaque:NO];
		//[self setBackgroundColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.0]];  //Tells the window to use a transparent colour.
        // allow preferences to tap into instant update
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateWindowMode) 
                                                     name:@"changeWindowMode"
                                                   object:nil];
    }
    return self;
}

- (void)updateWindowMode {
    // read settings and update window mode on the fly... no need to quit and reopen
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"musicaWindowMode"]) {
        case 0:
            // Always on Top
            [self setLevel:kCGFloatingWindowLevel];
            break;
        case 1:
            // Pinned to Desktop
            [self setLevel:kCGDesktopIconWindowLevel];
            break;
        case 2:
            // Normal Window
            [self setLevel:NSNormalWindowLevel];
            break;
		case 3: {
			// Theme controlled
			ThemeWindowMode windowMode = [[ThemeLoader currentTheme] windowMode];
			switch(windowMode) {
				case ThemeWindowModeDesktop:
					// Pinned to Desktop
					[self setLevel:kCGDesktopIconWindowLevel];
					break;
				case ThemeWindowModeNormal:
					// Normal Window
					[self setLevel:NSNormalWindowLevel];
					break;
				case ThemeWindowModeTop:
					// Always on Top
					[self setLevel:kCGFloatingWindowLevel];
					break;
			}
			break;
		}
        default:
            // Use default
            [self setLevel:NSNormalWindowLevel];
            break;
    }
}

/*
 Custom windows that use the NSBorderlessWindowMask can't become key by default. Override this method so that controls in this window will be enabled.
 */
- (BOOL)canBecomeKeyWindow {
    return YES;
}

@end
