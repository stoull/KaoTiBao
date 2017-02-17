//
//  InputDoneView.h
//  LinkPortal
//
//  Created by linkapp on 11/21/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSingleton.h"

@interface InputDoneView : UIView
@property (nonatomic, strong) void (^inputDoneClickBlock)(void);

- (void)showWithKeyboardShowNotification:(NSNotification *)aNotification;
- (void)hideWithKeyboardHideNotification:(NSNotification *)aNotification;
@end
