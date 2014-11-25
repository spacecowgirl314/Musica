//
//  NSImage+Retina.m
//  Musica
//
//  Created by hachidorii on 11/25/14.
//  Copyright (c) 2014 Ozipto. All rights reserved.
//

#import "NSImage+Retina.h"

@implementation NSImage (NSImage_Retina)

- (id)initRetinaImageWithContentsOfURL:(NSURL *)url {
    if((self = [self initWithContentsOfURL:url])) {
        NSURL * baseURL = url.URLByDeletingLastPathComponent;
        NSString * baseName = url.lastPathComponent.stringByDeletingPathExtension;
        NSString * extension = url.lastPathComponent.pathExtension;
        
        NSString * retinaBaseName = [NSString stringWithFormat:@"%@@2x", baseName];
        NSURL * retinaURL = [baseURL URLByAppendingPathComponent:[retinaBaseName stringByAppendingPathExtension:extension]];
        
        if([retinaURL checkResourceIsReachableAndReturnError:NULL]) {
            NSData * data = [[NSData alloc] initWithContentsOfURL:retinaURL];
            NSBitmapImageRep * rep = [[NSBitmapImageRep alloc] initWithData:data];
            
            rep.size = self.size;
            [self addRepresentation:rep];
        }
    }
    
    return self;
}

@end
