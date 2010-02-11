//
//  KNDarkSplitBar.m
//  Clarus
//
//  Created by Daniel Kennett on 30/01/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNDarkSplitView.h"


@implementation KNDarkSplitView

- (void)drawDividerInRect:(NSRect)aRect
{	
	if ([self dividerStyle] == NSSplitViewDividerStyleThin) {
        
        [[NSColor grayColor] set];
        NSRectFill(aRect);
        
    } else {
        [super drawDividerInRect:aRect];
    }
}

-(BOOL)mouseDownCanMoveWindow {
    return YES;
}

@end
