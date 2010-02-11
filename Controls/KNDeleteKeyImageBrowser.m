//
//  KNDeleteKeyImageBrowser.m
//  Clarus
//
//  Created by Daniel Kennett on 08/09/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNDeleteKeyImageBrowser.h"


@implementation KNDeleteKeyImageBrowser

-(void)keyDown:(NSEvent *)theEvent {

	
	if ([[theEvent characters] characterAtIndex:0] == NSBackspaceCharacter || 
		[[theEvent characters] characterAtIndex:0] == NSDeleteCharacter || 
		[theEvent keyCode] == 117) {
	
		[[self nextResponder] keyDown:theEvent];
		//[NSApp tryToPerform:@selector(keyDown:) with:theEvent];
		
	} else {
		[super keyDown:theEvent];
	}
}

@end
