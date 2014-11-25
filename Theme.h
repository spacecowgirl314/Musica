//
//  Theme.h
//  Musica
//
//  Created by Chloe Stars on 7/3/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject


typedef enum  {
	ThemeWindowModeDesktop,
	ThemeWindowModeNormal,
	ThemeWindowModeTop
} ThemeWindowMode;

@property NSString *name;
@property NSString *artist;
@property NSString *preview;
@property NSURL *URL;
@property ThemeWindowMode windowMode;

- (id)initWithURL:(NSURL*)url;
- (void)applyTheme;
- (void)removeTheme;

@end
