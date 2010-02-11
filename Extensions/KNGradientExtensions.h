//
//  KNGradientExtensions.h
//  Clarus
//
//  Created by Daniel Kennett on 20/04/2009.
//  Copyright 2009 KennettNet Software, Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>


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
