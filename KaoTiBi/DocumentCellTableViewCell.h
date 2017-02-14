//
//  DocumentCellTableViewCell.h
//  KaoTiBi
//
//  Created by linkapp on 05/01/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"

typedef enum: NSInteger {
    DocumentCellTypeGroup = 0,
    DocumentCellTypeCell
}DocumentCellType;

@interface DocumentCellTableViewCell : UITableViewCell
@property (nonatomic, strong) Document *document;

@property (nonatomic, assign) DocumentCellType type;
@property (nonatomic, strong) NSArray *documents;
@end
