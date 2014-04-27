//
//  MMCalendarViewCell.h
//  MMCalendarView
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCalendarViewCell : UICollectionViewCell

@property(nonatomic,assign,getter = isEnabled) BOOL enabled;

@property(nonatomic,strong,readonly) UILabel *titleLabel;

@end
