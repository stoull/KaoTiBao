//
//  penTableViewCell.h
//  KaoTiBi
//
//  Created by Stoull Hut on 18/02/2017.
//  Copyright © 2017 CCApril. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : int{
    ColorTypeRed,
    ColorTypeOrange,
    ColorTypeYellow,
    ColorTypeCyan,
    ColorTypeGreen,
    ColorTypeBlue,
    ColorTypeBlack,
    ColorTypeDark,
    ColorTypeGray,
    ColorTypePink
}ColorType;

@interface penTableViewCell : UITableViewCell
@property (nonatomic, assign) ColorType colorType;
@property (nonatomic, assign) uint64_t lastTime;
@end
