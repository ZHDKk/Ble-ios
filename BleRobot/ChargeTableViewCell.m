//
//  ChargeTableViewCell.m
//  BleRobot
//
//  Created by zh dk on 2017/9/16.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "ChargeTableViewCell.h"

@implementation ChargeTableViewCell

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
        self.lableEnd = [[UILabel alloc]init];
        self.lableEnd.frame  = CGRectMake(0, 0, self.frame.size.width/2+20, 45);
        [ self.lableEnd setFont: [UIFont systemFontOfSize:14]];
        self.lableEnd.textAlignment= NSTextAlignmentCenter;
        [self addSubview: self.lableEnd];
        
        self.lableVoltage = [[UILabel alloc]init];
        self.lableVoltage.frame  = CGRectMake(self.frame.size.width/2+40, 0, self.frame.size.width/2, 45);
        [ self.lableVoltage setFont: [UIFont systemFontOfSize:14]];
        self.lableVoltage.textAlignment= NSTextAlignmentCenter;
        [self addSubview: self.lableVoltage];
        
        
    }
    return self;
}

@end
