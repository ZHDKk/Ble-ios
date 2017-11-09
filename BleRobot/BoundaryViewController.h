//
//  BoundaryViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/9/8.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
#import "WidthAlertView.h"
#import <Toast/UIView+Toast.h>
@class CBPeripheral;
@class SerialGATT;
@class WidthAlertView;
@interface BoundaryViewController : UIViewController<BTSmartSensorDelegate>
{
    UILabel *lableTrim;
    
    UILabel *lableSinal;
    NSThread *widthThread;
    NSThread *signalThread;
    UIAlertController *alertTrim;
     WidthAlertView *widthAlert;
    UIAlertController *alertSignal;
    BOOL loadIsShow;
}
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, strong)  UILabel *lableWidh;
@end
