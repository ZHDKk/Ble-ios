//
//  FaultTableViewTableViewCell.m
//  BleRobot
//
//  Created by zh dk on 2017/10/27.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "FaultTableViewTableViewCell.h"

@implementation FaultTableViewTableViewCell

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
        

        self.lableTime = [[UILabel alloc]init];
        self.lableTime.frame  = CGRectMake(0, 0, self.frame.size.width/2+20, 45);
        [ self.lableTime setFont: [UIFont systemFontOfSize:14]];
        self.lableTime.textAlignment= NSTextAlignmentCenter;
        [self addSubview: self.lableTime];
        
        self.lableStatus = [[UILabel alloc]init];
        self.lableStatus.frame  = CGRectMake(self.frame.size.width/2+40, 0, self.frame.size.width/2, 45);
        [ self.lableStatus setFont: [UIFont systemFontOfSize:14]];
        self.lableStatus.textAlignment= NSTextAlignmentCenter;
        [self addSubview: self.lableStatus];

        
    }
    return self;
}

@end
