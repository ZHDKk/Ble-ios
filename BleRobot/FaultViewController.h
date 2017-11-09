//
//  FaultViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/9/16.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
@class CBPeripheral;
@class SerialGATT;

@interface FaultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,BTSmartSensorDelegate>
{
    UITableView *faultTableView;
    
    UIRefreshControl *faultRefresh;
    
    NSMutableArray *array;
}
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) SerialGATT *sensor;

@end
