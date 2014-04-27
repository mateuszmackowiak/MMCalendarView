//
//  MMCalendarViewLayout.m
//  MMCalendarView
//
//  Created by Mateusz Mackowiak on 22.04.2014.
//  Copyright (c) 2014 Mateusz Maćkowiak. All rights reserved
//

#import "MMCalendarViewLayout.h"

@implementation MMCalendarViewLayout

- (id)init {
    if (self = [super init]) {
        self.sectionInset = UIEdgeInsetsZero;
        self.minimumInteritemSpacing = 0.f;
        self.minimumLineSpacing = 0.f;
        self.headerReferenceSize = CGSizeZero;
        self.footerReferenceSize = CGSizeZero;
    }
    return self;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    if (!self.snapToContent) {
        return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
    NSArray *array =
    [super layoutAttributesForElementsInRect:({
        CGRect bounds = self.collectionView.bounds;
        bounds.origin.y = proposedContentOffset.y - self.collectionView.bounds.size.height/2.f;
        bounds.size.width *= 1.5f;
        bounds;
    })];
    
    __block CGFloat minOffsetY = CGFLOAT_MAX;
    __block UICollectionViewLayoutAttributes *targetLayoutAttributes = nil;
    
    [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *layoutAttributes, NSUInteger idx, BOOL *stop) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            CGFloat offsetY = fabs(layoutAttributes.frame.origin.y - proposedContentOffset.y);
            
            if (offsetY < minOffsetY) {
                minOffsetY = offsetY;
                
                targetLayoutAttributes = layoutAttributes;
                stop = NO;
            }
        }
    }];
    
    if (targetLayoutAttributes) {
        return targetLayoutAttributes.frame.origin;
    }
    
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y);
}


- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.snapHeader) {
        return [super layoutAttributesForElementsInRect:rect];
    }
    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (NSUInteger idx=0; idx<[answer count]; idx++) {
        UICollectionViewLayoutAttributes *layoutAttributes = answer[idx];
        
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];  // remember that we need to layout header for this section
        }
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [answer removeObjectAtIndex:idx];  // remove layout of header done by our super, we will do it right later
            idx--;
        }
    }
    
    // layout all headers needed for the rect using self code
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if(layoutAttributes){
            [answer addObject:layoutAttributes];
        }
    }];
    
    return answer;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (!self.snapHeader || ![kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    }
    UICollectionView * const cv = self.collectionView;
    BOOL canCheckHeaderHight = [cv.delegate  respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)];
    if (canCheckHeaderHight) {
        if ([((id<UICollectionViewDelegateFlowLayout>)cv.delegate) collectionView:cv layout:self referenceSizeForHeaderInSection:indexPath.section].height<=0){
            return nil;
        }
    }
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    CGPoint const contentOffset = cv.contentOffset;
    CGPoint nextHeaderOrigin = CGPointMake(INFINITY, INFINITY);
    
    if (indexPath.section+1 < [cv numberOfSections]) {
        NSIndexPath* nextIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section+1];
        if (canCheckHeaderHight && [((id<UICollectionViewDelegateFlowLayout>)cv.delegate) collectionView:cv layout:self referenceSizeForHeaderInSection:nextIndexPath.section].height<=0) {
            UICollectionViewLayoutAttributes *nextHeaderAttributes = [super layoutAttributesForItemAtIndexPath:nextIndexPath];
            nextHeaderOrigin = nextHeaderAttributes.frame.origin;
        }else{
            UICollectionViewLayoutAttributes *nextHeaderAttributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:nextIndexPath];
            nextHeaderOrigin = nextHeaderAttributes.frame.origin;
        }
    }
    CGRect frame = attributes.frame;
    frame.origin.y = MIN(MAX(contentOffset.y, frame.origin.y), nextHeaderOrigin.y - CGRectGetHeight(frame));
    attributes.zIndex = 1024;
    attributes.frame = frame;
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (!self.snapHeader) {
        return [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (!self.snapHeader) {
        return [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    return attributes;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

@end
