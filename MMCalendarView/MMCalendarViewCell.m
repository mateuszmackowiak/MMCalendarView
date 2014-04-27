//
//  MMCalendarViewCell.m
//  MMCalendarView
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import "MMCalendarViewCell.h"


@interface MMCalendarViewCell(){
    UILabel* _titleLabel;
}

@end

@implementation MMCalendarViewCell


-(void)setTitleLabel:(UILabel *)titleLabel{
    _titleLabel = titleLabel;
}

-(UILabel *)titleLabel{
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.userInteractionEnabled = NO;
    [self.contentView addSubview:_titleLabel];
    return _titleLabel;
    
}


@end
