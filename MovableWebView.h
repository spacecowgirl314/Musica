//
//  MovableWebView.h
//  Musica
//
//  Created by Chloe Stars on 7/2/13.
//  Copyright (c) 2013 Ozipto. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface MovableWebView : WebView
{
	NSPoint initialLocation;
	id webHTMLView;
}

@end
