//
//  KTBSelectTableView.h
//  KaoTiBi
//
//  Created by linkapp on 17/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTBSelectTableViewDelegate <NSObject>
@optional
- (void)cancelButtonDidClick;
- (void)confirmButtondidClickWithTitle:(NSString *)title andIndex:(NSInteger)index;
@end

@interface KTBSelectTableView : UIView
@property (nonatomic, weak) id<KTBSelectTableViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *folderArray;

- (void)showInView:(UIView *)view;
@end
