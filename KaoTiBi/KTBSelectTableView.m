//
//  KTBSelectTableView.m
//  KaoTiBi
//
//  Created by linkapp on 17/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "KTBSelectTableView.h"
#import "InputDoneView.h"
#import "LBSelectFolderTableViewCell.h"

@interface KTBSelectTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) InputDoneView *inputDoneView;
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
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

#define kLBSelectFolderControllerIdentifier @"kLBSelectFolderControllerIdentifier"

@implementation KTBSelectTableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.isNeedClearTextView = YES;
    self.headerBgView.backgroundColor = kThemeColor;
    self.inpuBgView.backgroundColor = kThemeColor;
    [self.cancelButton setBackgroundColor:kThemeColor];
    [self.confirmButton setBackgroundColor:kThemeColor];
    self.buttonContentView.layer.cornerRadius = 10;
    self.headerBgView.layer.cornerRadius = 10.0;
    self.selectTableView.layer.cornerRadius = 5.0;
    
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    
    [self.selectTableView setEditing:YES];
    [self.selectTableView registerNib:[UINib nibWithNibName:@"LBSelectFolderTableViewCell" bundle:nil] forCellReuseIdentifier:kLBSelectFolderControllerIdentifier];
    
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
}

-(void)didMoveToWindow{
    [self.selectTableView reloadData];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}


- (IBAction)cancelInput:(id)sender {
    [self viewHidden];
    if ([self.delegate respondsToSelector:@selector(cancelButtonDidClick)]) {
        [self.delegate cancelButtonDidClick];
    }
}

- (IBAction)confirmInput:(id)sender {
    [self viewHidden];
    if ([self.delegate respondsToSelector:@selector(confirmButtondidClickWithTitle:andIndex:)]) {
        NSIndexPath *indepx = [[self.selectTableView indexPathsForVisibleRows] lastObject];
        NSString *title = self.folderArray[indepx.row];
        [self.delegate confirmButtondidClickWithTitle:title andIndex:indepx.row];
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
    self.inpuBgView.alpha = 0.0;
    self.buttonContentView.alpha = 0.0;
    [UIView animateWithDuration:0.15 animations:^{
        self.headerBgView.alpha = 1.0;
        self.inpuBgView.alpha = 1.0;
        self.buttonContentView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)viewHidden{
    [UIView animateWithDuration:0.15 animations:^{
        self.headerBgView.alpha = 0.0;
        self.inpuBgView.alpha = 0.0;
        self.buttonContentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//- (void)baViewDidTap:(UITapGestureRecognizer *)tap{
//   
//}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.folderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBSelectFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLBSelectFolderControllerIdentifier forIndexPath:indexPath];
    NSString *folderName = self.folderArray[indexPath.row];
    cell.folderName = folderName;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *selectIndexPath = [tableView indexPathsForSelectedRows];
    for (NSIndexPath *innPaht in selectIndexPath){
        if (innPaht != indexPath) {
            LBSelectFolderTableViewCell *cell = [tableView cellForRowAtIndexPath:innPaht];
            [cell setSelected:NO];
        }
    }
}

@end
