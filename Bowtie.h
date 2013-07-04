//
//  Bowtie.h
//  Musica
//
//  Created by Chloe Stars on 7/3/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bowtie : NSObject
{
	NSPoint initialLocation;
	BOOL isDragging;
}

@property NSWindow *window;

- (void)mouseDownWithX:(NSNumber*)x andY:(NSNumber*)y;
- (void)mouseUp;
- (void)mouseMovedWithX:(NSNumber*)x andY:(NSNumber*)y;

@end
