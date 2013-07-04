//
//  NSImage+Resize.m
//  Musica
//
//  Created by Chloe Stars on 7/3/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import "NSImage+Resize.h"

@implementation NSImage (Resize)

- (NSData*)dataOfResizeForWidth:(float)width andHeight:(float)height
{
	NSImageView* kView;
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musica1xArtwork"]) {
		kView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, width/[[NSScreen mainScreen] backingScaleFactor], height/[[NSScreen mainScreen] backingScaleFactor])];
	}
	else {
		kView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, width, height)];
	}
    [kView setImageScaling:NSImageScaleProportionallyUpOrDown];
    [kView setImage:self];
	
    NSRect kRect = kView.frame;
    NSBitmapImageRep* kRep = [kView bitmapImageRepForCachingDisplayInRect:kRect];
    [kView cacheDisplayInRect:kRect toBitmapImageRep:kRep];
	
    return [kRep representationUsingType:NSJPEGFileType properties:nil];
}

- (NSImage*)resizeForWidth:(float)width andHeight:(float)height
{
    return [[NSImage alloc] initWithData:[self dataOfResizeForWidth:width andHeight:height]];
}

@end
