//
//  DeviceScanViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/9/25.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface DeviceScanViewController : UIViewController<BTSmartSensorDelegate,UITabBarDelegate,UITableViewDataSource,CBCentralManagerDelegate>
{
    UIView *scanView;
    UIView *roundView;
    UIImageView *rotateView;
    UITableView *devicesTableView;
    UIAlertController *alert;
}

@property(strong,nonatomic) SerialGATT *sensor;
@property(nonatomic,retain) NSMutableArray *devicesArray;
@property(strong,nonatomic) CBCentralManager *cm;
-(void)scanTimer:(NSTimer*) timer;
@end
