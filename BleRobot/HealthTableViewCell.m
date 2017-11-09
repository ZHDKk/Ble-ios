//
//  HealthTableViewCell.m
//  BleRobot
//
//  Created by zh dk on 2017/10/27.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "HealthTableViewCell.h"

@implementation HealthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *lableTW = [[UILabel alloc]init];
        lableTW.frame = CGRectMake(0, 0, self.frame.size.width/2+20, 30);
        [lableTW setFont:[UIFont systemFontOfSize:14]];
        lableTW.textAlignment = NSTextAlignmentCenter;
        lableTW.text = @"Total Working";
        [self addSubview:lableTW];
        
        self.lableW = [[UILabel alloc]init];
        self.lableW.frame  = CGRectMake(0, 30, self.frame.size.width/2+20, 30);
        [ self.lableW setFont: [UIFont systemFontOfSize:14]];
        self.lableW.textAlignment= NSTextAlignmentCenter;
        [self addSubview: self.lableW];
        
        self.lableC = [[UILabel alloc]init];
        self.lableC.frame  = CGRectMake(self.frame.size.width/2+40, 30, self.frame.size.width/2, 30);
        [ self.lableC setFont: [UIFont systemFontOfSize:14]];
        self.lableC.textAlignment= NSTextAlignmentCenter;
        [self addSubview: self.lableC];
        
        UILabel *lableTC = [[UILabel alloc]init];
        lableTC.frame = CGRectMake(self.frame.size.width/2+40, 0, self.frame.size.width/2, 30);
        [lableTC setFont:[UIFont systemFontOfSize:14]];
        lableTC.textAlignment = NSTextAlignmentCenter;
        lableTC.text = @"Total Charging";
        [self addSubview:lableTC];
        
    }
    return self;
}
@end
