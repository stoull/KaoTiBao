//
//  InputDoneView.m
//  LinkPortal
//
//  Created by linkapp on 11/21/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "InputDoneView.h"
#import "Masonry.h"

#define keyBoardHeight 30

@interface InputDoneView()
@property (strong, nonatomic) UIButton *inputDoneButton;

@property (nonatomic, strong) UIButton *upItemButton;
@property (nonatomic, strong) UIButton *nextItemButton;

@end

@implementation InputDoneView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackgroundShallowColor;
    }
    return self;
}

- (void)showWithKeyboardShowNotification:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 获取当前keyWindow
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect mainScreenRect = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, mainScreenRect.size.height, keyboardRect.size.width, 0);
    if (_inputDoneButton == nil) {
        _inputDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenRect.size.width - 55,0, 48, 30)];
        [_inputDoneButton setTitle:NSLocalizedString(@"Done", @"完成") forState:UIControlStateNormal];
        _inputDoneButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_inputDoneButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        [_inputDoneButton addTarget:self action:@selector(inputDoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_inputDoneButton];
    }
    
    if (_upItemButton == nil) {
        _upItemButton = [[UIButton alloc] initWithFrame:CGRectMake(5,0, 30, 30)];
        [_upItemButton setImage:[UIImage imageNamed:@"input_upItem"] forState:UIControlStateNormal];
        [_upItemButton addTarget:self action:@selector(upItem) forControlEvents:UIControlEventTouchUpInside];
        _upItemButton.enabled = NO;
        [self addSubview:_upItemButton];
    }
    
    if (_nextItemButton == nil) {
        _nextItemButton = [[UIButton alloc] initWithFrame:CGRectMake(40,0, 30, 30)];
        [_nextItemButton setImage:[UIImage imageNamed:@"input_nextItem"] forState:UIControlStateNormal];
        [_nextItemButton addTarget:self action:@selector(nextItem) forControlEvents:UIControlEventTouchUpInside];
        _nextItemButton.enabled = NO;
        [self addSubview:_nextItemButton];
    }
    [keyWindow addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 1.0;
        self.frame = CGRectMake(keyboardRect.origin.x, keyboardRect.origin.y - keyBoardHeight, keyboardRect.size.width, keyBoardHeight);
    } completion:^(BOOL finished) {
    }];
}

- (void)hideWithKeyboardHideNotification:(NSNotification *)aNotification{
    if (aNotification == nil) {
        [self removeFromSuperview];
        return;
    }
    // 获取通知信息字典
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGRect mainScreenRect = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = CGRectMake(0, mainScreenRect.size.height + keyBoardHeight, keyboardRect.size.width, keyBoardHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)inputDoneButtonClick:(id)sender {
    if (self.inputDoneClickBlock) {
        self.inputDoneClickBlock();
    }
}

- (void)nextItem{
    
}

- (void)upItem{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
