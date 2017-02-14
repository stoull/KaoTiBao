//
//  DocManagerCell.m
//  KaoTiBi
//
//  Created by linkapp on 03/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocManagerCell.h"
#import "NSString+comparaCurrentTime.h"

@interface DocManagerCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation DocManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTitle:(NSString *)title{
    self.nameLabel.text = title;
}

- (IBAction)didClickOpenButton:(UIButton *)button {
    [button setSelected:!button.isSelected];
    if ([self.delegate respondsToSelector:@selector(docManagerCell:trangleDidChangeState:)]) {
        [self.delegate docManagerCell:self trangleDidChangeState:button.isSelected];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
