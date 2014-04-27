//
//  NSDate+MMAdditions.m
//  MMCalendarView
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import "NSDate+MMAdditions.h"

NSTimeInterval const MMSecond = 1.0;
NSTimeInterval const MMMinute = 60.0;
NSTimeInterval const MMHour = 3600.0;
NSTimeInterval const MMDay = 86400.0;
NSTimeInterval const MMWeek = 604800.0;
NSTimeInterval const MMYear = 31556926.0;

@implementation NSDate (MMAdditions)

- (instancetype)mm_firstDateOfMonth:(NSCalendar *)calendar {
 
  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
  
  [components setDay:1];
  
  return [calendar dateFromComponents:components];
}

- (instancetype)mm_lastDateOfMonth:(NSCalendar *)calendar {

  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
  [components setDay:0];
  [components setMonth:components.month + 1];
  
  return [calendar dateFromComponents:components];
}

- (instancetype)mm_beginningOfDay:(NSCalendar *)calendar {

  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
  [components setHour:0];
  
  return [calendar dateFromComponents:components];
}

- (instancetype)mm_dateWithDay:(NSUInteger)day calendar:(NSCalendar *)calendar {

  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
  
  [components setDay:day];
  
  return [calendar dateFromComponents:components];
}

@end
