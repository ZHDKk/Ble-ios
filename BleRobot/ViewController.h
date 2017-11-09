//
//  ViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/9/5.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SerialGATT.h"
#import <Toast/UIView+Toast.h>
#import "XXJoyStickView.h"
@class CBPeripheral;
@class SerialGATT;
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,BTSmartSensorDelegate,CBCentralManagerDelegate>
{
    UIBarButtonItem *connectionBar;
    UIBarButtonItem *disCBar;
    
    UIView *view;
    UIView *controlView;
    UIImageView *statuImg;
    UIView *statuView;//运行状态view
    UILabel *statuLable;
    UIImageView *singalImg;
    UILabel *singalLable;
    UIImageView *powerImg;
    UILabel *powerLable;
    UIView *lineView;
    
    UIView *sensortView;
    
    CGRect rectOfNavigationbar;
    
    UIImageView *imageMoreTime;
    
    UIView *timeView;
    
    UITableView *languageTableView;
    
    UIButton *btnTime1;
    UIButton *btnTime2;
    UIButton *btnTime3;
    
    UILabel *rssiLabel;
    
    UIView *bottomStatuView;
    UIAlertController*alert;
    UIAlertController *alertDisConnect;
    NSString *rssi;
    UIAlertController *alertLanguage;
    UILabel *lableLanguage;
    NSThread *thread;
    BOOL loadIsShow;
    
    NSUserDefaults *defaults;
    
    XXJoyStickView *sv;
}
@property(strong,nonatomic) CBCentralManager *cm;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) SerialGATT *sensor;
@property (strong, nonatomic) NSTimer *timer;
@property  NSInteger handAlarmFlag;
@property  NSInteger autoAlarmFlag;
@property  NSInteger cancleAlarmFlag;
@property (strong, nonatomic) NSMutableArray *rssi_container; 
@end

