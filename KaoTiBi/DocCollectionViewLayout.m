//
//  DocCollectionViewLayout.m
//  KaoTiBi
//
//  Created by Stoull Hut on 14/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocCollectionViewLayout.h"

@implementation DocCollectionViewLayout
- (instancetype)init{
    if (self = [super init]) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        //最小行间距(默认为10)
        self.minimumLineSpacing = kDocItemMinLineSpacing;
        //最小item间距（默认为10）
        self.minimumInteritemSpacing = kDcoItemMinInteritemSpacing;
        CGFloat width = (screenSize.width - (kDocRow + 1) * kDocLeftMagin) / kDocRow;
        self.itemSize = CGSizeMake(width, width);
        
        //设置senction的内边距
        self.sectionInset = UIEdgeInsetsMake(kDocLeftMagin, kDocLeftMagin, kDocLeftMagin, kDocLeftMagin);
        
        //设置UICollectionView的滑动方向
        //        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        //sectionHeader的大小,如果是竖向滚动，只需设置Y值。如果是横向，只需设置X值。
        //        self.headerReferenceSize = CGSizeMake(100,0);
        
    }
    return self;
}

@end
