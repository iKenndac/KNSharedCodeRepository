//
//  KNArrayExtensions.h
//  Music Rescue 4
//
//  Created by Daniel Kennett on 07/05/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSArray (KNArrayExtensions) 

-(NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)src;
-(NSArray *)arrayByRemovingObject:(id)anObject;

-(id)randomObject;

-(NSIndexSet *)indexesOfObjectsInArray:(NSArray *)src;

@end
