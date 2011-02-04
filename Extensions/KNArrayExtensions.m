//
//  KNArrayExtensions.m
//  Music Rescue 4
//
//  Created by Daniel Kennett on 07/05/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//

#import "KNArrayExtensions.h"


@implementation NSArray (KNArrayExtensions) 

-(NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)src {
	

	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	NSEnumerator *e = [self objectEnumerator];
	id item;
	
	while ((item = [e nextObject])) {
		
		if (![src containsObject:item]) {
			[array addObject:item];
		}
	}
	
	[array autorelease];
	return [NSArray arrayWithArray:array];
	
}

-(NSArray *)arrayByRemovingObject:(id)anObject {
	
	NSMutableArray *array = [self mutableCopy];
	
	[array removeObject:anObject];
	[array autorelease];
	return [NSArray arrayWithArray:array];
	
}

-(NSIndexSet *)indexesOfObjectsInArray:(NSArray *)src {

	NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
	
	for (id obj in src) {
		[set addIndex:[self indexOfObject:obj]];
	}
	
	return [[[NSIndexSet alloc] initWithIndexSet:set] autorelease];
}


-(id)randomObject {
	
	srandom(time(NULL));
	
    long long index = random() % [self count];
	
	if (index >= 0 && index <= ([self count] - 1)) {
		return [self objectAtIndex:index];
	} else {
		return nil;
	}
	
}

@end

