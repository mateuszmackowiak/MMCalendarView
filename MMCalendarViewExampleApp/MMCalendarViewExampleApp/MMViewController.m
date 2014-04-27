//
//  MMViewController.m
//  MMCalendarViewExampleApp
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import "MMViewController.h"
#import "MMCalendarView.h"
#import "MMCalendarHeaderView.h"
#import "NSDate+MMAdditions.h"
#import "CustomCalendarViewCell.h"
#import "MMCalendarViewBaseDataSource.h"

@interface MMViewController () <MMCalendarViewDelegate, MMCalendarViewDataSource>

@property(nonatomic,strong) IBOutlet MMCalendarView *calendarView;

@property (nonatomic, strong) NSDateFormatter* formatter;
@property (nonatomic, strong) NSArray *weekdaySymbols;

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation MMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.calendarView.dataSource = self;
    self.calendarView.delegate = self;
    
    self.calendarView.snapMonthHeader = YES;
    self.calendarView.snapOnMonth = YES;
    self.calendarView.backgroundColor = [UIColor colorWithRed:.96f green:.96f blue:.96f alpha:1.f];
    self.calendarView.allowsMultipleSelection = YES;
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"MMMM yyyy"];
    self.formatter.calendar = self.calendarView.calendar;
    
    self.selectedDate = [[NSDate date] mm_beginningOfDay:self.calendarView.calendar];
    self.currentDate = [[NSDate date] mm_beginningOfDay:self.calendarView.calendar];
    
    self.weekdaySymbols = self.formatter.shortWeekdaySymbols;

    [self.calendarView registerClass:[CustomCalendarViewCell class] forCellWithReuseIdentifier:CustomCalendarViewCellIdentifier];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.calendarView invalidateLayout];
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.calendarView invalidateLayout];
}

- (IBAction)todayButtonTapped:(id)sender {
    [self.calendarView scrollToDate:self.currentDate atScrollPosition:MMCalendarViewScrollPositionTop animated:YES];
}

#pragma mark - MMCalendarViewDataSource

-(MMCalendarViewCell *)calendarView:(MMCalendarView *)calendarView dayCellForIndexPath:(NSIndexPath *)indexPath day:(NSDate *)day inCurrentMonth:(BOOL)inCurrentMonth{
    CustomCalendarViewCell*cell = [calendarView dequeueReusableCellWithReuseIdentifier:CustomCalendarViewCellIdentifier forIndexPath:indexPath];
    
    NSDateComponents *components = [calendarView.calendar components:NSDayCalendarUnit fromDate:day];

    cell.titleLabel.text = inCurrentMonth?[NSString stringWithFormat:@"%ld",(long)components.day]:nil;
    
    cell.enabled = inCurrentMonth;
    if (inCurrentMonth && [self.currentDate isEqualToDate:day]) {
        cell.titleLabel.textColor = [UIColor colorWithRed:0.770 green:0.000 blue:0.008 alpha:1.000];
    }else{
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

-(CGFloat)calendarView:(MMCalendarView *)calendarView monthHeaderViewHightForMonth:(NSDate *)month{
    return 0.f;
}

#pragma mark - MMCalendarViewDelegate


@end
