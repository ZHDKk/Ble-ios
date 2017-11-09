//
//  LeftMenuView.m
//  BleRobot
//
//  Created by zh dk on 2017/9/5.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "LeftMenuView.h"
#define Frame_Width       self.frame.size.width   //200

@interface LeftMenuView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *contentTableView;

@end

@implementation LeftMenuView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void) initView
{
    self.backgroundColor = [UIColor whiteColor];
    //顶部view
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Frame_Width, 200)];
    UIImage *image = [UIImage imageNamed:@"bg.jpg"];
    UIImageView *bgImag = [[UIImageView alloc]initWithImage:image];
    bgImag.frame = CGRectMake(0, 0, Frame_Width, 200);
//    [headView setBackgroundColor:[UIColor greenColor]];
    [headView addSubview:bgImag];
    CGFloat width = 100/2;
    
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 55, width, width)];
    logoImage.layer.masksToBounds = YES;
    [logoImage setImage:[UIImage imageNamed:@"test"]];
    [headView addSubview:logoImage];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(85,100, 100, 40);
    [lable setText:@"RobotDemo"];
    [lable setTextColor:[UIColor whiteColor]];
    [headView addSubview:lable];
    
    [self addSubview:headView];
    
    //中间tableview
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height, Frame_Width, self.frame.size.height - headView.frame.size.height)];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;//拖动可以使键盘移出屏幕
    tableView.separatorStyle = UITableViewRowActionStyleNormal;
    tableView.tableFooterView = [UIView new];
    [self addSubview:tableView];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str= [NSString stringWithFormat:@"LeftView%li",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
//    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:[UIColor grayColor]];
    cell.hidden = NO;
    switch (indexPath.row) {
        case 0:
            [cell.imageView setImage:[UIImage imageNamed:@"control"]];
            cell.textLabel.text = @"control";
            break;
        case 1:
            [cell.imageView setImage:[UIImage imageNamed:@"time"]];
            cell.textLabel.text = @"timer";
            break;
        case 2:
            [cell.imageView setImage:[UIImage imageNamed:@"history"]];
            cell.textLabel.text = @"history";
            break;
        case 3:
            [cell.imageView setImage:[UIImage imageNamed:@"language"]];
            cell.textLabel.text = @"language";
            break;
        case 4:
            cell.textLabel.text=@"other";
            cell.textLabel.font = [UIFont systemFontOfSize:20];
            break;
        case 5:
            [cell.imageView setImage:[UIImage imageNamed:@"date"]];
            cell.textLabel.text = @"date";
            break;
        case 6:
            [cell.imageView setImage:[UIImage imageNamed:@"setting"]];
            cell.textLabel.text = @"setting";
            break;
        case 7:
            [cell.imageView setImage:[UIImage imageNamed:@"about"]];
            cell.textLabel.text = @"about";
            break;
            
        default:
            break;
    }
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]) {
        [self.customDelegate LeftMenuViewClick:indexPath.row];
    }
}
@end
