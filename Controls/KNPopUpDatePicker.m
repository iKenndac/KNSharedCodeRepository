//
//  KNPopUpDatePicker.m
//  Clarus
//
//  Created by Daniel Kennett on 21/04/2009.
//  Copyright 2009 KennettNet Software, Limited. All rights reserved.
//

#import "KNPopUpDatePicker.h"

@interface KNPopUpDatePicker (Private)

-(MAAttachedWindow *)attachedWindow;

@end

@implementation KNPopUpDatePicker

-(void)dealloc {
	
	if (attachedWindow) {
		[[attachedWindow parentWindow] removeChildWindow:attachedWindow];
		[attachedWindow release];
		attachedWindow = nil;
	}
	
	[graphicalPicker release];
	graphicalPicker = nil;
	
	observingObject = nil;
	[keyPathOnObservingObject release];
	keyPathOnObservingObject = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Responder Chain

NSTimeInterval fadeInDuration = 0.25;

- (BOOL)becomeFirstResponder {
	
	BOOL didBecome = [super becomeFirstResponder];
	
	if (didBecome) {
		NSDisableScreenUpdates();
		[[self attachedWindow] setPoint:[self convertPoint:NSMakePoint([self frame].size.width, [self frame].size.height / 2) toView:nil]];
		[graphicalPicker setDateValue:[self dateValue]];

		[self setDelegate:self];
		[[self window] addChildWindow:[self attachedWindow] ordered:NSWindowAbove];
		
		if ([[self attachedWindow] respondsToSelector:@selector(fadeInWithDuration:)]) {
			
			//If you have NSWindow+Fade in your assembly, we invoke fadeInWithDuration: to make it pretty.
			
			NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[[self attachedWindow] class] instanceMethodSignatureForSelector:@selector(fadeInWithDuration:)]];
			[inv setTarget:[self attachedWindow]];
			[inv setSelector:@selector(fadeInWithDuration:)];
			[inv setArgument:&fadeInDuration atIndex:2];
			[inv invoke];
		} else {
			[[self attachedWindow] orderFront:nil];
		}
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(windowResized:)
													 name:NSWindowDidResizeNotification
												   object:nil];
		
		NSEnableScreenUpdates();
	}
	
	return didBecome;
	
}


- (BOOL)resignFirstResponder {
	
	BOOL didResign = [super resignFirstResponder];
	
	if (didResign) {
		NSDisableScreenUpdates();
		[[self window] removeChildWindow:[self attachedWindow]];
		
		if ([[self attachedWindow] respondsToSelector:@selector(fadeOutWithDuration:)]) {
			
			//If you have NSWindow+Fade in your assembly, we invoke fadeOutWithDuration: to make it pretty.
			
			NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[[self attachedWindow] class] instanceMethodSignatureForSelector:@selector(fadeOutWithDuration:)]];
			[inv setTarget:[self attachedWindow]];
			[inv setSelector:@selector(fadeOutWithDuration:)];
			[inv setArgument:&fadeInDuration atIndex:2];
			[inv invoke];
			
		} else {
			[[self attachedWindow] orderOut:nil];
		}
			
		[self setDelegate:nil];
		[[self window] becomeKeyWindow];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:nil];
	
		NSEnableScreenUpdates();
	}
	
	return didResign;
	
}

#pragma mark -
#pragma mark Value syncing

- (void)datePickerCell:(NSDatePickerCell *)aDatePickerCell validateProposedDateValue:(NSDate **)proposedDateValue timeInterval:(NSTimeInterval *)proposedTimeInterval {
	
	[graphicalPicker setDateValue:*proposedDateValue];
}

-(void)graphicalDatePickerdDidChooseDate:(id)sender {
	
	[self setDateValue:[sender dateValue]];
	
	if (observingObject) {
		NSArray *keys = [keyPathOnObservingObject componentsSeparatedByString:@"."];
	
		if ([keys count] == 0) {
			return;
		} else if ([keys count] == 1) {
			[observingObject setValue:[self dateValue] forKey:keyPathOnObservingObject];
		} else {
			
			id obj = observingObject;
			
			for (NSString *key in keys) {
				if (key != [keys lastObject]) {
					obj = [obj valueForKey:key];
				}
			}
			
			[obj setValue:[self dateValue] forKey:[keys lastObject]]; 
			
		}
		
	}
}

-(void)setDateValue:(NSDate *)newStartDate {

	[super setDateValue:newStartDate];
	[graphicalPicker setDateValue:[self dateValue]];
}

#pragma mark -
#pragma mark Notification

-(void)windowResized:(NSNotification *)notification {
	
	if ([notification object] == [self window]) {
		
		if ([[self attachedWindow] isVisible]) {
			
			[[self attachedWindow] setPoint:[self convertPoint:NSMakePoint([self frame].size.width, [self frame].size.height / 2) toView:nil]];
		}
	}
}


#pragma mark -
#pragma mark Custom bindings


- (void)bind:(NSString *)binding
	toObject:(id)observableObject
 withKeyPath:(NSString *)keyPath
	 options:(NSDictionary *)options
{
	
	if ([binding isEqualToString:@"value"]) {
		
		// This is a bit hacky, right? 
		// However, we have to faff around like this to make sure any bound objects
		// get change notifications. Manually firing will/didChangeValueForKey isn't enough! :-(
	
		observingObject = observableObject;
		keyPathOnObservingObject = [keyPath copy];
	}
	
	[super bind:binding toObject:observableObject withKeyPath:keyPath options:options];

}

- (void)unbind:(NSString *)binding {
	
	if ([binding isEqualToString:@"value"]) {
		observingObject = nil;
		[keyPathOnObservingObject release];
		keyPathOnObservingObject = nil;
	}
	
	[super unbind:binding];
}
	
	  
#pragma mark -
#pragma mark Attached Window

-(MAAttachedWindow *)attachedWindow {

	if (!graphicalPicker) {
		
		graphicalPicker = [[NSDatePicker alloc] initWithFrame:NSMakeRect(0.0, 0.0, 139.0, 148.0)]; // <-- The size of the graphical picker in IB
		[graphicalPicker setDrawsBackground:YES];
		[graphicalPicker setBordered:NO];
		[graphicalPicker setDatePickerStyle:NSClockAndCalendarDatePickerStyle];
		[graphicalPicker setDatePickerMode:NSSingleDateMode];
		[graphicalPicker setDatePickerElements:NSYearMonthDayDatePickerElementFlag];
		[graphicalPicker sizeToFit];
		
		[graphicalPicker setTarget:self];
		[graphicalPicker setAction:@selector(graphicalDatePickerdDidChooseDate:)];
		
	}
		
	if (!attachedWindow) {
		
		attachedWindow = [[MAAttachedWindow alloc] initWithView:graphicalPicker 
												attachedToPoint:[self convertPoint:NSMakePoint([self frame].size.width, [self frame].size.height / 2) toView:nil]
													   inWindow:[self window]
														 onSide:MAPositionRightBottom
													 atDistance:0.0];
		[attachedWindow setBackgroundColor:[NSColor whiteColor]];
	}
	
	return attachedWindow;
	
}



@end
