//
//  KNDateExtensions.m
//  Clarus
//
//  Created by Daniel Kennett on 01/02/2009.
//  Copyright 2009 KennettNet Software Limited. All rights reserved.
//

#import "KNDateExtensions.h"


@implementation NSDate (KNDateExtensions)

-(BOOL)isOnTheSameDayAsDate:(NSDate *)date {
 
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *selfComponents = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit 
											 fromDate:self];
	
	NSDateComponents *dateComponents = [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit 
											  fromDate:date];
	
	return (([selfComponents day] == [dateComponents day]) &&
			([selfComponents month] == [dateComponents month]) && 
			([selfComponents year] == [dateComponents year]));
    
}

-(NSDate *)dateWithDayDelta:(NSInteger)daysBeforeOrAfter atHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second {

    NSDate *date = [self addTimeInterval:(24 * 60 * 60) * daysBeforeOrAfter];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit 
										  fromDate:date];
	
	[comps setHour:hour];
	[comps setMinute:minute];
	[comps setSecond:second];
	
	return [calendar dateFromComponents:comps];
}

-(BOOL)isBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {

	if (startDate == nil || endDate == nil) {
		return NO;
	}
	
	NSDate *start = [startDate earlierDate:endDate];
	NSDate *end = [endDate laterDate:startDate];
	
	NSTimeInterval thisInterval = [self timeIntervalSinceReferenceDate];
	
	return (thisInterval >= [start timeIntervalSinceReferenceDate] &&
			thisInterval <= [end timeIntervalSinceReferenceDate]);
	
}

-(BOOL)isToday {
	
	return [self isOnTheSameDayAsDate:[NSDate date]];	
}

-(BOOL)isYesterday {
	
	NSDate *calcDate = [[NSDate alloc] initWithTimeInterval:86400.0 sinceDate:self]; 
	[calcDate autorelease];
	
	return [calcDate isToday];
	
}

-(BOOL)isTomorrow {
	
	NSDate *calcDate = [[NSDate alloc] initWithTimeInterval:-86400.0 sinceDate:self]; 
	[calcDate autorelease];
	
	return [calcDate isToday];
}

-(NSDate *)utcRepresentationFromSystemTimeZone {
    
    NSTimeZone *sourceTimeZone = [NSTimeZone systemTimeZone];
    NSTimeZone *destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    return [[[NSDate alloc] initWithTimeInterval:interval sinceDate:self] autorelease];    
}

-(NSDate *)systemRepresentationFromUTCTimeZone {
    
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    return [[[NSDate alloc] initWithTimeInterval:interval sinceDate:self] autorelease];    
}

@end
