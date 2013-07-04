//
//  Bowtie.m
//  Musica
//
//  Created by Chloe Stars on 7/3/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import "Bowtie.h"

@implementation Bowtie
@synthesize window;

// from http://stackoverflow.com/a/4564630/1000339
- (void)mouseDownWithX:(NSNumber*)x andY:(NSNumber*)y
{
	NSRect screenFrame = [[NSScreen mainScreen] frame];
    NSRect windowFrame = [[self window] frame];
	
    // Y is 0 at the bottom of the screen in OS X. Adjust for this.
	initialLocation = NSMakePoint([x floatValue], screenFrame.size.height-[y floatValue]);
	
    initialLocation.x -= windowFrame.origin.x;
    initialLocation.y -= windowFrame.origin.y;
	
	isDragging = YES;
	//[webHTMLView mouseDown:theEvent];
	//[super mouseDown:theEvent];
}

- (void)mouseUp
{
	isDragging = NO;
}

- (void)mouseMovedWithX:(NSNumber*)x andY:(NSNumber*)y
{
	if (isDragging) {
		NSPoint currentLocation;
		NSPoint newOrigin;
		
		NSRect screenFrame = [[NSScreen mainScreen] frame];
		NSRect windowFrame = [[self window] frame];
		
		// Y is 0 at the bottom of the screen in OS X. Adjust for this.
		currentLocation = NSMakePoint([x floatValue], screenFrame.size.height-[y floatValue]);
		newOrigin.x = currentLocation.x - initialLocation.x;
		newOrigin.y = currentLocation.y - initialLocation.y;
		
		// Don't let window get dragged up under the menu bar
		if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) ){
			newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
		}
		
		//go ahead and move the window to the new location
		[[self window] setFrameOrigin:newOrigin];
	}
}

+ (NSString *)webScriptNameForSelector:(SEL)sel
{
	NSString *name = nil;
    if (sel == @selector(mouseDownWithX:andY:))
		name = @"mouseDownWithPoint";
	if (sel == @selector(mouseMovedWithX:andY:))
		name = @"mouseMovedWithPoint";
	if (sel == @selector(mouseUp))
		name = @"mouseUp";
	
    return name;
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
    if (aSelector == @selector(mouseDownWithX:andY:)) return NO;
	if (aSelector == @selector(mouseMovedWithX:andY:)) return NO;
	if (aSelector == @selector(mouseUp)) return NO;
    return YES;
}

@end
