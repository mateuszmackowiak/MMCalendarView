//
//  Created by Mateusz Mackowiak on 25.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved.
//

#import "CustomCalendarViewCell.h"


NSString *const CustomCalendarViewCellIdentifier = @"CustomCalendarViewCellIdentifier";

@interface CustomCalendarViewCell (){
    UILabel* _titleLabel;
}

@end

@implementation CustomCalendarViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.389 green:0.574 blue:0.883 alpha:1.000];
        
        CGFloat pixelSize = 1.f / UIScreen.mainScreen.scale;
        self.layer.borderWidth = pixelSize;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return self;
}


-(UILabel *)titleLabel{
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor darkTextColor];
    _titleLabel.highlightedTextColor = [UIColor whiteColor];
    _titleLabel.userInteractionEnabled = NO;
    [self.contentView addSubview:_titleLabel];
    return _titleLabel;
    
}

-(void)setSelected:(BOOL)selected{
    if (self.enabled) {
        [super setSelected:selected];
    }else if(self.selected){
        [super setSelected:NO];
    }
}
@end
