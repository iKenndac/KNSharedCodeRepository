//
//  KNTableHeader.h
//  Music Rescue 4
//
//  Created by Daniel Kennett on 03/01/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KNTableHeader : NSTableHeaderCell {

	NSString *title;
	NSTextAlignment alignment;
	BOOL drawsSeparators;
	BOOL canBeClicked;
	BOOL sortAscending;
	int sortPriority;

}

-(id)initWithTitle:(NSString *)tit alignment:(NSTextAlignment)align drawSeparators:(BOOL)draws canBeClicked:(BOOL)clickable;

-(NSString *)title;
-(void)setTitle:(NSString *)tit;

-(int)sortPriority;

-(void)setSortAscending:(BOOL)asc priority:(int)pri;

@end
