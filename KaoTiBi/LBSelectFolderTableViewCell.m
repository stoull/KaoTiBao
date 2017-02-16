//
//  LBSelectFolderTableViewCell.m
//  LinkPortal
//
//  Created by linkapp on 14/02/2017.
//  Copyright © 2017 linkapp. All rights reserved.
//


#import "LBSelectFolderTableViewCell.h"
@interface LBSelectFolderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *fileIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@end

@implementation LBSelectFolderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFolderName:(NSString *)folderName{
    if (folderName) {
        _folderName = folderName;
        self.fileNameLabel.text = folderName;
    }
}

@end
