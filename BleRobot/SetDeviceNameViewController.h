//
//  SetDeviceNameViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/11/2.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
#import <Toast/UIView+Toast.h>
@class CBPeripheral;
@class SerialGATT;
@interface SetDeviceNameViewController : UIViewController<BTSmartSensorDelegate>
{
    UITextField *reNewName;
    
    UIButton *btnDn;
    
    NSString *strNewName;
    NSString *strName;
    
    NSUserDefaults *defaults;
}


@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) SerialGATT *sensor;
@end
