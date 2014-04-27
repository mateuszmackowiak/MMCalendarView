//
//  MMCalendarView.m
//  MMCalendarView
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import "MMCalendarView.h"
#import "MMCalendarViewCell.h"
#import "MMCalendarViewLayout.h"
#import "MMCalendarHeaderView.h"
#import "MMFastDateEnumeration.h"
#import "NSDate+MMAdditions.h"
#import "MMCalendarViewBaseDataSource.h"



@interface MMCalendarView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong,readwrite) UICollectionView *collectionView;
@property(nonatomic,strong,readwrite) UICollectionViewFlowLayout *layout;

@property(nonatomic,strong,readwrite) NSArray *monthDates;

@property(nonatomic,strong) MMCalendarViewBaseDataSource* defaultDataSource;

@end

@implementation MMCalendarView

- (void)mmMMCalendarView_commonInit {
    
    _calendar   = [NSCalendar currentCalendar];
    _fromDate   = [[NSDate date] mm_beginningOfDay:self.calendar];
    _toDate     = [self.fromDate dateByAddingTimeInterval:MMYear];
    _daysInWeek = 7;
    
    self.defaultDataSource = [[MMCalendarViewBaseDataSource alloc] init];
    [self.defaultDataSource registerCellClassesForCollectionView:self.collectionView];
    
    [self addSubview:self.collectionView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self applyConstraints];
    [self reloadData];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.collectionView.backgroundColor = backgroundColor;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self mmMMCalendarView_commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if ( self ) {
        [self mmMMCalendarView_commonInit];
    }
    
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self invalidateLayout];
}

- (UICollectionView *)collectionView {
    if (nil == _collectionView) {
        MMCalendarViewLayout *layout = [[MMCalendarViewLayout alloc] init];
        
        _collectionView =
        [[UICollectionView alloc] initWithFrame:CGRectZero
                           collectionViewLayout:layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
    }
    return _collectionView;
}

-(void)setCalendar:(NSCalendar *)calendar{
    if (_calendar==calendar) {
        return;
    }
    _calendar = calendar;
    self.defaultDataSource.calendar = calendar;
}


- (void)reloadData {
    NSMutableArray *monthDates = @[].mutableCopy;
    MMFastDateEnumeration *enumeration =
    [[MMFastDateEnumeration alloc] initWithFromDate:[self.fromDate mm_firstDateOfMonth:self.calendar]
                                             toDate:[self.toDate mm_firstDateOfMonth:self.calendar]
                                           calendar:self.calendar
                                               unit:NSMonthCalendarUnit];
    for (NSDate *date in enumeration) {
        [monthDates addObject:date];
    }
    self.monthDates = monthDates;
    [self.collectionView reloadData];
}

- (NSDate *)firstVisibleDateOfMonth:(NSDate *)date {
    date = [date mm_firstDateOfMonth:self.calendar];
    
    NSDateComponents *components =
    [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:date];
    
    return [[date mm_dateWithDay:-((components.weekday - 1) % self.daysInWeek) calendar:self.calendar] dateByAddingTimeInterval:MMDay];
}

- (NSDate *)lastVisibleDateOfMonth:(NSDate *)date {
    date = [date mm_lastDateOfMonth:self.calendar];
    
    NSDateComponents *components =
    [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                     fromDate:date];
    
    return
    [date mm_dateWithDay:components.day + (self.daysInWeek - 1) - ((components.weekday - 1) % self.daysInWeek)
                calendar:self.calendar];
}

- (void)applyConstraints {
    NSDictionary *views = @{@"collectionView" : self.collectionView};
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.monthDates.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDate *monthDate = self.monthDates[section];
    NSUInteger dayCells = [self numberOfDayCellsInMonth:monthDate];
    if ([self shouldShowWeekdaysInSection:section]) {
        return self.daysInWeek + dayCells;
    }else{
        return dayCells;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [self monthHeaderViewForIndexPath:(NSIndexPath*)indexPath];
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self shouldShowWeekdaysInSection:indexPath.section] && indexPath.item < self.daysInWeek) {
        return [self weekdayCellForIndexPath:indexPath];
    }
    return [self dayCellForIndexPath:indexPath];
}

#pragma mark - reuseble views configuration

-(UICollectionReusableView*)monthHeaderViewForIndexPath:(NSIndexPath*)indexPath{
    if(![self shouldShowMonthHeaderInSection:indexPath.section]){
        return nil;
    }
    NSDate* monthDate = self.monthDates[indexPath.section];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:monthHeaderViewForIndexPath:month:)]) {
        return [self.dataSource calendarView:self monthHeaderViewForIndexPath:indexPath month:[monthDate copy]];
    }
    return [self.defaultDataSource calendarView:self monthHeaderViewForIndexPath:indexPath month:monthDate];
}

-(MMCalendarViewCell*)weekdayCellForIndexPath:(NSIndexPath*)indexPath{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:weekdayCellForIndexPath:weekday:)]) {
        return [self.dataSource calendarView:self weekdayCellForIndexPath:indexPath weekday:indexPath.item];
    }
    return [self.defaultDataSource calendarView:self weekdayCellForIndexPath:indexPath weekday:indexPath.item];
}

-(MMCalendarViewCell*)dayCellForIndexPath:(NSIndexPath*)indexPath{
    NSDate* monthDate = self.monthDates[indexPath.section];
    NSDate* date = [self dateForIndexPath:indexPath];
    
    NSDateComponents *components = [self.calendar components:NSMonthCalendarUnit
                                                    fromDate:date];
    
    NSDateComponents *monthComponents = [self.calendar components:NSMonthCalendarUnit
                                                         fromDate:monthDate];
    BOOL inCurrentMonth = monthComponents.month == components.month;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:dayCellForIndexPath:day:inCurrentMonth:)]){
        return [self.dataSource calendarView:self dayCellForIndexPath:indexPath day:date inCurrentMonth:inCurrentMonth];
    }
    return [self.defaultDataSource calendarView:self dayCellForIndexPath:indexPath day:date inCurrentMonth:inCurrentMonth];
}


#pragma mark - Helper methods

-(NSInteger)numberOfDayCellsInMonth:(NSDate *)month{
    NSDateComponents *components =
    [self.calendar components:NSDayCalendarUnit
                     fromDate:[self firstVisibleDateOfMonth:month]
                       toDate:[self lastVisibleDateOfMonth:month]
                      options:0];
    return components.day + 1;
}

-(BOOL)shouldShowWeekdaysInSection:(NSInteger)section{
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(calendarView:weekdayCellsHeightForMonth:)]) {
        return [self.defaultDataSource calendarView:self weekdayCellsHeightForMonth:self.monthDates[section]] > 0;
    }
    return [self.dataSource calendarView:self weekdayCellsHeightForMonth:[self.monthDates[section] copy]] > 0;
}

-(BOOL)shouldShowMonthHeaderInSection:(NSInteger)section{
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(calendarView:monthHeaderViewHightForMonth:)]) {
        return [self.defaultDataSource calendarView:self monthHeaderViewHightForMonth:self.monthDates[section]] > 0;
    }
    return [self.dataSource calendarView:self monthHeaderViewHightForMonth:[self.monthDates[section] copy]] > 0;
}

-(BOOL)isItemInCurrentMonthAtIndexPath:(NSIndexPath*)indexPath{
    NSDate* monthDate = self.monthDates[indexPath.section];
    NSDate* date = [self dateForIndexPath:indexPath];
    
    NSDateComponents *components = [self.calendar components:NSMonthCalendarUnit
                                                    fromDate:date];
    NSDateComponents *monthComponents = [self.calendar components:NSMonthCalendarUnit
                                                         fromDate:monthDate];
    return monthComponents.month == components.month;
}

-(NSDate*)dateForIndexPath:(NSIndexPath*)indexPath{
    NSInteger section = indexPath.section;
    NSDate *monthDate = self.monthDates[section];
    NSDate *firstDateInMonth = [self firstVisibleDateOfMonth:monthDate];
    
    NSUInteger day = indexPath.item;
    if ([self shouldShowWeekdaysInSection:section]) {
        day -= self.daysInWeek;
    }
    NSDateComponents *components =
    [self.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                     fromDate:firstDateInMonth];
    components.day += day;
    
    return [self.calendar dateFromComponents:components];
}

-(CGPoint)monthTopPositionForSection:(NSInteger)section{
    
    NSIndexPath* firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    CGFloat offsetY = [self.collectionView layoutAttributesForItemAtIndexPath:firstIndexPath].frame.origin.y;
    offsetY -= [self heightForHeaderSection:section];
    
    CGFloat contentInsetY = self.collectionView.contentInset.top;
    CGFloat sectionInsetY = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).sectionInset.top;
    
    return CGPointMake(self.collectionView.contentOffset.x, offsetY - contentInsetY - sectionInsetY);
}

- (NSIndexPath *)indexPathForDate:(NSDate *)date;
{
    if (!date) {
        return nil;
    }
    
    NSInteger section = [self sectionForDate:date];
    
    NSDate *firstDateInMonth = [self firstVisibleDateOfMonth:date];
    NSDateComponents * components = [self.calendar components:NSDayCalendarUnit fromDate:firstDateInMonth toDate:date options:0];
    
    NSUInteger day = components.day;
    if ([self shouldShowWeekdaysInSection:section]) {
        day += self.daysInWeek;
    }
    
    return [NSIndexPath indexPathForRow:day inSection:section];
}

- (NSInteger)sectionForDate:(NSDate *)date;
{
    return [self.calendar components:NSMonthCalendarUnit fromDate:self.fromDate toDate:date options:0].month;
}

#pragma mark - UICollectionViewDelegate

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didDeselectItemAtIndexPath:)]) {
//        [self.delegate calendarView:self didDeselectItemAtIndexPath:indexPath];
//    }
//}
//
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item <= self.daysInWeek) {
//        return NO;
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:shouldSelectDate:forIndexPath:)]) {
//        MMCalendarViewCell* cell = (MMCalendarViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
//        if (!cell.enabled) {
//            return NO;
//        }
//        NSDate* date = [self dateForIndexPath:indexPath];
//        return [self.delegate calendarView:self shouldSelectDate:date forIndexPath:indexPath];
//    }
//    return YES;
//}
//
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSDate* date = [self dateForIndexPath:indexPath];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectDate:forIndexPath:)]) {
//        [self.delegate calendarView:self didSelectDate:date forIndexPath:indexPath];
//    }
//    [self.collectionView reloadData];
//}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section{
    if(![self shouldShowMonthHeaderInSection:section]){
        return CGSizeZero;
    }
    CGFloat width  = self.bounds.size.width;
    CGFloat height = [self heightForHeaderSection:section];
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width      = self.bounds.size.width;
    CGFloat itemWidth  = roundf(width / self.daysInWeek);
    CGFloat itemHeight = itemWidth;
    if ([self shouldShowWeekdaysInSection:indexPath.section] && indexPath.item < self.daysInWeek) {
        itemHeight = [self heightForWeekdayCellAtIndexPath:indexPath];
    }else{
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:dayCellHightForMonth:)]) {
            NSDate* month = self.monthDates[indexPath.section];
            itemHeight = [self.dataSource calendarView:self dayCellHightForMonth:[month copy]];
        }
    }
    NSUInteger weekday = indexPath.item % self.daysInWeek;
    
    if (weekday == self.daysInWeek - 1) {
        itemWidth = width - (itemWidth * (self.daysInWeek - 1));
    }
    
    return CGSizeMake(itemWidth, itemHeight);
}

-(CGFloat)heightForHeaderSection:(NSInteger)section{
    NSDate * month = self.monthDates[section];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:monthHeaderViewHightForMonth:)]) {
        return [self.dataSource calendarView:self monthHeaderViewHightForMonth:[month copy]];
    }
    return [self.defaultDataSource calendarView:self monthHeaderViewHightForMonth:month];
}


-(CGFloat)heightForWeekdayCellAtIndexPath:(NSIndexPath*)indexPath{
    NSDate * month = self.monthDates[indexPath.section];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(calendarView:weekdayCellsHeightForMonth:)]) {
        return [self.dataSource calendarView:self weekdayCellsHeightForMonth:[month copy]];
    }
    return [self.defaultDataSource calendarView:self weekdayCellsHeightForMonth:month];
}

- (void)invalidateLayout{
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Setters and getters

-(void)setSnapOnMonth:(BOOL)snapOnMonth{
    _snapOnMonth = snapOnMonth;
    ((MMCalendarViewLayout*)self.collectionView.collectionViewLayout).snapToContent = snapOnMonth;
}
-(void)setSnapMonthHeader:(BOOL)snapMonthHeader{
    _snapMonthHeader = snapMonthHeader;
    ((MMCalendarViewLayout*)self.collectionView.collectionViewLayout).snapHeader = snapMonthHeader;
}

-(NSUInteger)numberOfMonths{
    return [self.collectionView numberOfSections];
}

-(void)setAllowsSelection:(BOOL)allowsSelection{
    self.collectionView.allowsMultipleSelection = allowsSelection;
}
-(void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection{
    self.collectionView.allowsMultipleSelection = allowsMultipleSelection;
}
-(BOOL)allowsMultipleSelection{
    return self.collectionView.allowsMultipleSelection;
}
-(BOOL)allowsSelection{
    return self.collectionView.allowsSelection;
}

#pragma mark - Reusable

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)viewClass forMonthHeaderViewWithReuseIdentifier:(NSString *)identifier{
    [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forMonthHeaderViewWithReuseIdentifier:(NSString *)identifier{
    [self.collectionView registerNib:nil forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

-(id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

-(id)dequeueReusableMonthHeaderViewWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath{
    return [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
}

#pragma mark -  ScrollAndSelect

-(NSArray *)indexPathsForSelectedItems{
    return [self.collectionView indexPathsForSelectedItems];
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(MMCalendarViewScrollPosition)scrollPosition{
    if (self.snapOnMonth || scrollPosition == MMCalendarViewScrollPositionMonth) {
        CGPoint monthTopPosition = [self monthTopPositionForSection:indexPath.section];
        [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionNone];
        [self.collectionView setContentOffset:monthTopPosition animated:YES];
        return;
    }
    [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(MMCalendarViewScrollPosition)scrollPosition animated:(BOOL)animated{
    if (self.snapOnMonth || scrollPosition == MMCalendarViewScrollPositionMonth) {
        CGPoint monthTopPosition = [self monthTopPositionForSection:indexPath.section];
        [self.collectionView setContentOffset:monthTopPosition animated:YES];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:animated];
}

- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:animated];
}

- (void)scrollToDate:(NSDate *)date atScrollPosition:(MMCalendarViewScrollPosition)scrollPosition  animated:(BOOL)animated{
    NSIndexPath* indexPath = [self indexPathForDate:date];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}
- (void)selectDate:(NSDate *)date animated:(BOOL)animated scrollPosition:(MMCalendarViewScrollPosition)scrollPosition{
    NSIndexPath* indexPath = [self indexPathForDate:date];
    [self selectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}
- (void)deselectDate:(NSDate *)date animated:(BOOL)animated{
    NSIndexPath* indexPath = [self indexPathForDate:date];
    [self deselectItemAtIndexPath:indexPath animated:animated];
}


@end





