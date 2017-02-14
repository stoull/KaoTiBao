//
//  DocManagerCellFooterView.h
//  KaoTiBi
//
//  Created by linkapp on 13/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Document;
@protocol DocManagerCellFooterViewDelegate <NSObject>

- (void)didSelectedSectionIndex:(NSInteger)section withDocment:(Document *)doc;

@end

@interface DocManagerCellFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<DocManagerCellFooterViewDelegate> delegate;

@property (nonatomic, strong) NSArray *documents;
@property (nonatomic, assign) NSInteger indexSection;
@end
