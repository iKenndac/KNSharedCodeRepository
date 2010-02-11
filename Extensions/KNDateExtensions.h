//
//  KNDateExtensions.h
//  Clarus
//
//  Created by Daniel Kennett on 01/02/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDateYesterday -1
#define kDateTomorrow 1
#define kDateToday 0

@interface NSDate (KNDateExtensions)

-(BOOL)isOnTheSameDayAsDate:(NSDate *)date;
-(NSDate *)dateWithDayDelta:(NSInteger)daysBeforeOrAfter atHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;
-(BOOL)isToday;
-(BOOL)isYesterday;
-(BOOL)isTomorrow;

@end
