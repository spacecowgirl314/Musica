//
//  Track.h
//  Musica
//
//  Created by Chloe Stars on 6/27/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property NSString *title;
@property NSString *album;
@property NSString *artist;
@property NSString *genre;
@property NSNumber *length;

- (id)property:(NSString*)key;

@end
