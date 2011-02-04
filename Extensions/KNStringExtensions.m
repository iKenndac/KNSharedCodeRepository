//
//  KNStringExtensions.m
// Teleport: AddOns
//
//  Created by Work on 22/11/2010.
//  Copyright 2010 KennettNet Software Limited. All rights reserved.
//

#import "KNStringExtensions.h"


@implementation NSString (KNStringExtensions)

-(NSString *)stringByAppendingUniquePathComponentFromName:(NSString *)fileName {
    
    if ([fileName length] == 0) {
        return self;
    }
    
    // This method passes back a unique file name for the passed file and path. 
	// So, for example, if the caller wants to put a file called "Hello.txt" in ~/Desktop
	// and that file already exists, it'll give back ~/Desktop/Hello 2.txt".
	// The method respects extensions and will keep incrementing the number until it finds a unique name. 
	
	BOOL fileMade = NO;
	NSFileManager *manager = [NSFileManager defaultManager];
	int uNum = 2;
	
	if (![manager fileExistsAtPath:[self stringByAppendingPathComponent:fileName]]) {
		return [self stringByAppendingPathComponent:fileName];
	} else {
		
		while (!fileMade) {
			
			NSString *newName = [NSString stringWithFormat:@"%@ %d.%@", [fileName stringByDeletingPathExtension], uNum, [fileName pathExtension]];
			
			NSString *totalPath = [self stringByAppendingPathComponent:newName];
			
			if ([manager fileExistsAtPath:totalPath]) { 
				uNum++;
			} else {
				fileMade = YES; 
				return totalPath;
			}
		}
        
        // If here, something went very wrong
        
        return [self stringByAppendingPathComponent:fileName];
	}
    
}



@end
