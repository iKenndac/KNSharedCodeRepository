//
//  KNNoCachingOutlineView.m
//  Clarus
//
//  Created by Daniel Kennett on 20/07/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNNoCachingOutlineView.h"


@implementation KNNoCachingOutlineView

-(void)drawRect:(NSRect)rect {
	[super drawRect:rect];
}

- (BOOL)inLiveResize {
	return NO;
}

@end
