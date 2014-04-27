//
//  Created by Mateusz Mackowiak on 27.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMCalendarView.h"

extern NSString *const MMCalendarDefaultWeekdayCellIdentifier;
extern NSString *const MMCalendarDefaultDayCellIdentifier;
extern NSString *const MMCalendarDefaultOtherMonthDayCellIdentifier;
extern NSString *const MMCalendarDefaultHeaderViewIdentifier;


@interface MMCalendarViewBaseDataSource : NSObject <MMCalendarViewDataSource>

@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSArray *weekdaySymbols;

-(void)registerCellClassesForCollectionView:(UICollectionView*)collectionView;

@end