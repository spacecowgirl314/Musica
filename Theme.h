//
//  Theme.h
//  Musica
//
//  Created by Chloe Stars on 7/3/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject

@property NSString *name;
@property NSString *artist;
@property NSURL *URL;

- (void)applyTheme;

@end
