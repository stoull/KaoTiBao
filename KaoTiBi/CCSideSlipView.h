//
//  CCSideSlipView.h
//  CCSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCSideSlipView : UIView <UIGestureRecognizerDelegate>
{
    BOOL isOpen;
    UITapGestureRecognizer *_tap;
    UISwipeGestureRecognizer *_leftSwipe, *_rightSwipe;
    UITapGestureRecognizer *_tapGest;
    UIImageView *_blurImageView;
    UIImageView *_blurImageBackView;
    UIViewController *_sender;
    UIView *_contentView;
}
- (instancetype)initWithSender:(UIViewController*)sender;
-(void)show;
-(void)hide;
-(void)switchMenu;
-(void)setContentView:(UIView*)contentView;

@end

