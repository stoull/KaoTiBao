//
//  LBHomeViewLayout.m
//  LinkPortal
//
//  Created by linkapp on 13/02/2017.
//  Copyright © 2017 linkapp. All rights reserved.
//

#import "DocMgrCellFooterLayout.h"

@implementation DocMgrCellFooterLayout
- (void)prepareLayout {
    [super prepareLayout];
    
}

- (instancetype)init{
    if (self = [super init]) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;

        //最小行间距(默认为10)
        self.minimumLineSpacing = kItemMinLineSpacing;
        //最小item间距（默认为10）
        self.minimumInteritemSpacing = kItemMinInteritemSpacing;
        CGFloat width = (screenSize.width - (kRow + 1) * kLeftMagin) / kRow;
        self.itemSize = CGSizeMake(width, width);
        
        //设置senction的内边距
        self.sectionInset = UIEdgeInsetsMake(kLeftMagin, kLeftMagin, kLeftMagin, kLeftMagin);
        
        //设置UICollectionView的滑动方向
//        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        //sectionHeader的大小,如果是竖向滚动，只需设置Y值。如果是横向，只需设置X值。
//        self.headerReferenceSize = CGSizeMake(100,0);
        
    }
    return self;
}

//
//- (void)layoutItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//
//// 系统方法，获取当前可视界面显示的UICollectionViewLayoutAttributes数组
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    // 把能显示在当前可视界面的所有对象加入在indexPaths 中
//    NSMutableArray *indexPaths = [NSMutableArray array];
//    for (NSString *rectStr in _attributes) {
//        CGRect cellRect = CGRectFromString(rectStr);
//        if (CGRectIntersectsRect(cellRect, rect)) {
//            NSIndexPath *indexPath = _attributes[rectStr];
//            [indexPaths addObject:indexPath];
//        }
//    }
//    
//    // 返回更新对应的UICollectionViewLayoutAttributes数组
//    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:indexPaths.count];
//    for(NSInteger i=0 ; i < self.collectionView.numberOfSections; i++) {
//        for (NSInteger j=0 ; j < [self.collectionView numberOfItemsInSection:i]; j++) {
//            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:j inSection:i];
//            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//        }
//    }
//    
//    
//    return attributes;
//}
//
//// 更新对应UICollectionViewLayoutAttributes的frame
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    
//    for (NSString *frame in _attributes) {
//        if (_attributes[frame] == indexPath) {
//            attributes.frame = CGRectFromString(frame);
//        }
//    }
//    
//    return attributes;
//}
//
//- (CGSize)collectionViewContentSize {
//    
//    return size;
//}

@end
