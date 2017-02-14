//
//  DocumentCellTableViewCell.m
//  KaoTiBi
//
//  Created by linkapp on 05/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocumentCellTableViewCell.h"
#import "UIImage+ChangeSize.h"
#import "KTDefine.h"
@interface DocumentCellTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *docImageView;
@property (weak, nonatomic) IBOutlet UILabel *docNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;

@end

@implementation DocumentCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.docNameLabel.text = self.document.name;
}

-(void)setDocument:(Document *)document{
    _document = document;
    self.docNameLabel.text = document.name;
    NSString *docPath = [kPathDocument stringByAppendingPathComponent:document.path];
    docPath = [docPath stringByAppendingPathComponent:document.dateName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:docPath];
    self.docImageView.image = [UIImage imageCompressForSize:image targetSize:CGSizeMake(240, 240)];
}

-(void)setDocuments:(NSArray *)documents{
    if (documents == nil || documents.count == 0) {
        return;
    }
    _documents = documents;
    Document *document = [documents firstObject];
    self.docNameLabel.text = document.identifierDay;
    NSString *docPath = [kPathDocument stringByAppendingPathComponent:document.path];
    docPath = [docPath stringByAppendingPathComponent:document.dateName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:docPath];
    
    self.docImageView.image = [UIImage imageCompressForSize:image targetSize:CGSizeMake(240, 240)];
}

-(void)setType:(DocumentCellType)type{
    if (type == DocumentCellTypeCell) {
        self.groupImageView.hidden = YES;
    }else{
        self.groupImageView.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
