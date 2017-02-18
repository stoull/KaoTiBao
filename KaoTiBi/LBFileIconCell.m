//
//  LBFileIconCell.m
//  LinkPortal
//
//  Created by linkapp on 16/01/2017.
//  Copyright © 2017 linkapp. All rights reserved.
//

#import "LBFileIconCell.h"
@interface LBFileIconCell()
@property (weak, nonatomic) IBOutlet UIImageView *hintImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstrant;

@end

@implementation LBFileIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (self.isShowHintView) {
        self.titleName.textColor = kTabelViewTextDarkColor;
        self.valueLabel.textColor = kTabelViewTextColor;
        self.titleConstrant.constant = 80;
    }else{
        self.titleConstrant.constant = 220;
    }

}

-(void)setIsShowHintView:(BOOL)isShowHintView{
    _isShowHintView = isShowHintView;
    self.hintImageView.hidden = isShowHintView;
    if (isShowHintView) {
        self.titleName.textColor = kTabelViewTextDarkColor;
        self.valueLabel.textColor = kTabelViewTextColor;
        self.titleConstrant.constant = 80;
    }else{
        self.titleConstrant.constant = 220;
        self.titleName.textColor = [UIColor blackColor];
        self.valueLabel.textColor = [UIColor blackColor];
    }
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
