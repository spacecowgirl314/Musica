//
//  MovableWebView.m
//  Musica
//
//  Created by Chloe Stars on 7/2/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import "MovableWebView.h"

@implementation MovableWebView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

/*- (NSView *)hitTest:(NSPoint)aPoint
{
    // pass-through events that don't hit one of the visible subviews
    for (NSView *subView in [self subviews]) {
		NSLog(@"Class hit:%@", [subView className]);
		if ([[subView className] isEqualToString:@"WebFrameView"]) {
			webHTMLView = subView;
			[webHTMLView mouseDown:nil];
			return self;
		}
        if (![subView isHidden] && [subView hitTest:aPoint])
            return subView;
    }
	
    return nil;
}*/

// from http://stackoverflow.com/a/4564630/1000339
-(void)mouseDown:(NSEvent *)theEvent
{
    NSRect  windowFrame = [[self window] frame];
	
    initialLocation = [NSEvent mouseLocation];
	
    initialLocation.x -= windowFrame.origin.x;
    initialLocation.y -= windowFrame.origin.y;
	//[webHTMLView mouseDown:theEvent];
	[super mouseDown:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint currentLocation;
    NSPoint newOrigin;
	
    NSRect  screenFrame = [[NSScreen mainScreen] frame];
    NSRect  windowFrame = [self frame];
	
    currentLocation = [NSEvent mouseLocation];
    newOrigin.x = currentLocation.x - initialLocation.x;
    newOrigin.y = currentLocation.y - initialLocation.y;
	
    // Don't let window get dragged up under the menu bar
    if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) ){
        newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
    }
	
    //go ahead and move the window to the new location
    [[self window] setFrameOrigin:newOrigin];
}

@end
