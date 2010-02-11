//
//  KNBottomToolbar.m
//  iTS Prototype
//
//  Created by Daniel Kennett on 07/06/2007.
//  Copyright 2007 KennettNet Software Ltd. All rights reserved.
//

#import "KNBottomToolbar.h"


@implementation KNBottomToolbar

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    
	NSRect _size = [self bounds];
	
	[[NSColor colorWithDeviceRed:0.898 green:0.898 blue:0.898 alpha:1] set];
	[NSBezierPath fillRect:rect];
	[[NSColor lightGrayColor] set];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(0, _size.size.height - 0.5) toPoint:NSMakePoint(_size.size.width,_size.size.height - 0.5)]; 
	
}

@end
