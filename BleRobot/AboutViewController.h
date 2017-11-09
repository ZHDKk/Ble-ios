//
//  AboutViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/9/12.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
#import <Toast/UIView+Toast.h>
@class CBPeripheral;
@class SerialGATT;
@interface AboutViewController : UIViewController<BTSmartSensorDelegate>
{
    UILabel *softText;
    UILabel *snText;
    BOOL loadIsShow;
}
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) SerialGATT *sensor;
@end
