//
//  MMCalendarViewLayout.h
//  MMCalendarView
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved
//

#import <UIKit/UIKit.h>

@interface UICollectionViewLayout ()
-(void)setHeaderReferenceSize:(CGSize)newSize;
-(CGSize)headerReferenceSize;
@end

@interface MMCalendarViewLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) BOOL snapToContent;
@property (nonatomic, assign) BOOL snapHeader;

@end
