//
//  BottomDayView.h
//  BleRobot
//
//  Created by zh dk on 2017/9/12.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#define XHHTuanNumViewHight 470.0
#import "SetDayTableViewCell.h"
@interface BottomDayView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *selectRows;
    
    NSArray *datas;
    SetDayTableViewCell *cell;
    UITableView *detailTableView;
}

- (instancetype)initWithData:(NSString *)data;
    -(void)showInView:(UIView*)view;

typedef void(^CallBackNum)(NSString *num);
@property (nonatomic,copy)CallBackNum callBackNum;


@end
