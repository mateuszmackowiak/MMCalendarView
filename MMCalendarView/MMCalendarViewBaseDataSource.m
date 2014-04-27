//
//  Created by Mateusz Mackowiak on 27.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import "MMCalendarViewBaseDataSource.h"
#import "MMCalendarHeaderView.h"

NSString *const MMCalendarDefaultWeekdayCellIdentifier = @"MMCalendarDefaultWeekdayCellIdentifier__";
NSString *const MMCalendarDefaultDayCellIdentifier = @"MMCalendarDefaultDayCellIdentifier__";
NSString *const MMCalendarDefaultOtherMonthDayCellIdentifier = @"MMCalendarDefaultOtherMonthDayCellIdentifier__";
NSString *const MMCalendarDefaultHeaderViewIdentifier = @"MMCalendarDefaultHeaderViewIdentifier__";

@interface MMCalendarViewBaseDataSource (){
    CGFloat _pixelSize;
}

@end

@implementation MMCalendarViewBaseDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.formatter = [[NSDateFormatter alloc] init];
        self.calendar = NSCalendar.currentCalendar;
        _pixelSize = 1.f / UIScreen.mainScreen.scale;
    }
    return self;
}

-(void)setCalendar:(NSCalendar *)calendar{
    if (_calendar==calendar) {
        return;
    }
    _calendar = calendar;
    
    [self.formatter setDateFormat:@"MMMM yyyy"];
    self.formatter.calendar = calendar;
    self.weekdaySymbols = self.formatter.shortWeekdaySymbols;
}

-(UICollectionReusableView *)calendarView:(MMCalendarView *)calendarView monthHeaderViewForIndexPath:(NSIndexPath *)indexPath month:(NSDate *)month{
    MMCalendarHeaderView* headerView = [calendarView dequeueReusableMonthHeaderViewWithReuseIdentifier:MMCalendarDefaultHeaderViewIdentifier
                                                                                          forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.titleLabel.text = [self.formatter stringFromDate:month];
    return headerView;
}

-(MMCalendarViewCell*)calendarView:(MMCalendarView *)calendarView weekdayCellForIndexPath:(NSIndexPath *)indexPath weekday:(NSUInteger)weekday{
    
    MMCalendarViewCell*cell = [calendarView dequeueReusableCellWithReuseIdentifier:MMCalendarDefaultWeekdayCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.weekdaySymbols[weekday];
    cell.enabled = NO;   
    return cell;
}

-(MMCalendarViewCell *)calendarView:(MMCalendarView *)calendarView dayCellForIndexPath:(NSIndexPath *)indexPath day:(NSDate *)day inCurrentMonth:(BOOL)inCurrentMonth{
    if (!inCurrentMonth) {
        return [self getOtherMonthCellForCalendarView:calendarView day:day andIndexPath:indexPath];
    }
    return [self getCurrentMonthCellForCalendarView:calendarView day:day andIndexPath:indexPath];
}

-(MMCalendarViewCell*)getCurrentMonthCellForCalendarView:(MMCalendarView*)calendarView day:(NSDate *)day andIndexPath:(NSIndexPath*)indexPath{
    MMCalendarViewCell*cell = [calendarView dequeueReusableCellWithReuseIdentifier:MMCalendarDefaultDayCellIdentifier forIndexPath:indexPath];
    NSDateComponents *components = [self.calendar components:NSDayCalendarUnit fromDate:day];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)components.day];
    
    cell.titleLabel.textColor = [UIColor darkTextColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.enabled = YES;
    
    cell.layer.borderWidth = _pixelSize;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    return cell;
}

-(MMCalendarViewCell*)getOtherMonthCellForCalendarView:(MMCalendarView*)calendarView day:(NSDate *)day andIndexPath:(NSIndexPath*)indexPath{
    MMCalendarViewCell*cell = [calendarView dequeueReusableCellWithReuseIdentifier:MMCalendarDefaultOtherMonthDayCellIdentifier forIndexPath:indexPath];
    
    NSDateComponents *components = [self.calendar components:NSDayCalendarUnit fromDate:day];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)components.day];
    
    cell.titleLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.enabled = NO;
    
    cell.layer.borderWidth = _pixelSize;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    return cell;
}

-(void)registerCellClassesForCollectionView:(UICollectionView*)collectionView{
    [collectionView registerClass:MMCalendarHeaderView.class
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:MMCalendarDefaultHeaderViewIdentifier];
    
    [collectionView registerClass:MMCalendarViewCell.class
       forCellWithReuseIdentifier:MMCalendarDefaultDayCellIdentifier];
    
    [collectionView registerClass:MMCalendarViewCell.class
       forCellWithReuseIdentifier:MMCalendarDefaultWeekdayCellIdentifier];
    
    [collectionView registerClass:MMCalendarViewCell.class
       forCellWithReuseIdentifier:MMCalendarDefaultOtherMonthDayCellIdentifier];
}

-(CGFloat)calendarView:(MMCalendarView *)calendarView weekdayCellsHeightForMonth:(NSDate *)month{
    return 25.f;
}

-(CGFloat)calendarView:(MMCalendarView *)calendarView monthHeaderViewHightForMonth:(NSDate *)month{
    return 30.f;
}

@end