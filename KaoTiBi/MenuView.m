//
//  MenuView.m
//  CCSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MenuView.h"
#import "MenuCell.h"
#import "KTDefine.h"

@implementation MenuView
+(instancetype)menuView
{
    MenuView *result = nil;

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    for (id object in nibView)
    {
        if ([object isKindOfClass:[self class]])
        {
            result = object;
            break;
        }
    }
    return result;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)didSelectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didSelectRowAtIndexPath{
    _didSelectRowAtIndexPath = [didSelectRowAtIndexPath copy];
}
-(void)setItems:(NSArray *)items{
    _items = items;
}


#pragma -mark tableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_didSelectRowAtIndexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        _didSelectRowAtIndexPath(cell,indexPath);
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setInteger:(KTBDocManagerType)indexPath.row forKey:kKTBDocManagerType];
        [userDef synchronize];
        [self.myTableView reloadData];
    }
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.myTableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.lable.text = [self.items[indexPath.row] objectForKey:@"title"];
    cell.icon.image = [UIImage imageNamed:[self.items[indexPath.row] objectForKey:@"imagename"]];
    
    NSInteger useIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kKTBDocManagerType];
    if (useIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

@end
