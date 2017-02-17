//
//  KTBPopInputView.m
//  KaoTiBi
//
//  Created by linkapp on 17/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "KTBPopInputView.h"
#import "InputDoneView.h"
#import "HUD.h"

@interface  KTBPopInputView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (nonatomic, strong) InputDoneView *inputDoneView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonContentView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
@property (weak, nonatomic) IBOutlet UIView *inpuBgView;

@property (nonatomic, assign) BOOL isNeedClearTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeightConstrant;
@end

@implementation KTBPopInputView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.isNeedClearTextView = YES;
    self.inputTextView.delegate = self;
    self.headerBgView.backgroundColor = kThemeColor;
    self.inputTextView.layer.cornerRadius = 5.0;
    self.inpuBgView.backgroundColor = kThemeColor;
    [self.cancelButton setBackgroundColor:kThemeColor];
    [self.confirmButton setBackgroundColor:kThemeColor];
    self.buttonContentView.layer.cornerRadius = 10;
    self.headerBgView.layer.cornerRadius = 10.0;
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(baViewDidTap:)];
    [self addGestureRecognizer:tap];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

-(void)setInputText:(NSString *)inputText{
    if (inputText) {
        _inputText = inputText;
        self.inputTextView.text = inputText;
    }
}

-(void)setInputViewHeight:(NSInteger)inputViewHeight{
    _inputViewHeight = inputViewHeight;
    self.inputViewHeightConstrant.constant = _inputViewHeight;
}

-(void)setMaxInputCount:(NSInteger)maxInputCount{
    _maxInputCount = maxInputCount;
}

-(void)setPlaceHoldText:(NSString *)placeHoldText{
    _placeHoldText = placeHoldText;
    NSString *placeString;
    if (self.maxInputCount == 0) {
        self.maxInputCount = 100;
        placeString = [NSString stringWithFormat:@"%@(最多%ld个字符!)",placeHoldText,self.maxInputCount];
    }else{
        placeString = [NSString stringWithFormat:@"%@(最多%ld个字符!)",placeHoldText,self.maxInputCount];
    }
    self.inputTextView.text = placeString;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.isNeedClearTextView) {
        self.inputTextView.textColor = [UIColor blackColor];
        self.inputTextView.text = @"";
        self.isNeedClearTextView = NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(popInputViewDidBeginEditing)]) {
        [self.delegate popInputViewDidBeginEditing];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    _inputText = self.inputTextView.text;
    if ([self.delegate respondsToSelector:@selector(popInputViewDidEndEditing)]) {
        [self.delegate popInputViewDidEndEditing];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length > self.maxInputCount && text.length > 0) {
        NSString *titleStr;
        if (self.maxInputCount == 0) {
            self.maxInputCount = 100;
            titleStr =  [NSString stringWithFormat:@"审核意见最多为 %ld 个字符哦",self.maxInputCount];
        }else{
            titleStr =  [NSString stringWithFormat:@"审核意见最多为 %ld 个字符哦",self.maxInputCount];
        }
        [[HUD shareHUD] hintMessage:titleStr];
        //        self.inputTextView.text = [text substringToIndex:range.length - 1];
        return NO;
    }
    _inputText = text;
    return YES;
}

- (IBAction)cancelInput:(id)sender {
    [self viewHidden];
    if ([self.delegate respondsToSelector:@selector(cancelButtonDidClickWithInputString:)]) {
        [self.delegate cancelButtonDidClickWithInputString:_inputText];
    }
}
- (IBAction)confirmInput:(id)sender {
    [self viewHidden];
    if ([self.delegate respondsToSelector:@selector(confirmButtondidClickWithInputString:)]) {
        [self.delegate confirmButtondidClickWithInputString:_inputText];
    }
}

-(InputDoneView *)inputDoneView{
    if (!_inputDoneView) {
        _inputDoneView = [[InputDoneView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        __block UIView *blockView = self;
        _inputDoneView.inputDoneClickBlock = ^(void){
            [blockView endEditing:YES];
        };
    }
    return _inputDoneView;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [self.inputDoneView showWithKeyboardShowNotification:aNotification];
    
    self.centerConstrait.constant = -90;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [self.inputDoneView hideWithKeyboardHideNotification:aNotification];
    self.centerConstrait.constant = -40;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
    self.headerBgView.alpha = 0.0;
    self.inputTextView.alpha = 0.0;
    self.inpuBgView.alpha = 0.0;
    self.buttonContentView.alpha = 0.0;
    [UIView animateWithDuration:0.15 animations:^{
        self.headerBgView.alpha = 1.0;
        self.inputTextView.alpha = 1.0;
        self.inpuBgView.alpha = 1.0;
        self.buttonContentView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.inputTextView becomeFirstResponder];
    }];
}

- (void)viewHidden{
    [UIView animateWithDuration:0.15 animations:^{
        self.headerBgView.alpha = 0.0;
        self.inputTextView.alpha = 0.0;
        self.inpuBgView.alpha = 0.0;
        self.buttonContentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.inputTextView resignFirstResponder];
        [self removeFromSuperview];
    }];
}

- (void)baViewDidTap:(UITapGestureRecognizer *)tap{
//    [self viewHidden];
    [self.inputTextView resignFirstResponder];
}

@end
