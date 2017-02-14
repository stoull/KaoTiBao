//
//  LBAlert.h
//  LinkPortal
//
//  Created by Stoull Hut on 9/3/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBAlert : UIAlertController

+ (UIAlertController *)showAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                          completionBlock:(void (^)(NSUInteger actionIndex, UIAlertAction *alertAction))block
                        cancelActionTitle:(NSString *)cancelActionTitle
                        otherActionTitles:(NSArray *)otherActionTitle;
@end
