//
//  LBFileIconCell.h
//  LinkPortal
//
//  Created by linkapp on 16/01/2017.
//  Copyright © 2017 linkapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBFileIconCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic, assign) BOOL isShowHintView;
@end
