//
//  SetDayTableViewCell.m
//  BleRobot
//
//  Created by zh dk on 2017/9/12.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "SetDayTableViewCell.h"
#define SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)

@implementation SetDayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _btnDay.selected = !_btnDay.selected;
        !_customSelectedBlock ?:_customSelectedBlock(_btnDay.selected,_row);
    }
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        lableDay = [[UILabel alloc]init];
//        [lableDay setText:@"MON"];
//        [lableDay setFont:[UIFont systemFontOfSize:14]];
//        lableDay.frame = CGRectMake(SCREEN_WIDTH*1/7, 8, 80, 40);
//        [self addSubview:lableDay];
        
        _btnDay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _btnDay.frame = CGRectMake(SCREEN_WIDTH*9/10, 13, 25, 25);
        _btnDay.tintColor = [UIColor clearColor];
        
        [_btnDay setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_btnDay setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
//        _btnDay.selected = !_btnDay.selected;
//        [_btnDay addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_btnDay];
    }
    return self;
}

-(void) pressBtn:(UIButton*)btn
{
    btn.selected = !btn.selected;
    
    !_customSelectedBlock ?:_customSelectedBlock(btn.selected,_row);
}
@end
