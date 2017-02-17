//
//  LBSelectFolderController.h
//  LinkPortal
//
//  Created by linkapp on 14/02/2017.
//  Copyright © 2017 linkapp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LBSelectFloderControllerDelegate <NSObject>
- (void)successfullMoveDocumentsWithSelectedIndexPath:(NSArray *)selectedIndexPath;
@end
@interface LBSelectFolderController : UITableViewController
@property (nonatomic, weak) id<LBSelectFloderControllerDelegate> delegate;
@property (nonatomic, copy) NSString *oldFolderName;
@property (nonatomic, strong) NSArray *documets;
@property (nonatomic, strong) NSArray *selectedIndexPath;
@end
