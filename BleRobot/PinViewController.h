//
//  PinViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/9/8.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
#import <Toast/UIView+Toast.h>
@class CBPeripheral;
@class SerialGATT;
@interface PinViewController : UIViewController<BTSmartSensorDelegate,UITextFieldDelegate>

{
    UITextField *oldPin;
    UITextField *newPin;
    UITextField *reNewPin;
    
    UIButton *btnPin;
    
    NSString *strReturnPwd;
    NSString *strOldPwd;
    NSString *strNewPwd;
    NSString *strReNewPwd;
     BOOL loadIsShow;
}
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) SerialGATT *sensor;
@end
