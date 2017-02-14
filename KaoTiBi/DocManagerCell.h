//
//  DocManagerCell.h
//  KaoTiBi
//
//  Created by linkapp on 03/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocRecord.h"
@class DocManagerCell;

@protocol DocManagerCellDelegate <NSObject>

- (void)docManagerCell:(DocManagerCell *)cell trangleDidChangeState:(BOOL)isOpen;

@end

@interface DocManagerCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, weak) id<DocManagerCellDelegate>delegate;
@property (nonatomic, strong) DocRecord *record;

@end
