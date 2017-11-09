//
//  CutTableViewCell.m
//  BleRobot
//
//  Created by zh dk on 2017/9/16.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "CutTableViewCell.h"

@implementation CutTableViewCell

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
        self.lableStart = [[UILabel alloc]init];
         self.lableStart.frame  = CGRectMake(0, 0, self.frame.size.width/2+20, 45);
        [ self.lableStart setFont: [UIFont systemFontOfSize:14]];
         self.lableStart.textAlignment= NSTextAlignmentCenter;
        [self addSubview: self.lableStart];
        
         self.lableEnd = [[UILabel alloc]init];
         self.lableEnd.frame  = CGRectMake(self.frame.size.width/2+40, 0, self.frame.size.width/2, 45);
        [ self.lableEnd setFont: [UIFont systemFontOfSize:14]];
         self.lableEnd.textAlignment= NSTextAlignmentCenter;
        [self addSubview: self.lableEnd];
        
        
    }
    return self;
}

@end
