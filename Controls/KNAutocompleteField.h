//
//  KNAutocompleteField.h
//  Autocomplete Test
//
//  Created by Daniel Kennett on 14/03/2008.
//  Copyright 2008 KennettNet Software Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BWToolkitFramework/BWToolkitFramework.h>

@interface KNAutocompleteField : BWStyledTextField {

	NSArray *autoCompleteItems;
	NSTimer *completionTimer;
	NSInteger nextInsertionIndex;

}

-(NSArray *)autoCompleteItems;
-(void)setAutoCompleteItems:(NSArray *)items;

@end
