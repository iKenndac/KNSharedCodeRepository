//
//  WoWCharacter.h
// Teleport: AddOns
//
//  Created by Daniel Kennett on 17/11/2010.
//  Copyright 2010 KennettNet Software Limited. All rights reserved.
//

#import "KNDataExtensions.h"
#include <openssl/md5.h>

@implementation NSData (KNDataExtensions)

-(NSString *)md5String {
    
    unsigned char *digest = MD5([self bytes], [self length], NULL);
    
    NSMutableString *str = [[NSMutableString alloc] init];
    
    int i;
    for (i = 0; i < MD5_DIGEST_LENGTH; i++) {
		[str appendFormat:@"%0.2x", *(digest + i)];
    }

#if !__has_feature(objc_arc)
    return [str autorelease];    
#else
	return str;
#endif
}

@end
