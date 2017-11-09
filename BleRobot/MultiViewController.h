//
//  MultiViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/9/8.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
#import "DeclareAbnormalAlertView.h"
#import <Toast/UIView+Toast.h>
@class CBPeripheral;
@class SerialGATT;
@interface MultiViewController : UIViewController<BTSmartSensorDelegate>
{
    UILabel *lableA;
    UILabel *lableAp;
    
    UILabel *lableB;
    UILabel *lableBp;
    
    UILabel *lableC;
    UILabel *lableCp;
    
    UILabel *lableD;
    UILabel *lableDp;
    DeclareAbnormalAlertView *alertView;
    NSString *distance;
    NSString *area;
    BOOL loadIsShow;
}
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) SerialGATT *sensor;

@end
