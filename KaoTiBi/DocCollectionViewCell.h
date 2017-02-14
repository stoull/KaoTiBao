//
//  DocCollectionViewCell.h
//  KaoTiBi
//
//  Created by Stoull Hut on 13/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentMgr.h"

@interface DocCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) Document *document;
@property (nonatomic, assign) CGFloat itemWidth;
@end
