//
//  MMFastDateEnumeration.h
//  MMCalendarView
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMFastDateEnumeration : NSObject<NSFastEnumeration>

@property(nonatomic,strong,readonly) NSCalendar *calendar;
@property(nonatomic,strong,readonly) NSDate     *fromDate;
@property(nonatomic,strong,readonly) NSDate     *toDate;

@property(nonatomic,assign,readonly) NSCalendarUnit unit;

- (instancetype)initWithFromDate:(NSDate *)fromDate
                          toDate:(NSDate *)toDate
                        calendar:(NSCalendar *)calendar
                            unit:(NSCalendarUnit)unit;

@end
