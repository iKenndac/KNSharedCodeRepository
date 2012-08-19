//
//  KNEmbossedTextFieldCell.m
//  Clarus
//
//  Created by Daniel Kennett on 17/08/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNEmbossedTextFieldCell.h"


@implementation KNEmbossedTextFieldCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSShadow *sh = [[NSShadow alloc] init];
	[sh setShadowOffset:NSMakeSize(0,1)];
	[sh setShadowColor:[NSColor darkGrayColor]];
	[sh setShadowBlurRadius:1];
	NSMutableParagraphStyle *pSt = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[pSt setAlignment:[self alignment]];
	
	NSDictionary *atts = [NSDictionary dictionaryWithObjectsAndKeys:
						  [self font],NSFontAttributeName,
						  sh,NSShadowAttributeName,
						  [self textColor],NSForegroundColorAttributeName,
						  pSt,NSParagraphStyleAttributeName,nil];

#if !__has_feature(objc_arc)
	[sh release];
	[pSt release];
#endif
	
	NSAttributedString *string = [[NSAttributedString alloc] initWithString:[self stringValue] attributes:atts];
	[self setAttributedStringValue:string];
#if !__has_feature(objc_arc)
	[string release];
#endif
	//[[self attributedStringValue] drawInRect:cellFrame];
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}


@end
