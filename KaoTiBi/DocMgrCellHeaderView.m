//
//  DocMgrCellHeaderLayout.m
//  KaoTiBi
//
//  Created by Stoull Hut on 13/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocMgrCellHeaderView.h"
#import "DocManagerCell.h"
@interface DocMgrCellHeaderView()
@property (nonatomic, strong) DocManagerCell *cell;
@end

@implementation DocMgrCellHeaderView

- (void)setupCell{
    if (_cell == nil) {
        _cell = [[[NSBundle mainBundle] loadNibNamed:@"DocManagerCell" owner:self options:nil] firstObject];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _cell.frame = CGRectMake(0, 0, screenSize.width, kCellHeaderViewHeight);
        [self.contentView addSubview:_cell];
    }
    _cell.title = self.title;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    [self setupCell];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
