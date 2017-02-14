//
//  KTBSortView.m
//  KaoTiBi
//
//  Created by Stoull Hut on 24/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#define kSortViewWidth  66
#define kTopOffset 4
#define kRightOffset 4
#define kItemHight 44
#define kItemOffset 4

#import "KTBSortView.h"
@interface KTBSortView()

@end

@implementation KTBSortView

-(void)setTitles:(NSArray *)titles{
    if (titles == nil) {
        return;
    }
    _titles = titles;
    if (_titles.count > 0) {
        [self setViewWithTitles:titles];
    }
}

- (void)setViewWithTitles:(NSArray *)titles{
    CGFloat viewHight = titles.count * kItemHight + 2 * kTopOffset;
    CGFloat viewWidth = kSortViewWidth + kRightOffset * 2;
    self.bounds = CGRectMake(0, 0, viewWidth, viewHight);
    int index = 0;
    for (NSString *title in titles){
        CGFloat itemY = kTopOffset + index *(kItemHight + kItemOffset);
        CGFloat itemWidth = kSortViewWidth - 2 * kRightOffset;
        UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(kRightOffset, itemY, itemWidth, kItemHight)];
        itemButton.tag = index;
        [itemButton setTitle:title forState:UIControlStateNormal];
        [itemButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [itemButton addTarget:self action:@selector(itemButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)itemButtonDidClick:(UIButton *)button{
    NSInteger index = button.tag;
    NSString *title = button.titleLabel.text;
    if ([self.delegate respondsToSelector:@selector(KTBSortViewDidSelectItemIndex:title:)]) {
        [self.delegate KTBSortViewDidSelectItemIndex:index title:title];
    }
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
