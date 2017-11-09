//
//  BottomDayView.m
//  BleRobot
//
//  Created by zh dk on 2017/9/12.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "BottomDayView.h"
#define SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)

#import "SetDayTableViewCell.h"
#import "BleUtils.h"

@interface BottomDayView()
{
    UIView *_contentView;
}
@end
@implementation BottomDayView

//- (id)initWithFrame:(CGRect)frame {
//    if (self == [super initWithFrame:frame]) {
//
//        [self setupContent];
//        datas = [NSArray arrayWithObjects:@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT",@"SUN", nil];
//
//    }
//
//    return self;
//}

-(instancetype)initWithData:(NSString *)data
{
    if (self == [super init]) {
        [self setupContent];
        datas = [NSArray arrayWithObjects:@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT",@"SUN", nil];
        
       
        
      NSString *strBinary =   [BleUtils getBinaryByHex:data];
         NSLog(@"日期设置%@",strBinary);

        if ([[strBinary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"]) {
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [detailTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//                    [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    SetDayTableViewCell *cell = [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    [cell setSelected:YES animated:YES];
            cell.btnDay.selected = !cell.btnDay.selected ;
            cell.customSelectedBlock(cell.btnDay.selected, cell.row);
                }
        
        if ([[strBinary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"]) {
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    [detailTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    SetDayTableViewCell *cell = [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    [cell setSelected:YES animated:YES];
            cell.btnDay.selected = !cell.btnDay.selected ;
            cell.customSelectedBlock(cell.btnDay.selected, cell.row);
                }
        
        if ([[strBinary substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"]) {
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                    [detailTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    SetDayTableViewCell *cell = [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    [cell setSelected:YES animated:YES];
            cell.btnDay.selected = !cell.btnDay.selected ;
            cell.customSelectedBlock(cell.btnDay.selected, cell.row);
                }
        
        if ([[strBinary substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"]) {
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                    [detailTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    SetDayTableViewCell *cell = [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    [cell setSelected:YES animated:YES];
            cell.btnDay.selected = !cell.btnDay.selected ;
            cell.customSelectedBlock(cell.btnDay.selected, cell.row);
                }
        
        if ([[strBinary substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"]) {
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
                    [detailTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    SetDayTableViewCell *cell = [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    [cell setSelected:YES animated:YES];
            cell.btnDay.selected = !cell.btnDay.selected ;
            cell.customSelectedBlock(cell.btnDay.selected, cell.row);
                }
        
        if ([[strBinary substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"1"]) {
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                    [detailTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    SetDayTableViewCell *cell = [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    [cell setSelected:YES animated:YES];
            cell.btnDay.selected = !cell.btnDay.selected ;
            cell.customSelectedBlock(cell.btnDay.selected, cell.row);
                }
        
        if ([[strBinary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"]) {
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:6 inSection:0];
                    [detailTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    SetDayTableViewCell *cell = [detailTableView cellForRowAtIndexPath:selectedIndexPath];
                    [cell setSelected:YES animated:YES];
            cell.btnDay.selected = !cell.btnDay.selected ;
            cell.customSelectedBlock(cell.btnDay.selected, cell.row);
                }
    }
    return self;
}

- (void)setupContent {
    self.frame = CGRectMake(0, 0, SCREEN_HEIGHT, XHHTuanNumViewHight);
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    if (_contentView == nil) {
        
        CGFloat margin = 15;
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - XHHTuanNumViewHight, SCREEN_WIDTH, XHHTuanNumViewHight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        detailTableView  = [[UITableView alloc]init];
        detailTableView.backgroundColor = [UIColor clearColor];
        detailTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, XHHTuanNumViewHight*7/8);
        detailTableView.separatorStyle = UITableViewRowActionStyleNormal;
        detailTableView.tableFooterView = [UIView new];
        [_contentView addSubview:detailTableView];
        detailTableView.delegate = self;
        detailTableView.dataSource = self;
        
        
        UILabel *lableNo = [[UILabel alloc]init];
        [lableNo setText:@"NO"];
        [lableNo setFont:[UIFont systemFontOfSize:16]];
        lableNo.frame = CGRectMake(SCREEN_WIDTH/4-18, XHHTuanNumViewHight*3/4+8, 80, 40);
        
        lableNo.userInteractionEnabled = YES;
        UITapGestureRecognizer *noTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressLableNo)];
        [lableNo addGestureRecognizer:noTap];
        
        [_contentView addSubview:lableNo];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(SCREEN_WIDTH/2, XHHTuanNumViewHight*3/4, 1, XHHTuanNumViewHight/5);
        lineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
        [_contentView addSubview:lineView];
        
        UILabel *lableYES = [[UILabel alloc]init];
        [lableYES setText:@"YES"];
        [lableYES setFont:[UIFont systemFontOfSize:16]];
        lableYES.frame = CGRectMake(SCREEN_WIDTH*3/4-18, XHHTuanNumViewHight*3/4+8, 80, 40);
        lableYES.userInteractionEnabled = YES;
        UITapGestureRecognizer *yesTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressLableYes)];
        [lableYES addGestureRecognizer:yesTap];
        [_contentView addSubview:lableYES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SetDayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.row = indexPath.row;
//    __weak typeof(self) weakSelf = self;
    cell.textLabel.text = datas[indexPath.row];
    selectRows = [[NSMutableArray alloc]init];
    cell.customSelectedBlock = ^(BOOL selected, NSInteger row) {
        if (selected) {
            [selectRows addObject:@(row)];
        }else{
            [selectRows removeObject:@(row)];
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
}





-(void)pressLableNo
{
    [self disMissView];
}

-(void)pressLableYes
{
    int num =0;
    for (int i=0; i<selectRows.count; i++) {
        NSString *str=[NSString stringWithFormat:@"%@",selectRows[i]];
        if ([str isEqualToString:@"0"]) {
            num+=2;
        }
        if ([str isEqualToString:@"1"]){
            num+=4;
        }
        if ([str isEqualToString:@"2"]){
            num+=8;
        }
        if ([str isEqualToString:@"3"]){
            num+=16;
        }
        if ([str isEqualToString:@"4"]){
            num+=32;
        }
        if ([str isEqualToString:@"5"]){
            num+=64;
        }
        if ([str isEqualToString:@"6"]){
            num+=1;
        }
    }
    NSLog(@"选择：%d",num);
    NSString *str =[BleUtils getHexByDecimal:num];
    _callBackNum(str);
    [self disMissView];
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, XHHTuanNumViewHight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, SCREEN_HEIGHT - XHHTuanNumViewHight, SCREEN_WIDTH, XHHTuanNumViewHight)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    
    [_contentView setFrame:CGRectMake(0, SCREEN_HEIGHT - XHHTuanNumViewHight, SCREEN_WIDTH, XHHTuanNumViewHight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, XHHTuanNumViewHight)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
}

@end
