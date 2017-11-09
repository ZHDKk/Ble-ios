//
//  SetDayTableViewCell.h
//  BleRobot
//
//  Created by zh dk on 2017/9/12.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetDayTableViewCell : UITableViewCell
{
    UILabel *lableDay;
    UIImageView *imageView;
}
typedef void(^CustomSelectBlock)(BOOL selected, NSInteger row);

@property (nonatomic, copy) CustomSelectBlock customSelectedBlock;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic,assign) UILabel *lableDay;
@property (nonatomic,strong) UIButton *btnDay;

@end
