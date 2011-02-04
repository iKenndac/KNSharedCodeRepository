//
//  KNAutocompleteField.m
//  Autocomplete Test
//
//  Created by Daniel Kennett on 14/03/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//

#import "KNAutocompleteField.h"

@interface KNAutocompleteField (Private)

- (void)stopCompletionTimer;

@end

@implementation KNAutocompleteField


-(void)dealloc {
	[autoCompleteItems release];
	[super dealloc];
}


-(NSArray *)autoCompleteItems {
	return autoCompleteItems;
}

-(void)setAutoCompleteItems:(NSArray *)items {
	[autoCompleteItems release];
	autoCompleteItems = [items retain];
}


#define COMPLETION_DELAY (0.5)

- (void)doCompletion:(NSTimer *)timer {
    [self stopCompletionTimer];
    [[self currentEditor] complete:nil];
}

- (void)startCompletionTimer {
    [self stopCompletionTimer];
    completionTimer = [[NSTimer scheduledTimerWithTimeInterval:COMPLETION_DELAY target:self  
													  selector:@selector(doCompletion:) userInfo:nil repeats:NO] retain];
}

- (void)stopCompletionTimer {
    [completionTimer invalidate];
    [completionTimer release];
    completionTimer = nil;
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange: 
(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    /* Start a timer to fire autocompletion on the typing of "c" in  
	 "Mac".  Stop the timer on any other changes. */

    if (![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:
		  [replacementString characterAtIndex:[replacementString length] - 1]]
		&& ![replacementString caseInsensitiveCompare:@""] == NSOrderedSame) {
        [self startCompletionTimer];
        nextInsertionIndex = affectedCharRange.location +  
		[replacementString length];
	} else {
		[self stopCompletionTimer];
		nextInsertionIndex = NSNotFound;
	}
    return YES;
}

- (NSRange)textView:(NSTextView *)textView   
willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange)newSelectedCharRange {
    /* Stop the timer on selection changes other than those caused  
	 by the typing that started the timer. */
    if (newSelectedCharRange.length > 0 ||  
		newSelectedCharRange.location != nextInsertionIndex) [self stopCompletionTimer];
    return newSelectedCharRange;
}

- (NSArray *)textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index {
	
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *string = [[textView string]  
						substringWithRange:charRange];
	
	
	NSEnumerator *e = [[self autoCompleteItems] objectEnumerator];
	NSString *item;
	
	while ((item = [e nextObject])) {
		
		if ([item length] >= charRange.length) {
			
			if ([[item substringWithRange:NSMakeRange(0, charRange.length)] caseInsensitiveCompare:string] == NSOrderedSame) {
				//NSLog(@"Comparing %@ to %@", item, string);
				if (![result containsObject:item]) {
					[result addObject:item];
				}
			}
			
		}
		
	}
	
	
	/*
	 if (NSOrderedSame == [@"Mac" compare:string  
	 options:NSCaseInsensitiveSearch]) {
	 result = [NSArray arrayWithObjects:@"Macintosh", @"Mac OS",  
	 @"Mac OS X", nil];
	 }*/
    return [result autorelease];
}

@end
