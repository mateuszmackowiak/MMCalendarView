//
//  NSDate+MMAdditions.h
//  MMCalendarView
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSTimeInterval const MMSecond;
extern NSTimeInterval const MMMinute;
extern NSTimeInterval const MMHour;
extern NSTimeInterval const MMDay;
extern NSTimeInterval const MMWeek;
extern NSTimeInterval const MMYear;

@interface NSDate (MMAdditions)

- (instancetype)mm_firstDateOfMonth:(NSCalendar *)calendar;

- (instancetype)mm_lastDateOfMonth:(NSCalendar *)calendar;

- (instancetype)mm_beginningOfDay:(NSCalendar *)calendar;

- (instancetype)mm_dateWithDay:(NSUInteger)day calendar:(NSCalendar *)calendar;

@end
