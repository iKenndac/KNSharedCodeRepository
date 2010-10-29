//
//  KNGradientExtensions.h
//  Clarus
//
//  Created by Daniel Kennett on 20/04/2009.
//  Copyright 2009 KennettNet Software, Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#if __MAC_OS_X_VERSION_MIN_REQUIRED < 1050 

#define NSGradient _CTGradient
#define CGFloat float

#import "_CTGradient.h"

@interface _CTGradient (KNGradientExtensions)

-(_CTGradient *)initWithStartingColor:(NSColor *)start endingColor:(NSColor *)end;

@end

#endif

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1050

@interface NSGradient (KNGradientExtensions)

+ (id)aquaSelectedGradient;
+ (id)aquaNormalGradient;
+ (id)aquaPressedGradient;

+ (id)unifiedSelectedGradient;
+ (id)unifiedNormalGradient;
+ (id)unifiedPressedGradient;
+ (id)unifiedDarkGradient;

+ (id)sourceListSelectedGradient;
+ (id)sourceListUnselectedGradient;

-(void)fillRect:(NSRect)frame angle:(CGFloat)angle;
-(void)fillBezierPath:(NSBezierPath *)path angle:(CGFloat)angle;


@end

#endif

