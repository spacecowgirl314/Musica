//
//  ThemeLoader.h
//  Musica
//
//  Created by Chloe Stars on 7/4/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"

@interface ThemeLoader : NSObject
{
	NSMutableArray *themes;
	IBOutlet NSTableView *tableView;
}

- (void)reload;
+ (NSURL*)appliedThemeURL;
+ (void)installTheme:(NSURL*)source;
+ (Theme*)currentTheme;

@end
