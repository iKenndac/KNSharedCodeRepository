//
//  KNPopUpDatePicker.h
//  Clarus
//
//  Created by Daniel Kennett on 21/04/2009.
//  Copyright 2009 KennettNet Software, Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MAAttachedWindow.h"

@interface KNPopUpDatePicker : NSDatePicker <NSDatePickerCellDelegate> {

	MAAttachedWindow *attachedWindow;
	NSDatePicker *graphicalPicker;	
	
	id observingObject;
	NSString *keyPathOnObservingObject;
}

@end
