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
	[sh release];
	[pSt release];
	
	NSAttributedString *string = [[NSAttributedString alloc] initWithString:[self stringValue] attributes:atts];
	[self setAttributedStringValue:string];
	[string release];
	//[[self attributedStringValue] drawInRect:cellFrame];
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}


@end
