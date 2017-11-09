//
//  PinCodeViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/10/11.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SerialGATT.h"
#import "SYPasswordView.h"
@class CBPeripheral;
@class SerialGATT;

@interface PinCodeViewController : UIViewController<BTSmartSensorDelegate>
{
    UIView *bgView;
    UIAlertController  *alert;
    SYPasswordView *pasView;
    NSThread *thread;
    BOOL loadIsShow;
    
}
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) SerialGATT *sensor;
@property  NSInteger handAlarmFlag;
@property  NSInteger autoAlarmFlag;
@property  NSInteger cancleAlarmFlag;
@property NSUserDefaults *defaults;
@end
