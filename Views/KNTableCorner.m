//
//  KNTableCorner.m
//  Music Rescue 4
//
//  Created by Daniel Kennett on 03/01/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//

#import "KNTableCorner.h"
#import "KNGradientExtensions.h"

@interface _NSCornerView : NSView
@end

@implementation KNTableCorner


-(id)initWithShowsRightEdge:(BOOL)shows {

	SInt32 version = 0;
	Gestalt( gestaltSystemVersionMinor, &version );
	if (version >= 5) {
		
		if ((self = [super init])) {
			
			showsRightEdge = shows;
		}
		
		return self;
		
	} else {
		[self release];
		return [[_NSCornerView alloc] init];
	}
	
}


- (void)drawRect:(NSRect)rect {

	SInt32 version = 0;
	Gestalt( gestaltSystemVersionMinor, &version );
	
	float bottomEdge = [self bounds].size.height - 0.5;
	float rightEdge = [self bounds].origin.x + [self bounds].size.width - 0.5;
	float leftEdge = [self bounds].origin.x;
	
	if (version >= 5) {
		
		[[NSGradient unifiedNormalGradient] fillRect:rect angle:90];
		
		[[NSColor grayColor] set];
			
		[NSBezierPath strokeLineFromPoint:NSMakePoint(leftEdge, bottomEdge) toPoint:NSMakePoint(leftEdge + rect.size.width, bottomEdge)];
		[NSBezierPath strokeLineFromPoint:NSMakePoint(leftEdge, 0.5) toPoint:NSMakePoint(leftEdge + rect.size.width, 0.5)];
				
	} else {
		
		//NSLog(@"%1.2f, %1.2f, %1.2f, %1.2f", [self bounds].origin.x, [self bounds].origin.y, [self bounds].size.width, [self bounds].size.height);
		
		NSTableHeaderCell *cell = [[NSTableHeaderCell alloc] init];
		[cell setObjectValue:nil];
		[cell drawWithFrame:[self bounds] inView:nil];
		[cell release];
		
	}
	
		if (showsRightEdge) {
		[NSBezierPath strokeLineFromPoint:NSMakePoint(rightEdge, 0) toPoint:NSMakePoint(rightEdge, bottomEdge)];
	}

}



@end
