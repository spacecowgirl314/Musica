//
//  PreferencesController.h
//  Musica
//
//  Created by Chloe Stars on 9/10/10.
//  Copyright 2010 Ozipto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ServiceManagement/ServiceManagement.h>
#import "ThemeLoader.h"

@interface PreferencesController : NSWindowController {
	IBOutlet NSPopUpButton *musicaWindowButton;
	IBOutlet NSTableView *themeTableView;
    IBOutlet NSToolbar *toolbar;
    IBOutlet NSView *generalView;
    IBOutlet NSView *themesView;
	IBOutlet NSView *lastFMView;
    IBOutlet NSToolbarItem *defaultItem;
    IBOutlet NSSegmentedControl *loginSwitch;
	IBOutlet ThemeLoader *themeLoader;
}

@property (strong, nonatomic) IBOutlet NSPopUpButton *musicaWindowButton;

-(IBAction)relaunch:(id)sender;
-(IBAction)toggleDockArt:(id)sender;
-(IBAction)toggleShowingMusica:(id)sender;
-(IBAction)selectedWindowMode:(id)sender;
-(IBAction)gotoPluginWebpage:(id)sender;
-(IBAction)switchViews:(NSToolbarItem *)item;

@end
