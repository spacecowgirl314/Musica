//
//  TransparentWindow.m
//  Musica
//
//  Created by Chloe Stars on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TransparentWindow.h"

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
		// Pinned
		//[self setLevel:kCGDesktopWindowLevel];
		// Floating or NSFloatingWindowLevel
		switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"musicaWindowMode"]) {
			case 0:
				// Always on Top
				[self setLevel:kCGFloatingWindowLevel];
				break;
			case 1:
				// Pinned to Desktop
				[self setLevel:CGWindowLevelForKey(kCGDesktopIconWindowLevelKey) + 1];
				break;
			case 2:
				// Normal Window
				[self setLevel:NSNormalWindowLevel];
				break;
			default:
				// Use default
				[self setLevel:kCGFloatingWindowLevel];
				break;
		}
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
            [self setLevel:kCGDesktopWindowLevel];
            break;
        case 2:
            // Normal Window
            [self setLevel:NSNormalWindowLevel];
            break;
        default:
            // Use default
            [self setLevel:kCGFloatingWindowLevel];
            break;
    }
}

/*
 Custom windows that use the NSBorderlessWindowMask can't become key by default. Override this method so that controls in this window will be enabled.
 */
- (BOOL)canBecomeKeyWindow {
    return YES;
}

/*- (void)mouseDragged:(NSEvent *)theEvent
{	
	if (shouldRedoInitials)
	{
		initialLocation = [theEvent locationInWindow];
		initialLocationOnScreen = [self convertBaseToScreen:[theEvent locationInWindow]];
		
		initialFrame = [self frame];
		shouldRedoInitials = NO;
		
		if (initialLocation.x > initialFrame.size.width - 20 && initialLocation.y < 20) {
			shouldDrag = NO;
		}
		else {
			//mouseDownType = PALMOUSEDRAGSHOULDMOVE;
			shouldDrag = YES;
		}
		
		screenFrame = [[NSScreen mainScreen] frame];
		windowFrame = [self frame];
		
		minY = windowFrame.origin.y+(windowFrame.size.height-288);
	}
	if (shouldDrag) {
		//grab the current global mouse location; we could just as easily get the mouse location 
		//in the same way as we do in -mouseDown:
		currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
		newOrigin.x = currentLocation.x - initialLocation.x;
		newOrigin.y = currentLocation.y - initialLocation.y;
		
		// Don't let window get dragged up under the menu bar
		if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) )
		{
			newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
		}
		
		//go ahead and move the window to the new location
		[self setFrameOrigin:newOrigin];
		
		// Using preferences
		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicaDocked"]) {
			// This will dock the window. Pulled from Adium AIBorderlessWindow.m & AIDockingWindow.m
			// http://hg.adium.im/adium/file/e04a00f58ce6/Frameworks/AIUtilities%20Framework/Source/AIBorderlessWindow.m
			// http://hg.adium.im/adium/file/e04a00f58ce6/Frameworks/AIUtilities%20Framework/Source/AIDockingWindow.m
			
			//Attempt to dock this window the the visible frame first, and then to the screen frame
			NSRect	newWindowFrame = [self frame];
			NSRect  dockedWindowFrame;
			
			dockedWindowFrame = [self dockWindowFrame:newWindowFrame toScreenFrame:[[self screen] visibleFrame]];
			dockedWindowFrame = [self dockWindowFrame:dockedWindowFrame toScreenFrame:[[self screen] frame]];

			//[self setFrameOrigin:newOrigin display:YES animate:YES];
			[self setFrame:dockedWindowFrame display:YES animate:YES];
		}
	}
}

- (void)mouseUp:(NSEvent *)theEvent
{
	shouldRedoInitials = YES;
}*/

//Dock the passed window frame if it's close enough to the screen edges
- (NSRect)dockWindowFrame:(NSRect)inWindowFrame toScreenFrame:(NSRect)inScreenFrame
{
	BOOL	changed = NO;
	
	//Left
	if ((labs(NSMinX(inWindowFrame) - NSMinX(inScreenFrame)) < WINDOW_DOCKING_DISTANCE)) {
		inWindowFrame.origin.x = inScreenFrame.origin.x;
		changed = YES;
	}
	
	//Bottom
	if ((labs(NSMinY(inWindowFrame) - NSMinY(inScreenFrame)) < WINDOW_DOCKING_DISTANCE)) {
		inWindowFrame.origin.y = inScreenFrame.origin.y;
		changed = YES;
	}
	
	//Right
	if ((labs(NSMaxX(inWindowFrame) - NSMaxX(inScreenFrame)) < WINDOW_DOCKING_DISTANCE)) {
		inWindowFrame.origin.x -= NSMaxX(inWindowFrame) - NSMaxX(inScreenFrame);
		changed = YES;
	}
	
	//Top
	if ((labs(NSMaxY(inWindowFrame) - NSMaxY(inScreenFrame)) < WINDOW_DOCKING_DISTANCE)) {
		inWindowFrame.origin.y -= NSMaxY(inWindowFrame) - NSMaxY(inScreenFrame);
		changed = YES;
	}
	
	return inWindowFrame;
}

@end
