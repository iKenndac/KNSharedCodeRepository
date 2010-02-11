//
//  KNStatusBarView.m
//  Music Rescue 4
//
//  Created by Daniel Kennett on 30/01/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//

#import "KNStatusBarView.h"
#import "KNGradientExtensions.h"

@implementation KNStatusBarView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	
	SInt32 version = 0;
	Gestalt( gestaltSystemVersionMinor, &version );
	
	NSRect frame = [self frame];
	
	if ([[self window] isMainWindow]) {
		
		
		if (version >= 5) {
			[[NSGradient unifiedPressedGradient] fillRect:frame angle:90];
		} else {
			[[NSGradient unifiedNormalGradient] fillRect:frame angle:90];
		}
	
	} else {
		if (version >= 5) {
			[[NSGradient unifiedNormalGradient] fillRect:frame angle:90];
		} else {
			[[NSGradient unifiedSelectedGradient] fillRect:frame angle:90];
		}
	}
		
	[[NSColor grayColor] set];
	
	//NSRect border = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width - 1, frame.size.height - 1);
	
	[NSBezierPath strokeLineFromPoint:NSMakePoint(-0.5, frame.size.height - 0.5) toPoint:NSMakePoint(frame.size.width + 1, frame.size.height - 0.5)];
	
	[[[NSColor whiteColor] colorWithAlphaComponent:0.4] set];
	
	[NSBezierPath strokeLineFromPoint:NSMakePoint(-0.5, frame.size.height - 1.5) toPoint:NSMakePoint(frame.size.width + 1, frame.size.height - 1.5)];
}

- (BOOL)mouseDownCanMoveWindow {
	return YES;
}

@end
