//
//  KTBPopInputView.h
//  KaoTiBi
//
//  Created by linkapp on 17/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTBPopInputViewDelegate <NSObject>
@optional
- (void)cancelButtonDidClickWithInputString:(NSString *)inpuString;
- (void)confirmButtondidClickWithInputString:(NSString *)inpuString;

- (void)popInputViewDidBeginEditing;
- (void)popInputViewDidEndEditing;
@end

@interface KTBPopInputView : UIView
@property (nonatomic, weak) id<KTBPopInputViewDelegate> delegate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeHoldText;
@property (nonatomic, assign) NSInteger maxInputCount;
@property (nonatomic, copy) NSString *inputText;
@property (nonatomic, assign) NSInteger inputViewHeight;

- (void)showInView:(UIView *)view;
@end
