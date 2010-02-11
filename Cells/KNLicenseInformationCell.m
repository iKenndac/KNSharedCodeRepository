//
//  KNLicenseInformationCell.m
//  Music Rescue 4
//
//  Created by Daniel Kennett on 11/01/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//


// This implements a cell that has an image with a status badge and 
// two lines of text.

//    +----------------------------------+
//    |  +----+                          |
//    |  |    | This Computer            |
//    |  |    | Not licensed             |
//    |  +----+                          |
//    +----------------------------------+

#import "KNLicenseInformationCell.h"


@interface KNLicenseInformationCell(Private)
	
-(NSImage *)itemIcon;
-(NSImage *)badgeIcon;
-(NSString *)itemTitle;
-(NSString *)minorText;
-(NSDictionary *)minorTextAttributes;
-(NSDictionary *)majorTextAttributes;


@end


@implementation KNLicenseInformationCell


- (id)copyWithZone:(NSZone *)zone {

	return [[KNLicenseInformationCell alloc] init];
	
}



-(void)drawWithFrame:(NSRect)frame inView:(NSView *)view {
	
	
	if ([[[self objectValue] objectForKey:@"isDivider"] boolValue] == YES) {
		
		NSPoint dividerStart = NSMakePoint(NSMinX(frame) + 32.5, frame.origin.y + (frame.size.height / 2) + 0.5);
		NSPoint dividerEnd = NSMakePoint(NSMaxX(frame) - 31.5, frame.origin.y + (frame.size.height / 2) + 0.5);

		[[NSColor whiteColor] set];
		
		[NSBezierPath strokeLineFromPoint:dividerStart toPoint:dividerEnd];
		
		dividerStart = NSMakePoint(NSMinX(frame) + 32, frame.origin.y + (frame.size.height / 2));
		dividerEnd = NSMakePoint(NSMaxX(frame) - 32, frame.origin.y + (frame.size.height / 2));
		
		[[NSColor grayColor] set];
		
		[NSBezierPath strokeLineFromPoint:dividerStart toPoint:dividerEnd];
		
		return;
	}
	
	NSImage *im = [self itemIcon];
	BOOL imFlipped = [im isFlipped];
	[im setFlipped:[view isFlipped]];
	
	NSImage *badge = [self badgeIcon];
	BOOL badgeFlipped = [badge isFlipped];
	[badge setFlipped:[view isFlipped]];
	
	// The image box is 32x32, centered vertically in the cell.
	// The left margin is equal to the top and bottom margins.
	
	NSSize imageSize = [[self itemIcon] size];
	
	float margin = (frame.size.height - imageSize.height) / 2;
	
	NSRect imageRect = NSMakeRect(frame.origin.x + margin, frame.origin.y + margin, imageSize.width, imageSize.height);
	[im drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	
	NSRect badgeRect = NSMakeRect(NSMaxX(imageRect) - 16, NSMaxY(imageRect) - 16, 16, 16);
	
	
	[badge drawInRect:badgeRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];	
	
	NSRect topText;
	
	if ((![self minorText]) || [[self minorText] isEqualToString:@""]) {
		
		topText = NSMakeRect(NSMaxX(imageRect) + 10, frame.origin.y + ((frame.size.height / 2) - 8), 
							 frame.size.width - NSMaxX(imageRect) - 10, 16);
		
	} else {
		
		topText = NSMakeRect(NSMaxX(imageRect) + 10, NSMinY(imageRect), 
							 frame.size.width - NSMaxX(imageRect) - 10, 16); 
		
	}
	
	NSRect bottomText = NSMakeRect(NSMaxX(imageRect) + 10, NSMinY(imageRect) + (imageRect.size.height/2), 
								   frame.size.width - NSMaxX(imageRect) - 10, 16);

	[[self itemTitle] drawInRect:topText withAttributes:[self majorTextAttributes]];
	[[self minorText] drawInRect:bottomText withAttributes:[self minorTextAttributes]];
	
	
	[im setFlipped:imFlipped];
	[badge setFlipped:badgeFlipped];
}


- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView {
	mouseDown = YES;
	return [super startTrackingAt:startPoint inView:controlView];
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {
	mouseDown = NO;
	return [super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
}

#pragma mark -
#pragma mark Private methods

-(NSDictionary *)majorTextAttributes {
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByTruncatingTail];

	
	if ([self isHighlighted] || mouseDown) {
		
                
		return [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:13.0], NSFontAttributeName, 
				[NSColor whiteColor], NSForegroundColorAttributeName,
                [paragraph autorelease], NSParagraphStyleAttributeName, nil];
		
	} else {
    
		return [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:13.0], NSFontAttributeName, 
				[NSColor blackColor], NSForegroundColorAttributeName, 
                [paragraph autorelease], NSParagraphStyleAttributeName, nil];
	}
	
}


-(NSDictionary *)minorTextAttributes {
	
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByTruncatingTail];
    
	
    if ([self isHighlighted] || mouseDown) {
		
		return [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:11.0], NSFontAttributeName, 
				[NSColor whiteColor], NSForegroundColorAttributeName, 
                [paragraph autorelease], NSParagraphStyleAttributeName,nil];
		
	} else {
		
		return [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:11.0], NSFontAttributeName, 
                [NSColor grayColor], NSForegroundColorAttributeName, 
                [paragraph autorelease], NSParagraphStyleAttributeName,nil];
	}
	
}



-(NSImage *)itemIcon {
	return [(NSDictionary *)[self objectValue] objectForKey:@"icon"];
}

-(NSString *)itemTitle {
	return [(NSDictionary *)[self objectValue] objectForKey:@"title"];
}

-(NSString *)minorText {
	return [(NSDictionary *)[self objectValue] objectForKey:@"minorText"];
}

-(NSImage *)badgeIcon {
	return [(NSDictionary *)[self objectValue] objectForKey:@"badge"];
}

@end
