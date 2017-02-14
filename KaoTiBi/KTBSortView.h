//
//  KTBSortView.h
//  KaoTiBi
//
//  Created by Stoull Hut on 24/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KTBSortViewDelegate <NSObject>
- (void)KTBSortViewDidSelectItemIndex:(NSInteger)index title:(NSString *)title;
@end
@interface KTBSortView : UIView
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, weak) id<KTBSortViewDelegate> delegate;
@end
