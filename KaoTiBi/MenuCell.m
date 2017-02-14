//
//  MenuCell.m
//  CCSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MenuCell.h"
@interface MenuCell()

@end

@implementation MenuCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.lable.textColor = kThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
