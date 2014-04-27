//
//  MMCalendarHeaderView.m
//  MMCalendarView
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import "MMCalendarHeaderView.h"

@interface MMCalendarHeaderView(){
    UILabel *_titleLabel;
}
@end

@implementation MMCalendarHeaderView


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
    [self addSubview:_titleLabel];
    return _titleLabel;
    
}

@end
