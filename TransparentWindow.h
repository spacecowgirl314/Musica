//
//  TransparentWindow.h
//  Musica
//
//  Created by Chloe Stars on 9/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransparentWindow : NSWindow {
	BOOL shouldDrag;
	BOOL shouldRedoInitials;
	NSPoint initialLocation;
	NSPoint initialLocationOnScreen;
	NSRect initialFrame;
	NSPoint currentLocation;
	NSPoint newOrigin;
	NSRect screenFrame;
	NSRect windowFrame;
	float minY;
}

@property (assign) NSPoint initialLocation;

@end
