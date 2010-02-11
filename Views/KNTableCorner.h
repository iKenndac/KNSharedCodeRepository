//
//  KNTableCorner.h
//  Music Rescue 4
//
//  Created by Daniel Kennett on 03/01/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KNTableCorner : NSView {

	BOOL showsRightEdge;
	
}

-(id)initWithShowsRightEdge:(BOOL)shows;

@end
