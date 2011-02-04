//
//  KNTableHeader.m
//  Music Rescue 4
//
//  Created by Daniel Kennett on 03/01/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//

#import "KNTableHeader.h"
#import "KNGradientExtensions.h"

@implementation KNTableHeader

-(id)initWithTitle:(NSString *)tit alignment:(NSTextAlignment)align drawSeparators:(BOOL)draws canBeClicked:(BOOL)clickable {
	
	if ((self = [super init])) {
		
		[self setObjectValue:tit];
		[self setTitle:tit];
		alignment = align;
		drawsSeparators = draws;
		sortAscending = YES;
		sortPriority = 1;
		canBeClicked = clickable;
	} 
	
	return self;
}

-(void)dealloc {
	[self setTitle:nil];
	[super dealloc];
}

- copyWithZone:(NSZone *)zone {
    KNTableHeader *cell = (KNTableHeader *)[super copyWithZone:zone];
    cell->title = [title copyWithZone:zone];
	cell->alignment = alignment;
	cell->drawsSeparators = drawsSeparators;
	cell->sortAscending = sortAscending;
	cell->sortPriority = sortPriority;
	cell->canBeClicked = canBeClicked;
    return cell;
}

-(NSString *)title {
	return title;
}

-(void)setTitle:(NSString *)tit {
	[title release];
	title = [tit retain];
	
	//[[self controlView] setNeedsDisplay:YES];
}


-(void)drawWithFrame:(NSRect)frame inView:(NSView *)view {

	SInt32 version = 0;
	Gestalt( gestaltSystemVersionMinor, &version );
	
	if (version >= 5) {
		
	if ([self state] == NSOnState) {
		if (canBeClicked) {
			[[NSGradient unifiedPressedGradient] fillRect:frame angle:-90];
		}
	} else {
		if (sortPriority == 0) {
			[[NSGradient unifiedDarkGradient] fillRect:frame angle:-90];
		} else {
			[[NSGradient unifiedNormalGradient] fillRect:frame angle:-90];
		}
	}
	
	[[NSColor grayColor] set];
	
	float bottomEdge = frame.size.height - 0.5;
	float rightEdge = frame.origin.x + frame.size.width - 0.5;
	float leftEdge = frame.origin.x;
	
	[NSBezierPath strokeLineFromPoint:NSMakePoint(leftEdge, bottomEdge) toPoint:NSMakePoint(leftEdge + frame.size.width, bottomEdge)];
	[NSBezierPath strokeLineFromPoint:NSMakePoint(leftEdge, 0.5) toPoint:NSMakePoint(leftEdge + frame.size.width, 0.5)];
	
	
	
	if (drawsSeparators) {
	
		[NSBezierPath strokeLineFromPoint:NSMakePoint(rightEdge, bottomEdge) toPoint:NSMakePoint(rightEdge,0)];
		
	}
	
	[self drawInteriorWithFrame:frame inView:view];
	
	[self drawSortIndicatorWithFrame:frame inView:view ascending:sortAscending priority:sortPriority];
	
	} else {
		[super drawWithFrame:frame inView:view];
	}
	
	//[super drawWithFrame:frame inView:view];
	
	//[self drawSortIndicatorWithFrame:frame inView:view ascending:YES priority:0];
}


-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	SInt32 version = 0;
	Gestalt( gestaltSystemVersionMinor, &version );
	
	if (version >= 5) {
		
		NSMutableParagraphStyle *style = [[[NSMutableParagraphStyle alloc] init] autorelease];
		[style setAlignment:alignment];
		
		NSDictionary *textAttribs = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont boldSystemFontOfSize:11.0], NSFontAttributeName, 
									 style, NSParagraphStyleAttributeName, nil];
		
		NSDictionary *whiteAttribs = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont boldSystemFontOfSize:11.0], NSFontAttributeName, 
									  style, NSParagraphStyleAttributeName, 
									  [[NSColor whiteColor] colorWithAlphaComponent:0.4], NSForegroundColorAttributeName, nil];
		
		
		[title drawInRect:NSOffsetRect(cellFrame, 4, 3) withAttributes:whiteAttribs];
		[title drawInRect:NSOffsetRect(cellFrame, 5, 2) withAttributes:textAttribs];
		
		
		if ([self image]) {
			
			BOOL isFlipped = [[self image] isFlipped];
			
			// Center the image rect
			
			[[self image] setFlipped:[controlView isFlipped]];
			
			NSSize imageSize = [[self image] size];
			NSRect imageRect = NSMakeRect(cellFrame.origin.x + ((cellFrame.size.width / 2) - (imageSize.width / 2)),
										  cellFrame.origin.y + 1 + ((cellFrame.size.height / 2) - (imageSize.height / 2)),
										  imageSize.width,
										  imageSize.height);
			
			[[self image] drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
			
			
			[[self image] setFlipped:isFlipped];
			
		}
		
	} else {
		[super drawInteriorWithFrame:cellFrame inView:controlView];
	}
}

-(void)setSortAscending:(BOOL)asc priority:(int)pri {

	sortPriority = pri;
	sortAscending = asc;
	
	
}

-(int)sortPriority {
	return sortPriority;
}



@end
