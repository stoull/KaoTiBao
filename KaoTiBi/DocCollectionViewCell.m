//
//  DocCollectionViewCell.m
//  KaoTiBi
//
//  Created by Stoull Hut on 13/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "DocCollectionViewCell.h"
#import "UIImage+ChangeSize.h"

@interface DocCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DocCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItemWidth:(CGFloat)itemWidth{
    _itemWidth = itemWidth;
}

-(void)setDocument:(Document *)document{
    if (document != nil) {
        _document = document;
        NSString *docPath = [DocumentMgr getDocumentPathWithDocment:document];
        UIImage *lagerImage = [UIImage imageWithContentsOfFile:docPath];
        UIImage *smallImage = [UIImage imageCompressForWidth:lagerImage targetWidth:self.itemWidth * 2];
        [self.imageView setImage:smallImage];
    }
}

@end
