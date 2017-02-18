//
//  penTableViewCell.m
//  KaoTiBi
//
//  Created by Stoull Hut on 18/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import "penTableViewCell.h"

@interface penTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageHintView;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeValueLabel;


@end

@implementation penTableViewCell
-(void)setColorType:(ColorType)colorType{
    switch (colorType) {
        case ColorTypeRed:
            [self.imageHintView setImage:[UIImage imageNamed:@"RedPen"]];
            break;
        case ColorTypeOrange:
            [self.imageHintView setImage:[UIImage imageNamed:@"OrangePen"]];
            break;
        case ColorTypeYellow:
            [self.imageHintView setImage:[UIImage imageNamed:@"YellowPen"]];
            break;
        case ColorTypeCyan:
            [self.imageHintView setImage:[UIImage imageNamed:@"CyanPen"]];
            break;
        case ColorTypeGreen:
            [self.imageHintView setImage:[UIImage imageNamed:@"GreenPen"]];
            break;
        case ColorTypeBlue:
            [self.imageHintView setImage:[UIImage imageNamed:@"BluePen"]];
            break;
        case ColorTypeBlack:
            [self.imageHintView setImage:[UIImage imageNamed:@"BlackPen"]];
            break;
        case ColorTypeDark:
            [self.imageHintView setImage:[UIImage imageNamed:@"DarkPen"]];
            break;
        case ColorTypeGray:
            [self.imageHintView setImage:[UIImage imageNamed:@"GrayPen"]];
            break;
        case ColorTypePink:
            [self.imageHintView setImage:[UIImage imageNamed:@"PinkPen"]];
            break;
            
        default:
            [self.imageHintView setImage:[UIImage imageNamed:@"BlackPen"]];
            break;
    }
}

-(void)setLastTime:(uint64_t)lastTime{
    _lastTime = lastTime;
    if (lastTime < 1) {
        self.lastTimeValueLabel.hidden = YES;
        self.lastTimeLabel.text = @"暂未激活";
    }else{
        
        NSInteger day = lastTime / (60*60*24);
        NSInteger hour = (lastTime % (60*60*24)) / (60*60);
        NSInteger mine = (lastTime % (60*60)) / 60;
        NSInteger seconde = lastTime % 60;
        NSString *stringTim = [NSString stringWithFormat:@"%ld天%ld时%ld分",day,hour,mine];
        self.lastTimeValueLabel.text = stringTim;
        self.lastTimeValueLabel.hidden = NO;
        self.lastTimeLabel.text = @"剩余时间：";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
