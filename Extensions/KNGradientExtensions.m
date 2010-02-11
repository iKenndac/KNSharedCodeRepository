//
//  KNGradientExtensions.m
//  Clarus
//
//  Created by Daniel Kennett on 20/04/2009.
//  Copyright 2009 KennettNet Software, Limited. All rights reserved.
//

#import "KNGradientExtensions.h"


@implementation NSGradient (KNGradientExtensions)

+ (id)aquaSelectedGradient {
	
	return [[[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedRed:0.58 green:0.86 blue:0.98 alpha:1.0], 0.0,
			 [NSColor colorWithCalibratedRed:0.42 green:0.68 blue:0.90 alpha:1.0], 11.5/23,
			 [NSColor colorWithCalibratedRed:0.64 green:0.80 blue:0.94 alpha:1.0], 11.5/23,
			 [NSColor colorWithCalibratedRed:0.56 green:0.70 blue:0.90 alpha:1.0], 1.0, nil] autorelease];
	
	
}
	
+ (id)aquaNormalGradient { 
	
	return [[[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedWhite:0.95 alpha:1.0], 0.0,
			 [NSColor colorWithCalibratedWhite:0.83 alpha:1.0], 11.5/23,
			 [NSColor colorWithCalibratedWhite:0.95 alpha:1.0], 11.5/23,
			 [NSColor colorWithCalibratedWhite:0.92 alpha:1.0], 1.0, nil] autorelease];
	
	
} 

+ (id)aquaPressedGradient { 
	
	return [[[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedWhite:0.8 alpha:1.0], 0.0,
			 [NSColor colorWithCalibratedWhite:0.64 alpha:1.0], 11.5/23,
			 [NSColor colorWithCalibratedWhite:0.8 alpha:1.0], 11.5/23,
			 [NSColor colorWithCalibratedWhite:0.77 alpha:1.0], 1.0, nil] autorelease];
							
	
} 


+ (id)unifiedSelectedGradient { 
	
	return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.85 alpha:1.0]
										  endingColor:[NSColor colorWithCalibratedWhite:0.95 alpha:1.0]] autorelease];

	
} 

+ (id)unifiedNormalGradient { 
	
	return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.75 alpha:1.0]
										  endingColor:[NSColor colorWithCalibratedWhite:0.90 alpha:1.0]] autorelease];

	
} 

+ (id)unifiedPressedGradient { 

	return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.60 alpha:1.0]
										  endingColor:[NSColor colorWithCalibratedWhite:0.75 alpha:1.0]] autorelease];
	
	
} 

+ (id)unifiedDarkGradient { 

	return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.68 alpha:1.0]
										  endingColor:[NSColor colorWithCalibratedWhite:0.83 alpha:1.0]] autorelease];

	
} 


+ (id)sourceListSelectedGradient { 

	return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.06 green:0.37 blue:0.85 alpha:1.0]
										  endingColor:[NSColor colorWithCalibratedRed:0.30 green:0.60 blue:0.92 alpha:1.0]] autorelease];

	
} 

+ (id)sourceListUnselectedGradient {
		
	return [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.43 alpha:1.0]
										 endingColor:[NSColor colorWithCalibratedWhite:0.6 alpha:1.0]] autorelease];
	
} 


-(void)fillRect:(NSRect)frame angle:(CGFloat)angle {
	
	[self drawInRect:frame angle:angle];
	
}

-(void)fillBezierPath:(NSBezierPath *)path angle:(CGFloat)angle {
	[self drawInBezierPath:path angle:angle];
}

@end
