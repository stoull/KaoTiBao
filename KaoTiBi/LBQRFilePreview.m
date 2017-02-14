//
//  LBQRFilePreview.m
//  LinkPortal
//
//  Created by Stoull Hut on 10/3/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "LBQRFilePreview.h"
#import "Masonry.h"
@interface LBQRFilePreview () <UIWebViewDelegate>
@property (strong, nonatomic)  UIWebView *QRPreview;

//@property (nonatomic, strong) UILabel *fileUrlLable;
@end

@implementation LBQRFilePreview

-(UIWebView *)QRPreview{
    if (!_QRPreview) {
        _QRPreview = [[UIWebView alloc] init];
        [self.view addSubview:_QRPreview];
        self.QRPreview.delegate = self;
    }
    return _QRPreview;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadQRPreview];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    self.fileUrlLable = [[UILabel alloc] initWithFrame:CGRectMake(0, screenSize.height - 44, screenSize.width, 44)];
//    self.fileUrlLable.numberOfLines = 4;
//    self.fileUrlLable.text = self.fileUrl;
//    self.fileUrlLable.font = [UIFont systemFontOfSize:12];
//    self.fileUrlLable.textColor = [UIColor whiteColor];
//    [self.view addSubview:self.fileUrlLable];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"bank"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToRootController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}

- (void)backToRootController:(UIButton *)itemBtn{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)loadQRPreview{
    NSURL *url = [NSURL URLWithString:self.fileUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.QRPreview loadRequest:request];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.QRPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
    
//    [self.fileUrlLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(@(0));
//        make.height.equalTo(@(44));
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
