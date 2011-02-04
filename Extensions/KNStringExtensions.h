//
//  KNStringExtensions.h
// Teleport: AddOns
//
//  Created by Work on 22/11/2010.
//  Copyright 2010 KennettNet Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (KNStringExtensions)

-(NSString *)stringByAppendingUniquePathComponentFromName:(NSString *)fileName;

@end
