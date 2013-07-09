//
//  TrayMenu.m
//  Musica
//
//  Created by Chloe Stars on 9/11/10.
//  Copyright 2010 Ozipto. All rights reserved.
//

#import "TrayMenu.h"

@implementation TrayMenu

@synthesize preferencesController;

/*- (void) openWebsite:(id)sender 
 {
	NSURL *url = [NSURL URLWithString:@"http://th30z.netsons.org"];
	[[NSWorkspace sharedWorkspace] openURL:url];
	[url release];
}

- (void) openFinder:(id)sender 
 {
	[[NSWorkspace sharedWorkspace] launchApplication:@"Finder"];
}*/

- (void)actionQuit:(id)sender
{
	[NSApp terminate:sender];
}

- (void)openPreferences:(id)sender
{
	// lazy load the PreferencesController
	if (!self.preferencesController) {
		PreferencesController *pC = [[PreferencesController alloc] init];
		self.preferencesController =  pC;
	}
	
	[self.preferencesController showWindow:self];
}

- (void)showAboutWindow:(id)sender
{
	[[NSApplication sharedApplication] orderFrontStandardAboutPanel:sender];
}

- (NSMenu*)createMenu
{
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
	NSMenuItem *menuItem;
	
	// Add To Items
	menuItem = [menu addItemWithTitle:@"About Musica"
							   action:@selector(showAboutWindow:)
						keyEquivalent:@""];
	[menuItem setTarget:self];
	
	// Add Separator
	[menu addItem:[NSMenuItem separatorItem]];
	 
	menuItem = [menu addItemWithTitle:@"Preferences..."
							   action:@selector(openPreferences:)
						keyEquivalent:@""];
	[menuItem setTarget:self];
	
	// Add Separator
	[menu addItem:[NSMenuItem separatorItem]];
	
	// Add Quit Action
	menuItem = [menu addItemWithTitle:@"Quit"
							   action:@selector(actionQuit:)
						keyEquivalent:@""];
	[menuItem setToolTip:@"Click to Quit this App"];
	[menuItem setTarget:self];
	
	return menu;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	/*NSMenu *menu = [self createMenu];
	[menu setDelegate:self];
	
	_statusItem = [[NSStatusBar systemStatusBar]
					statusItemWithLength:NSSquareStatusItemLength];
	[_statusItem setMenu:menu];
	[_statusItem setHighlightMode:YES];
	[_statusItem setToolTip:@"Musica"];
	[_statusItem setImage:[NSImage imageNamed:@"trayIcon.png"]];*/
	//[_statusItem setAlternateImage:[NSImage imageNamed:@"pressedTrayIcon.png"]];
}

- (void)removeStatusItem
{
	[[NSStatusBar systemStatusBar] removeStatusItem: _statusItem];
}

@end