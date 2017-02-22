//
//  AboutViewController.m
//  KaoTiBi
//
//  Created by Stoull Hut on 18/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "AboutViewController.h"
#import "KTBBaseAPI.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *describleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutBiLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"", @"关于考题笔");
    [self getSysTemInfor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSysTemInfor{
    [self.activityView startAnimating];
    [KTBBaseAPI getSystemInfoSuccessful:^(kTBAPIResponseStatus status, NSString * _Nullable emsg, NSDictionary * _Nullable resDic) {
        [self.activityView stopAnimating];
        if (status == kTBAPIResponseStatusSuccessful) {
            self.describleLabel.text = resDic[@"appDesc"];
            self.aboutBiLabel.text = resDic[@"penDesc"];
            self.contactLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Setting.phone", @"手机："),resDic[@"mgrPhone"]];
            self.emailLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Setting.email", @"邮箱："),resDic[@"email"]];
        }else{
            
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        [self.activityView stopAnimating];
    }];
}

-(UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _activityView.center = self.navigationController.view.center;
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityView.hidesWhenStopped = YES;
        [self.navigationController.view addSubview:_activityView];
    }
    return _activityView;
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
