//
//  NSImage+Resize.h
//  Musica
//
//  Created by Chloe Stars on 7/3/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Resize)

- (NSData*)dataOfResizeForWidth:(float)width andHeight:(float)height;
- (NSImage*)resizeForWidth:(float)width andHeight:(float)height;

@end
