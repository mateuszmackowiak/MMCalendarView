//
//  MMCalendarView.h
//  MMCalendarView
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMCalendarViewCell.h"

@protocol MMCalendarViewDelegate;
@protocol MMCalendarViewDataSource;



typedef NS_OPTIONS(NSUInteger, MMCalendarViewScrollPosition) {
    MMCalendarViewScrollPositionNone                 = UICollectionViewScrollPositionNone,
    MMCalendarViewScrollPositionTop                  = UICollectionViewScrollPositionTop,
    MMCalendarViewScrollPositionCentered             = UICollectionViewScrollPositionCenteredVertically,
    MMCalendarViewScrollPositionBottom               = UICollectionViewScrollPositionBottom,
    MMCalendarViewScrollPositionMonth                = 1 << 8
};

@interface MMCalendarView : UIView

@property(nonatomic,strong,readonly) UICollectionView *collectionView;

@property(nonatomic,weak) id<MMCalendarViewDataSource> dataSource;
@property(nonatomic,weak) id<MMCalendarViewDelegate> delegate;

@property(nonatomic,assign,readwrite) NSUInteger daysInWeek;

@property(nonatomic,strong) NSCalendar *calendar;
@property(nonatomic,copy)   NSDate     *fromDate;
@property(nonatomic,copy)   NSDate     *toDate;

@property(nonatomic, assign) BOOL snapOnMonth; // default is NO
@property(nonatomic, assign) BOOL snapMonthHeader; // default is NO

@property (nonatomic) BOOL allowsSelection; // default is YES
@property (nonatomic) BOOL allowsMultipleSelection; // default is NO

-(NSUInteger)numberOfMonths;

- (void)reloadData;

-(NSInteger)numberOfDayCellsInMonth:(NSDate*)month;
-(BOOL)isItemInCurrentMonthAtIndexPath:(NSIndexPath*)indexPath;

-(NSDate*)dateForIndexPath:(NSIndexPath*)indexPath;
-(NSIndexPath *)indexPathForDate:(NSDate *)date;

/**
 Invalidates the current layout and triggers a layout update.
 You can call this method at any time to update the layout information. This method invalidates the layout of the calendar view itself and returns right away. Thus, you can call this method multiple times from the same block of code without triggering multiple layout updates. The actual layout update occurs during the next view layout update cycle.
 If you override this method, you must call super at some point in your implementation.*/
- (void)invalidateLayout;

@end


@interface MMCalendarView (Reusable)

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (void)registerClass:(Class)viewClass forMonthHeaderViewWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forMonthHeaderViewWithReuseIdentifier:(NSString *)identifier;

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath;

- (id)dequeueReusableMonthHeaderViewWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath;

@end

@interface MMCalendarView (ScrollAndSelect)

- (void)scrollToDate:(NSDate *)date atScrollPosition:(MMCalendarViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)selectDate:(NSDate *)date animated:(BOOL)animated scrollPosition:(MMCalendarViewScrollPosition)scrollPosition;
- (void)deselectDate:(NSDate *)date animated:(BOOL)animated;

- (NSArray *)indexPathsForSelectedItems;
- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(MMCalendarViewScrollPosition)scrollPosition;
- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(MMCalendarViewScrollPosition)scrollPosition animated:(BOOL)animated;

@end



@protocol MMCalendarViewDataSource <NSObject>

@optional

-(UICollectionReusableView*)calendarView:(MMCalendarView *)calendarView
             monthHeaderViewForIndexPath:(NSIndexPath*)indexPath
                                   month:(NSDate*)month;

-(MMCalendarViewCell*)calendarView:(MMCalendarView *)calendarView
               dayCellForIndexPath:(NSIndexPath*)indexPath
                               day:(NSDate*)day
                    inCurrentMonth:(BOOL)inCurrentMonth;

-(MMCalendarViewCell*)calendarView:(MMCalendarView *)calendarView
           weekdayCellForIndexPath:(NSIndexPath*)indexPath
                           weekday:(NSUInteger)weekday;

-(CGFloat)calendarView:(MMCalendarView *)calendarView
            weekdayCellsHeightForMonth:(NSDate*)month;

-(CGFloat)calendarView:(MMCalendarView *)calendarView
  dayCellHightForMonth:(NSDate*)month;

-(CGFloat)calendarView:(MMCalendarView *)calendarView
            monthHeaderViewHightForMonth:(NSDate*)month;

@end






@protocol MMCalendarViewDelegate <NSObject>

@optional


@end
