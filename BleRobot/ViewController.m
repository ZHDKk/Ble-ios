//
//  ViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/5.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "ViewController.h"
#import "LeftMenuView.h"
#import "MenuView.h"
#import "DateViewController.h"
#import "SetViewController.h"
#import "AboutViewController.h"
#import "BottomDayView.h"
#import "FaultViewController.h"
#import "CutViewController.h"
#import "ChargeViewController.h"
#import "HealthViewController.h"
#import "XHDatePickerView.h"
#import "NSDate+XHExtension.h"
#import "DeviceScanViewController.h"
#import "BleUtils.h"
#import "CQHud.h"
#import "XXJoyStickView.h"
#import "SensorViewController.h"


@interface ViewController ()<HomeMenuViewDelegate>
@property(nonatomic,strong) MenuView *menu;

@end
@implementation ViewController
@synthesize autoAlarmFlag;
@synthesize handAlarmFlag;
@synthesize cancleAlarmFlag;
@synthesize timer;
@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    defaults = [NSUserDefaults standardUserDefaults];
    self.sensor.delegate = self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    LeftMenuView *menuView = [[LeftMenuView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width*0.8, [[UIScreen mainScreen] bounds].size.height)];
    menuView.customDelegate = self;
    self.menu= [[MenuView alloc]initWithDependencyView:self.view MenuView:menuView isShowCoverView:YES];
    
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(pressLeft)];
    self.navigationItem.leftBarButtonItem = barBtn;
    [self setTitle:@"control"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:69/255.0 green:139/255.0 blue:0 alpha:1]];
   
    
    
    connectionBar= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"conn"] style:UIBarButtonItemStylePlain target:self action:@selector(pressConBar)];
    disCBar= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"disconn"] style:UIBarButtonItemStylePlain target:self action:@selector(pressdiCBar)];
    
    rssiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    rssiLabel.text = @"0";
    rssiLabel.font = [UIFont systemFontOfSize:13];
    rssiLabel.textAlignment = NSTextAlignmentCenter;
    rssiLabel.textColor = [UIColor blackColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rssiLabel];
    NSArray *array =[NSArray arrayWithObjects:disCBar,item, nil];

    self.navigationItem.rightBarButtonItems = array;
    
     [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    rectOfNavigationbar =  self.navigationController.navigationBar.frame; //获取导航栏高度

    [self setControl];
    [self setBottomStatus];
    
    if (peripheral != nil) {
//    [self setConnect];
    autoAlarmFlag = 0;
    handAlarmFlag = 0;
    cancleAlarmFlag = 0;
        bottomStatuView.hidden = YES;
    self.navigationItem.rightBarButtonItem = connectionBar;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(displayRSSI) userInfo:nil repeats:YES];
    }
    
    //初始化
    self.cm = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
//    [self getData];
    
    loadIsShow = YES;
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [timer invalidate];
}
//连接
-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    autoAlarmFlag = 0;
    handAlarmFlag = 0;
    cancleAlarmFlag = 0;
    bottomStatuView.hidden = YES;
    [sensor connect:peripheral];
}
//断开连接
-(void)setDisconnect
{
    if (autoAlarmFlag == 0)
    {
        autoAlarmFlag = 1;
        [sensor disconnect:peripheral];
        self.navigationItem.rightBarButtonItem = disCBar;
        [self setControl];
        [self setBottomStatus];
        
        statuLable.text=@"No Status";
        powerLable.text=@"0%";
        singalLable.text = @"S1";
        [defaults setObject:@"S1" forKey:@"strSignal"];
        [defaults setObject:@"No Status" forKey:@"str"];
        [defaults setObject:@"0" forKey:@"strPower"];
        [defaults synchronize];
    }
}
-(void)displayRSSI{
    if ([sensor activePeripheral]) {
        static NSInteger rssiInt = 0;
        rssiLabel.text = @"0";
        if (sensor.activePeripheral.state == CBPeripheralStateConnected) {
            [peripheral readRSSI];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
             rssi= [NSString alloc];
            rssi = [numberFormatter stringFromNumber:peripheral.RSSI];
            rssiLabel.text = rssi;
//            if (rssi == 0) {
//                self.navigationItem.rightBarButtonItem = disCBar;
//                [self setControl];
//                [self setBottomStatus];
//            }
            rssiInt = [peripheral.RSSI intValue];
        }
    }else{
        [self.timer invalidate];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//实现判断蓝牙是否开启的代理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *message = nil;
    switch (central.state) {
        case 1:
            message = @"Bluetooth function is not supported by this device, please check out system setting";
            break;
        case 2:
            message = @"Bluetooth function is not authorized, please check out system setting";
            break;
        case 3:
            message = @"Bluetooth function is not authorized, please check out system setting";
            break;
        case 4:
            message = @"Bluetooth function is closed, please check out system setting";
            break;
        case 5:
            break;
        default:
            break;
    }
    if(message!=nil&&message.length!=0)
    {
        alert = [UIAlertController alertControllerWithTitle:@"prompt:" message:message preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction * action) {
//                                                                          NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
//                                                                          if ([[UIApplication sharedApplication]canOpenURL:url]) {
//                                                                              [[UIApplication sharedApplication]openURL:url];
//                                                                          }
//                                                                      }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                                 alert = nil;
                                                             }];
        [alert addAction:cancelAction];
//                [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void) LeftMenuViewClick:(NSInteger)tag
{
    [self.menu hidenWithAnimation];
    NSLog(@"tag = %lu",tag);
    switch (tag) {
        case 0:
            
            if (peripheral == nil) {
                [self setBottomStatus];
//                [self.view makeToast:@"Please connect devices"];
            }else{
                [self setControl];
            }
        
            break;
        case 1:
            
            if (peripheral == nil) {
                [self setBottomStatus];
                [self.view makeToast:@"Please connect devices"];
            }else{
                [self setTitle:@"timer"];
                [self setTime];
            }
            break;
        case 2:
           
            if (peripheral == nil) {
                [self setBottomStatus];
                [self.view makeToast:@"Please connect devices"];
            }else{
                [self setTitle:@"history"];
                [self setHistory];
            }
            break;
        case 3:
            
            if (peripheral == nil) {
                [self setBottomStatus];
                [self.view makeToast:@"Please connect devices"];
            }else{
                [self setTitle:@"language"];
                [self setLanguage];
            }

            break;
        case 5:
            if (peripheral==nil) {
                [self.view makeToast:@"Please connect devices"];
            }else{
                [self setDate];
                 }
            break;
        case 6:
                 if(peripheral == nil){
            [self.view makeToast:@"Please connect devices"];
                 }else{
                      [self setSetting];
                 }
            break;
        case 7:
            [self setAbout];
            break;
            
        default:
            break;
    }
}

-(void) pressLeft
{
    [self.menu show];
}

-(void) pressConBar
{
    alertDisConnect = [UIAlertController alertControllerWithTitle:@"prompt:" message:@"Are you sure you want to disconnect?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                             [self setDisconnect];
                                                              peripheral = nil;
                                                              [self setControl];
                                                              statuLable.text=@"No Status";
                                                              powerLable.text=@"0%";
                                                              singalLable.text = @"S1";
                                                              [self setBottomStatus];
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [alertDisConnect dismissViewControllerAnimated:YES completion:nil];
                                                             alertDisConnect = nil;
                                                         }];
    [alertDisConnect addAction:cancelAction];
    [alertDisConnect addAction:defaultAction];
    [self presentViewController:alertDisConnect animated:YES completion:nil];
    
}
-(void) pressdiCBar
{
    if (peripheral == nil) {
        DeviceScanViewController *dvc = [[DeviceScanViewController alloc]init];
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        [self setConnect];
        self.navigationItem.rightBarButtonItem = connectionBar;
    }
   
}

-(void)setBottomStatus
{
    bottomStatuView = [[UIView alloc]init];
    bottomStatuView.frame = CGRectMake(0, view.frame.size.height-112, view.frame.size.width, 50);
    bottomStatuView.backgroundColor =[UIColor colorWithRed:69/255.0 green:139/255.0 blue:0 alpha:1];
    
    UILabel *conLable = [[UILabel alloc]init];
    conLable.frame = CGRectMake(30, 10, 200, 30);
    [conLable setText:@"Please connect devices"];
    conLable.font = [UIFont systemFontOfSize:14];
    conLable.textAlignment = NSTextAlignmentLeft;
    [conLable setTextColor:[UIColor whiteColor]];
    [bottomStatuView addSubview:conLable];
    
    UILabel *connectLable = [[UILabel alloc]init];
    connectLable.frame = CGRectMake(250, 10, 100, 30);
    [connectLable setText:@"CONNECTION"];
    connectLable.font = [UIFont systemFontOfSize:14];
    connectLable.textAlignment = NSTextAlignmentLeft;
    [connectLable setTextColor:[UIColor redColor]];
    [bottomStatuView addSubview:connectLable];
    
    connectLable.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressConnect)];
    //将手势添加到需要相应的view中去
    [connectLable addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addSubview:bottomStatuView];
}

-(void)pressConnect{
    DeviceScanViewController *dvc = [[DeviceScanViewController alloc]init];
    [self.navigationController pushViewController:dvc animated:YES];
}
-(void)setControl
{
     [self setTitle:@"control"];
     [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
   

    controlView= [[UIView alloc] init];
    controlView.frame = CGRectMake(5, 5, view.frame.size.width - 10, (view.frame.size.height-200)/2);
    controlView.backgroundColor = [UIColor whiteColor];
    controlView.layer.cornerRadius = 5;
    controlView.layer.masksToBounds = YES;
    controlView.layer.shadowColor = [UIColor blackColor].CGColor;
    controlView.layer.shadowOffset = CGSizeMake(4, 4);
    controlView.layer.shadowRadius=5;
    controlView.layer.shadowOpacity = 1;
    
    statuImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    statuImg.frame = CGRectMake(0, 0, controlView.frame.size.width, controlView.frame.size.height/4*3);
    [controlView addSubview:statuImg];
    
    statuLable = [[UILabel alloc]init];
    statuLable.frame = CGRectMake(0, 0,statuImg.frame.size.width, statuImg.frame.size.height);
    [statuLable setText:@"No Status"];
    statuLable.font=[UIFont systemFontOfSize:40];
    [statuLable setTextColor:[UIColor whiteColor]];
    statuLable.textAlignment = NSTextAlignmentCenter;
    [controlView addSubview:statuLable];
    
    singalImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"single"]];
    singalImg.frame = CGRectMake(30, controlView.frame.size.height/4*3+(controlView.frame.size.height/4*1/2-15), 30, 30);
    [controlView addSubview:singalImg];
    
    singalLable = [[UILabel alloc]init];
    [singalLable setText:@"S1"];
    singalLable.font = [UIFont systemFontOfSize:12];
    [singalLable setTextColor:[UIColor blackColor]];
    singalLable.frame = CGRectMake(100, controlView.frame.size.height/4*3+(controlView.frame.size.height/4*1/2-18), 80, 40);
    [controlView addSubview:singalLable];
    
    lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(self.view.frame.size.width/2-10, controlView.frame.size.height/4*3+5, 1, controlView.frame.size.height/4*1-10);
    lineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [controlView addSubview:lineView];
    
    powerImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bat"]];
    powerImg.frame = CGRectMake(self.view.frame.size.width/2+20, controlView.frame.size.height/4*3+(controlView.frame.size.height/4*1/2-15), 30, 30);
    [controlView addSubview:powerImg];
    
    powerLable = [[UILabel alloc]init];
    [powerLable setText:@"0%"];
    powerLable.font = [UIFont systemFontOfSize:12];
    [powerLable setTextColor:[UIColor blackColor]];
    powerLable.frame = CGRectMake(self.view.frame.size.width/2+90, controlView.frame.size.height/4*3+(controlView.frame.size.height/4*1/2-18), 80, 40);
    [controlView addSubview:powerLable];
    
    
    UIView *chargeView = [[UIView alloc]init];
    chargeView.frame = CGRectMake(5, controlView.frame.size.height+12, (view.frame.size.width-30)/2, 50);
    chargeView.backgroundColor = [UIColor whiteColor];
    chargeView.layer.cornerRadius = 5;
    chargeView.layer.masksToBounds = YES;
    chargeView.layer.shadowColor = [UIColor blackColor].CGColor;
    chargeView.layer.shadowOffset = CGSizeMake(4, 4);
    chargeView.layer.shadowRadius=3;
    chargeView.layer.shadowOpacity = 1;
    [view addSubview:chargeView];
    
    UIImageView *chargeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"start"]];
    chargeImage.frame = CGRectMake(30, 10, 30, 30);
    [chargeView addSubview:chargeImage];
    
    UILabel *chargeLabel = [[UILabel alloc]init];
    chargeLabel.frame = CGRectMake(80, 0, 80, 50);
    [chargeLabel setText:@"start"];
    chargeLabel.font = [UIFont systemFontOfSize:14];
    chargeLabel.textAlignment = NSTextAlignmentLeft;
    [chargeLabel setTextColor:[UIColor blackColor]];
    [chargeView addSubview:chargeLabel];
    
    chargeView.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressCharge)];
    //将手势添加到需要相应的view中去
    [chargeView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    UIView *stopView = [[UIView alloc]init];
    stopView.frame = CGRectMake(view.frame.size.width/2, controlView.frame.size.height+12, (view.frame.size.width - 10)/2, 50);
    stopView.backgroundColor = [UIColor whiteColor];
    stopView.layer.cornerRadius = 5;
    stopView.layer.masksToBounds = YES;
    stopView.layer.shadowColor = [UIColor blackColor].CGColor;
    stopView.layer.shadowOffset = CGSizeMake(4, 4);
    stopView.layer.shadowRadius=3;
    stopView.layer.shadowOpacity = 1;
    [view addSubview:stopView];
    
    UIImageView *stopImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sto"]];
    stopImage.frame = CGRectMake(30, 10, 30, 30);
    [stopView addSubview:stopImage];
    
    UILabel *stopLabel = [[UILabel alloc]init];
    stopLabel.frame = CGRectMake(80, 0, 80, 50);
    [stopLabel setText:@"stop"];
    stopLabel.font = [UIFont systemFontOfSize:14];
    stopLabel.textAlignment = NSTextAlignmentLeft;
    [stopLabel setTextColor:[UIColor blackColor]];
    [stopView addSubview:stopLabel];
    
    stopView.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer * stopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressStop)];
    //将手势添加到需要相应的view中去
    [stopView addGestureRecognizer:stopTap];
    //选择触发事件的方式（默认单机触发）
    [stopTap setNumberOfTapsRequired:1];
    
    UIView *installView = [[UIView alloc]init];
    installView.frame = CGRectMake(5, controlView.frame.size.height+19+chargeView.frame.size.height, view.frame.size.width - 10, 50);
    installView.backgroundColor = [UIColor whiteColor];
    installView.layer.cornerRadius = 5;
    installView.layer.masksToBounds = YES;
    installView.layer.shadowColor = [UIColor blackColor].CGColor;
    installView.layer.shadowOffset = CGSizeMake(4, 4);
    installView.layer.shadowRadius=3;
    installView.layer.shadowOpacity = 1;
    [view addSubview:installView];
    
    UIImageView *installImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"charge"]];
    installImage.frame = CGRectMake(30, 10, 30, 30);
    [installView addSubview:installImage];
    
    UILabel *installLabel = [[UILabel alloc]init];
    installLabel.frame = CGRectMake(80, 0, 80, 50);
    [installLabel setText:@"charge"];
    installLabel.font = [UIFont systemFontOfSize:14];
    installLabel.textAlignment = NSTextAlignmentLeft;
    [installLabel setTextColor:[UIColor blackColor]];
    [installView addSubview:installLabel];
    
    installView.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer * tapGesture_install = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressInstall)];
    //将手势添加到需要相应的view中去
    [installView addGestureRecognizer:tapGesture_install];
    //选择触发事件的方式（默认单机触发）
    [tapGesture_install setNumberOfTapsRequired:1];

    
    UIView *startView = [[UIView alloc]init];
    startView.frame = CGRectMake(5, controlView.frame.size.height+51+chargeView.frame.size.height+25, view.frame.size.width - 10, 50);
    startView.backgroundColor = [UIColor whiteColor];
    startView.layer.cornerRadius = 5;
    startView.layer.masksToBounds = YES;
    startView.layer.shadowColor = [UIColor blackColor].CGColor;
    startView.layer.shadowOffset = CGSizeMake(4, 4);
    startView.layer.shadowRadius=3;
    startView.layer.shadowOpacity = 1;
    [view addSubview:startView];
    
    UIImageView *startImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"install"]];
    startImage.frame = CGRectMake(30, 10, 30, 30);
    [startView addSubview:startImage];
    
    UILabel *startLabel = [[UILabel alloc]init];
    startLabel.frame = CGRectMake(80, 0, 80, 50);
    [startLabel setText:@"install"];
    startLabel.font = [UIFont systemFontOfSize:14];
    startLabel.textAlignment = NSTextAlignmentLeft;
    [startLabel setTextColor:[UIColor blackColor]];
    [startView addSubview:startLabel];
    
    startView.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer * tapGesture_start = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressStart)];
    //将手势添加到需要相应的view中去
    [startView addGestureRecognizer:tapGesture_start];
    //选择触发事件的方式（默认单机触发）
    [tapGesture_start setNumberOfTapsRequired:1];
    
     sensortView= [[UIView alloc]init];
    sensortView.frame = CGRectMake(5, controlView.frame.size.height+183, view.frame.size.width - 10, 50);
    sensortView.backgroundColor = [UIColor whiteColor];
    sensortView.layer.cornerRadius = 5;
    sensortView.layer.masksToBounds = YES;
    sensortView.layer.shadowColor = [UIColor blackColor].CGColor;
    sensortView.layer.shadowOffset = CGSizeMake(4, 4);
    sensortView.layer.shadowRadius=3;
    sensortView.layer.shadowOpacity = 1;
    [view addSubview:sensortView];
    
    UIImageView *sensorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sensor"]];
    sensorImage.frame = CGRectMake(30, 10, 30, 30);
    [sensortView addSubview:sensorImage];
    
    UILabel *sensorLabel = [[UILabel alloc]init];
    sensorLabel.frame = CGRectMake(80, 0, 80, 50);
    [sensorLabel setText:@"sensor"];
    sensorLabel.font = [UIFont systemFontOfSize:14];
    sensorLabel.textAlignment = NSTextAlignmentLeft;
    [sensorLabel setTextColor:[UIColor blackColor]];
    [sensortView addSubview:sensorLabel];
    
    sensortView.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer * tapGesture_sensor = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressSensor)];
    //将手势添加到需要相应的view中去
    [sensortView addGestureRecognizer:tapGesture_sensor];
    //选择触发事件的方式（默认单机触发）
    [tapGesture_sensor setNumberOfTapsRequired:1];
    
    sensortView.hidden = YES;
    
    
    
    sv = [[XXJoyStickView alloc]initWithFrame:CGRectMake(view.frame.size.width-130, self.view.frame.size.height-rectOfNavigationbar.size.height-150, 120, 120)];
    __weak typeof(self)ws = self;
    sv.angleBlock = ^(float sinX, float sinY) {
         [ws moveViewWithSinX:sinX sinY:sinY];
    };
   
    sv.hidden = YES;
    [view addSubview:sv];


    [view addSubview:controlView];
    [self.view addSubview:view];
    
    if ([sensor activePeripheral]) {
        [self getStatus];
        
        NSString *strStatus = [defaults objectForKey:@"str"];
        NSString *strPower = [defaults objectForKey:@"strPower"];
        NSString *strSignal = [defaults objectForKey:@"strSignal"];
        
        if (strStatus.length>0) {
            statuLable.text = strStatus;
        }
        if (strPower.length>0) {
            powerLable.text = [strPower stringByAppendingString:@"%"];
        }
        
        if (strSignal.length>0) {
            singalLable.text = strSignal;
        }
    }
    

}

-(void)setTime
{
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //set cut day控件
    UIView *setDayView = [[UIView alloc]init];
    setDayView.frame = CGRectMake(5,5,self.view.frame.size.width-10,50);
    setDayView.backgroundColor = [UIColor whiteColor];
    setDayView.layer.cornerRadius = 5;
    setDayView.layer.masksToBounds = YES;
    setDayView.layer.shadowColor = [UIColor blackColor].CGColor;
    setDayView.layer.shadowOffset = CGSizeMake(4, 4);
    setDayView.layer.shadowRadius=3;
    setDayView.layer.shadowOpacity = 1;
    
    UIImageView *imageSetDay = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setday"]];
    imageSetDay.frame = CGRectMake(30, 10, 30, 30);
    [setDayView addSubview:imageSetDay];
    
    UILabel *lableSetDay = [[UILabel alloc]init];
    lableSetDay.frame = CGRectMake(80, 0, 200, 50);
    lableSetDay.font = [UIFont systemFontOfSize:14];
    lableSetDay.textAlignment = NSTextAlignmentLeft;
    [lableSetDay setTextColor:[UIColor blackColor]];
    [lableSetDay setText:@"Set Cut Days"];
    [setDayView addSubview:lableSetDay];
    
    UIImageView *imageMore = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMore.frame = CGRectMake(setDayView.frame.size.width*14/15, 15, 20, 20);
    [setDayView addSubview:imageMore];
    
    setDayView.userInteractionEnabled = YES;
    UITapGestureRecognizer *setDayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressSetDay)];
    [setDayView addGestureRecognizer:setDayTap];
    [setDayTap setNumberOfTouchesRequired:1];
    
    [view addSubview:setDayView];
    
    //set cut time控件
    UIView *setTimeView = [[UIView alloc]init];
    setTimeView.frame = CGRectMake(5,60,self.view.frame.size.width-10,50);
    setTimeView.backgroundColor = [UIColor whiteColor];
    setTimeView.layer.cornerRadius = 5;
    setTimeView.layer.masksToBounds = YES;
    setTimeView.layer.shadowColor = [UIColor blackColor].CGColor;
    setTimeView.layer.shadowOffset = CGSizeMake(4, 4);
    setTimeView.layer.shadowRadius=3;
    setTimeView.layer.shadowOpacity = 1;
    
    UIImageView *imageSetTime = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settime"]];
    imageSetTime.frame = CGRectMake(30, 10, 30, 30);
    [setTimeView addSubview:imageSetTime];
    
    UILabel *lableSetTime = [[UILabel alloc]init];
    lableSetTime.frame = CGRectMake(80, 0, 200, 50);
    lableSetTime.font = [UIFont systemFontOfSize:14];
    lableSetTime.textAlignment = NSTextAlignmentLeft;
    [lableSetTime setTextColor:[UIColor blackColor]];
    [lableSetTime setText:@"Set Cut Time"];
    [setTimeView addSubview:lableSetTime];
    
     imageMoreTime= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreTime.frame = CGRectMake(setTimeView.frame.size.width*14/15, 15, 20, 20);
    [setTimeView addSubview:imageMoreTime];
    
    setTimeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *setTimeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressSetTime)];
    [setTimeView addGestureRecognizer:setTimeTap];
    [setTimeTap setNumberOfTouchesRequired:1];
    
    [view addSubview:setTimeView];
    
     timeView= [[UIView alloc]init];
    timeView.frame = CGRectMake(self.view.frame.size.width*1/5, 115, self.view.frame.size.width*4/5-10, 140);
    timeView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    UIView *t1 = [[UIView alloc]init];
    t1.backgroundColor = [UIColor whiteColor];
    t1.layer.cornerRadius = 2;
    t1.layer.masksToBounds = YES;
    t1.layer.shadowColor = [UIColor blackColor].CGColor;
    t1.layer.shadowOffset = CGSizeMake(4, 4);
    t1.layer.shadowRadius=3;
    t1.layer.shadowOpacity = 1;
    t1.frame = CGRectMake(0, 0, timeView.frame.size.width, 35);
    
    UILabel *lableT1 = [[UILabel alloc]init];
    lableT1.frame = CGRectMake(50, 0, 80, t1.frame.size.height);
    lableT1.font = [UIFont systemFontOfSize:12];
    lableT1.textAlignment = NSTextAlignmentLeft;
    [lableT1 setText:@"T1"];
    [lableT1 setTextColor:[UIColor blackColor]];
    [t1 addSubview:lableT1];
    
     btnTime1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnTime1.frame = CGRectMake(t1.frame.size.width*2/5, 0, 150, t1.frame.size.height);
    [btnTime1 setTitle:@"00:00-23:00" forState:UIControlStateNormal];
    btnTime1.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnTime1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTime1 addTarget:self action:@selector(pressBtnTime1:) forControlEvents:UIControlEventTouchUpInside];
    [t1 addSubview:btnTime1];
    
    [timeView addSubview:t1];
    
    UIView *t2 = [[UIView alloc]init];
    t2.backgroundColor = [UIColor whiteColor];
    t2.layer.cornerRadius = 2;
    t2.layer.masksToBounds = YES;
    t2.layer.shadowColor = [UIColor blackColor].CGColor;
    t2.layer.shadowOffset = CGSizeMake(4, 4);
    t2.layer.shadowRadius=3;
    t2.layer.shadowOpacity = 1;
    t2.frame = CGRectMake(0, 40, timeView.frame.size.width, 35);
    
    UILabel *lableT2 = [[UILabel alloc]init];
    lableT2.frame = CGRectMake(50, 0, 80, t1.frame.size.height);
    lableT2.font = [UIFont systemFontOfSize:12];
    lableT2.textAlignment = NSTextAlignmentLeft;
    [lableT2 setText:@"T2"];
    [lableT2 setTextColor:[UIColor blackColor]];
    [t2 addSubview:lableT2];
    
    btnTime2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnTime2.frame = CGRectMake(t2.frame.size.width*2/5, 0, 150, t1.frame.size.height);
    [btnTime2 setTitle:@"00:00-23:00" forState:UIControlStateNormal];
    btnTime2.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnTime2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTime2 addTarget:self action:@selector(pressBtnTime2:) forControlEvents:UIControlEventTouchUpInside];
    [t2 addSubview:btnTime2];
    
    [timeView addSubview:t2];
    
    UIView *t3 = [[UIView alloc]init];
    t3.backgroundColor = [UIColor whiteColor];
    t3.layer.cornerRadius = 2;
    t3.layer.masksToBounds = YES;
    t3.layer.shadowColor = [UIColor blackColor].CGColor;
    t3.layer.shadowOffset = CGSizeMake(4, 4);
    t3.layer.shadowRadius=3;
    t3.layer.shadowOpacity = 1;
    t3.frame = CGRectMake(0, 80, timeView.frame.size.width, 35);
    
    UILabel *lableT3 = [[UILabel alloc]init];
    lableT3.frame = CGRectMake(50, 0, 80, t1.frame.size.height);
    lableT3.font = [UIFont systemFontOfSize:12];
    lableT3.textAlignment = NSTextAlignmentLeft;
    [lableT3 setText:@"T3"];
    [lableT3 setTextColor:[UIColor blackColor]];
    [t3 addSubview:lableT3];
    
    btnTime3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnTime3.frame = CGRectMake(t3.frame.size.width*2/5, 0, 150, t1.frame.size.height);
    [btnTime3 setTitle:@"00:00-23:00" forState:UIControlStateNormal];
    btnTime3.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnTime3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTime3 addTarget:self action:@selector(pressBtnTime3:) forControlEvents:UIControlEventTouchUpInside];
    [t3 addSubview:btnTime3];
    
    [timeView addSubview:t3];



    [view addSubview:timeView];
    
    timeView.hidden = YES;

    [self.view addSubview:view];

}

-(void)setHistory
{
     [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //创建fault
    UIView *setFaultView = [[UIView alloc]init];
    setFaultView.frame = CGRectMake(5,5,self.view.frame.size.width-10,50);
    setFaultView.backgroundColor = [UIColor whiteColor];
    setFaultView.layer.cornerRadius = 5;
    setFaultView.layer.masksToBounds = YES;
    setFaultView.layer.shadowColor = [UIColor blackColor].CGColor;
    setFaultView.layer.shadowOffset = CGSizeMake(4, 4);
    setFaultView.layer.shadowRadius=3;
    setFaultView.layer.shadowOpacity = 1;
    
    UIImageView *imageFault = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fault"]];
    imageFault.frame = CGRectMake(30, 10, 30, 30);
    [setFaultView addSubview:imageFault];
    
    UILabel *lableFault = [[UILabel alloc]init];
    lableFault.frame = CGRectMake(80, 0, 200, 50);
    lableFault.font = [UIFont systemFontOfSize:14];
    lableFault.textAlignment = NSTextAlignmentLeft;
    [lableFault setTextColor:[UIColor blackColor]];
    [lableFault setText:@"Fault"];
    [setFaultView addSubview:lableFault];
    
    UIImageView *imageMoreFault = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreFault.frame = CGRectMake(setFaultView.frame.size.width*14/15, 15, 20, 20);
    [setFaultView addSubview:imageMoreFault];
    
    setFaultView.userInteractionEnabled = YES;
    UITapGestureRecognizer *faultTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressFault)];
    [setFaultView addGestureRecognizer:faultTap];
    [faultTap setNumberOfTouchesRequired:1];
    
    //创建cutting
    UIView *setCutView = [[UIView alloc]init];
    setCutView.frame = CGRectMake(5,60,self.view.frame.size.width-10,50);
    setCutView.backgroundColor = [UIColor whiteColor];
    setCutView.layer.cornerRadius = 5;
    setCutView.layer.masksToBounds = YES;
    setCutView.layer.shadowColor = [UIColor blackColor].CGColor;
    setCutView.layer.shadowOffset = CGSizeMake(4, 4);
    setCutView.layer.shadowRadius=3;
    setCutView.layer.shadowOpacity = 1;
    
    UIImageView *imageCut = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cutting"]];
    imageCut.frame = CGRectMake(30, 10, 30, 30);
    [setCutView addSubview:imageCut];
    
    UILabel *lableCut = [[UILabel alloc]init];
    lableCut.frame = CGRectMake(80, 0, 200, 50);
    lableCut.font = [UIFont systemFontOfSize:14];
    lableCut.textAlignment = NSTextAlignmentLeft;
    [lableCut setTextColor:[UIColor blackColor]];
    [lableCut setText:@"Cutting"];
    [setCutView addSubview:lableCut];
    
    UIImageView *imageMoreCut = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreCut.frame = CGRectMake(setCutView.frame.size.width*14/15, 15, 20, 20);
    [setCutView addSubview:imageMoreCut];
    
    setCutView.userInteractionEnabled = YES;
    UITapGestureRecognizer *cutTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressCut)];
    [setCutView addGestureRecognizer:cutTap];
    [cutTap setNumberOfTouchesRequired:1];
    
    //创建charge
    UIView *setChargeView = [[UIView alloc]init];
    setChargeView.frame = CGRectMake(5,115,self.view.frame.size.width-10,50);
    setChargeView.backgroundColor = [UIColor whiteColor];
    setChargeView.layer.cornerRadius = 5;
    setChargeView.layer.masksToBounds = YES;
    setChargeView.layer.shadowColor = [UIColor blackColor].CGColor;
    setChargeView.layer.shadowOffset = CGSizeMake(4, 4);
    setChargeView.layer.shadowRadius=3;
    setChargeView.layer.shadowOpacity = 1;
    
    UIImageView *imageCharge = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chargeh"]];
    imageCharge.frame = CGRectMake(30, 10, 30, 30);
    [setChargeView addSubview:imageCharge];
    
    UILabel *lableCharge = [[UILabel alloc]init];
    lableCharge.frame = CGRectMake(80, 0, 200, 50);
    lableCharge.font = [UIFont systemFontOfSize:14];
    lableCharge.textAlignment = NSTextAlignmentLeft;
    [lableCharge setTextColor:[UIColor blackColor]];
    [lableCharge setText:@"Charge"];
    [setChargeView addSubview:lableCharge];
    
    UIImageView *imageMoreCharge = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreCharge.frame = CGRectMake(setChargeView.frame.size.width*14/15, 15, 20, 20);
    [setChargeView addSubview:imageMoreCharge];
    
    setChargeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *chargeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressChargeh)];
    [setChargeView addGestureRecognizer:chargeTap];
    [chargeTap setNumberOfTouchesRequired:1];
    
    //创建health
    UIView *setHealthView = [[UIView alloc]init];
    setHealthView.frame = CGRectMake(5,170,self.view.frame.size.width-10,50);
    setHealthView.backgroundColor = [UIColor whiteColor];
    setHealthView.layer.cornerRadius = 5;
    setHealthView.layer.masksToBounds = YES;
    setHealthView.layer.shadowColor = [UIColor blackColor].CGColor;
    setHealthView.layer.shadowOffset = CGSizeMake(4, 4);
    setHealthView.layer.shadowRadius=3;
    setHealthView.layer.shadowOpacity = 1;
    
    UIImageView *imageHealth = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"health"]];
    imageHealth.frame = CGRectMake(30, 10, 30, 30);
    [setHealthView addSubview:imageHealth];
    
    UILabel *lableHealth = [[UILabel alloc]init];
    lableHealth.frame = CGRectMake(80, 0, 200, 50);
    lableHealth.font = [UIFont systemFontOfSize:14];
    lableHealth.textAlignment = NSTextAlignmentLeft;
    [lableHealth setTextColor:[UIColor blackColor]];
    [lableHealth setText:@"Health"];
    [setHealthView addSubview:lableHealth];
    
    UIImageView *imageMoreHealth = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreHealth.frame = CGRectMake(setHealthView.frame.size.width*14/15, 15, 20, 20);
    [setHealthView addSubview:imageMoreHealth];
    
    setHealthView.userInteractionEnabled = YES;
    UITapGestureRecognizer *healthTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressHealth)];
    [setHealthView addGestureRecognizer:healthTap];
    [healthTap setNumberOfTouchesRequired:1];

    [view addSubview:setHealthView];
    [view addSubview:setChargeView];
    [view addSubview:setFaultView];
    [view addSubview:setCutView];


}

-(void)setLanguage
{
     [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    languageTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    languageTableView.frame = CGRectMake(0, 5, view.frame.size.width, view.frame.size.height*4/5);
    languageTableView.delegate = self;
    languageTableView.dataSource = self;
    languageTableView.separatorStyle = UITableViewRowActionStyleNormal;
    languageTableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    languageTableView.tableFooterView = [UIView new];
    languageTableView.showsVerticalScrollIndicator = NO;
    
    UIView *langView = [[UIView alloc]init];
    langView.frame = CGRectMake(0, view.frame.size.height*4/5, view.frame.size.width, view.frame.size.height*1/5);
    langView.backgroundColor = [UIColor whiteColor];
    
    lableLanguage = [[UILabel alloc]init];
    [lableLanguage setText:@"Current language:"];
    [lableLanguage setTextColor:[UIColor blackColor]];
    lableLanguage.frame = CGRectMake(20, -30, langView.frame.size.width, langView.frame.size.height);
//    lableLanguage.textAlignment = NSTextAlignmentLeft;
    lableLanguage.font = [UIFont systemFontOfSize:15];
    [langView addSubview:lableLanguage];
    [view addSubview:langView];
    [view addSubview:languageTableView];
    
    NSString *strSetLanguage = @"55AA02001F";
    NSString *str =[strSetLanguage stringByAppendingString:[BleUtils makeCheckSum:strSetLanguage]];
    [sensor write:peripheral value:str];
    [CQHud LoadingShow];
    loadIsShow = YES;
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
}

-(void)setDate
{
    DateViewController *dc = [[DateViewController alloc]init];
    dc.peripheral=peripheral;
    dc.sensor = sensor;
    [self.navigationController pushViewController:dc animated:YES];
}

-(void)setSetting
{
    SetViewController *sc = [[SetViewController alloc]init];
    sc.peripheral = peripheral;
    sc.sensor = sensor;
    [self.navigationController pushViewController:sc animated:YES];
}

-(void)setAbout
{
    AboutViewController *ac = [[AboutViewController alloc]init];
    ac.peripheral = peripheral;
    ac.sensor = sensor;
    [self.navigationController pushViewController:ac animated:YES];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [NSString stringWithFormat:@"LanguageView%li",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"English";
            break;
        case 1:
            cell.textLabel.text = @"Swedish";
            break;
        case 2:
            cell.textLabel.text = @"German";
            break;
        case 3:
            cell.textLabel.text = @"Danish";
            break;
        case 4:
            cell.textLabel.text = @"Spanish";
            break;
        case 5:
            cell.textLabel.text = @"Finnish";
            break;
        case 6:
            cell.textLabel.text = @"French";
            break;
        case 7:
            cell.textLabel.text = @"Ltalian";
            break;
        case 8:
            cell.textLabel.text = @"Dutch";
            break;
        case 9:
            cell.textLabel.text = @"Norwegian";
            break;
            
        default:
            break;
    }
    return cell;
    
}

-(void)setLanguage:(NSString *)strNum :(NSString*)strLanguage
{
    alertLanguage = [UIAlertController alertControllerWithTitle:@"prompt:" message:@"Confirm to switch?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              NSString *str = [strNum stringByAppendingString:[BleUtils makeCheckSum:strNum]];
                                                              [sensor write:peripheral value:str];
                                                              [lableLanguage setText:strLanguage];
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [alertLanguage dismissViewControllerAnimated:YES
                                                                                               completion:nil];
                                                             alertLanguage = nil;
                                                         }];
    [alertLanguage addAction:cancelAction];
    [alertLanguage addAction:defaultAction];
    [self presentViewController:alertLanguage animated:YES completion:nil];
}

//language点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中的颜色
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
            NSLog(@"点击0");
            [self setLanguage:@"55AA03002000":@"Current language:English"];
            break;
        case 1:
            NSLog(@"点击1");
            [self setLanguage:@"55AA03002001":@"Current language:Swedish"];
            break;
        case 2:
            NSLog(@"点击2");
            [self setLanguage:@"55AA03002002":@"Current language:German"];
            break;
        case 3:
            NSLog(@"点击3");
            [self setLanguage:@"55AA03002003":@"Current language:Danish"];
            break;
        case 4:
            NSLog(@"点击4");
            [self setLanguage:@"55AA03002004":@"Current language:Spanish"];
            break;
        case 5:
            NSLog(@"点击5");
            [self setLanguage:@"55AA03002005":@"Current language:Finnish"];
            break;
        case 6:
            NSLog(@"点击6");
            [self setLanguage:@"55AA03002006":@"Current language:French"];
            break;
        case 7:
            NSLog(@"点击7");
            [self setLanguage:@"55AA03002007":@"Current language:Ltalian"];
            break;
        case 8:
            NSLog(@"点击8");
            [self setLanguage:@"55AA03002008":@"Current language:Dutch"];
            break;
        case 9:
            NSLog(@"点击9");
            [self setLanguage:@"55AA03002009":@"Current language:Norwegian"];
            break;
        default:
            break;
    }
}

-(void)pressCharge
{
    NSLog(@"点击start");
    if (sensortView.isHidden) {
        sensortView.hidden = NO;
    }
    if (peripheral == nil || rssi==0) {
        [self.view makeToast:@"Please connect devices"];
    }else{
    NSString *strStart = @"55AA020004";
    NSString *str =[strStart stringByAppendingString:[BleUtils makeCheckSum:strStart]];
    [sensor write:peripheral value:str];
        [CQHud LoadingShow];
        loadIsShow = YES;
        [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    }
}
-(void)pressStop{
    NSLog(@"点击stop");
    if (peripheral == nil || rssi==0) {
        [self.view makeToast:@"Please connect devices"];
    }else{
    NSString *strStop = @"55AA020024";
    NSString *str =[strStop stringByAppendingString:[BleUtils makeCheckSum:strStop]];
    [sensor write:peripheral value:str];
        [CQHud LoadingShow];
        loadIsShow = YES;
        [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    }
}
-(void)pressInstall
{
    NSLog(@"点击charge");
    if (peripheral == nil || rssi==0) {
        [self.view makeToast:@"Please connect devices"];
    }else{
    NSString *strCharge = @"55AA020005";
    NSString *str =[strCharge stringByAppendingString:[BleUtils makeCheckSum:strCharge]];
    [sensor write:peripheral value:str];
        [CQHud LoadingShow];
        loadIsShow = YES;
        [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    }
}
-(void)pressStart
{
    NSLog(@"点击install");
    if (peripheral == nil || rssi==0) {
        [self.view makeToast:@"Please connect devices"];
    }else{
    NSString *strInstall = @"55AA020021";
    NSString *str =[strInstall stringByAppendingString:[BleUtils makeCheckSum:strInstall]];
    [sensor write:peripheral value:str];
        [CQHud LoadingShow];
        loadIsShow = YES;
        [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    }
    
}

-(void)pressSensor
{
    NSLog(@"点击sensor");
    //进入重力遥控界面
    SensorViewController *svc = [[SensorViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)pressSetDay
{
    NSLog(@"点击 set cut days");
    
    [CQHud LoadingShow];
    loadIsShow = YES;
     [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    NSString *strSetDay = @"55AA020011";
    NSString *str =[strSetDay stringByAppendingString:[BleUtils makeCheckSum:strSetDay]];
    [sensor write:peripheral value:str];
    
    
}
-(void)pressSetTime
{
    NSLog(@"点击 set cut time");
    
    if (timeView.isHidden) {
        NSString *strSetTime = @"55AA020013";
        NSString *str =[strSetTime stringByAppendingString:[BleUtils makeCheckSum:strSetTime]];
        [sensor write:peripheral value:str];
        [CQHud LoadingShow];
        loadIsShow = YES;
         [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    }else{
        imageMoreTime.image = [UIImage imageNamed:@"more"];
        timeView.hidden = YES;

    }
    
}

-(void) pressBtnTime1:(UIButton*)btn{
    NSLog(@"点击时间1");
    [self setTime:btn:@"55AA0D0014"];
}

-(void) pressBtnTime2:(UIButton*)btn{
    NSLog(@"点击时间2");
    [self setTime:btn:@"55AA0D0015"];
}

-(void) pressBtnTime3:(UIButton*)btn{
    NSLog(@"点击时间3");
    [self setTime:btn:@"55AA0D0016"];
}

-(void)setTime:(UIButton*)btn:(NSString*)strSum{
    XHDateStyle dateStyle =DateStyleShowHourMinute;
    NSString *format=  @"HH:mm";
    XHDatePickerView *datepicker = [[XHDatePickerView alloc]initWithCurrentDate:[NSDate date] CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
        
        NSString *start1;
        NSString *end1;
        if (startDate) {
            start1=  [startDate stringWithFormat:format];
        }
        if (endDate) {
            end1 =  [endDate stringWithFormat:format];
        }
        if (start1 !=nil && start1.length!=0 && end1 !=nil && end1.length !=0) {
            NSString *strTime =[NSString stringWithFormat:@"%@-%@",start1,end1];
            NSString *strTohex = [BleUtils convertStringToHexStr:strTime];
            NSString *sum = [strSum stringByAppendingString:strTohex];
            NSString *str = [sum stringByAppendingString:[BleUtils makeCheckSum:sum]];
            [sensor write:peripheral value:str];
             [btn setTitle:strTime forState:UIControlStateNormal];
        }
//        else{
//            [self.view makeToast:@"time can not be empty"];
//        }
       
    }];
    
    datepicker.datePickerStyle = dateStyle;
    datepicker.dateType = DateTypeStartDate;
    datepicker.minLimitDate = [NSDate date:@"2017-2-28 12:22" WithFormat:@"yyyy-MM-dd HH:mm"];
    datepicker.maxLimitDate = [NSDate date:@"2018-2-28 12:12" WithFormat:@"yyyy-MM-dd HH:mm"];
    [datepicker show];
}

-(void)pressFault
{
    FaultViewController *fc = [[FaultViewController alloc]init];
    fc.peripheral=peripheral;
    fc.sensor = sensor;
    [self.navigationController pushViewController:fc animated:YES];
}

-(void)pressCut
{
    
    CutViewController *cc =[[CutViewController alloc]init];
    cc.peripheral = peripheral;
    cc.sensor =sensor;
    [self.navigationController pushViewController:cc animated:YES];
}

-(void)pressChargeh
{
    ChargeViewController *chargeC = [[ChargeViewController alloc]init];
    chargeC.peripheral = peripheral;
    chargeC.sensor = sensor;
    [self.navigationController pushViewController:chargeC animated:YES];
}

-(void)pressHealth
{
    HealthViewController *hc= [[HealthViewController alloc]init];
    hc.peripheral = peripheral;
    hc.sensor = sensor;
    [self.navigationController pushViewController:hc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
-(void)dismissLoading
{
    if (loadIsShow) {
        [self.view makeToast:@"Get data error" duration:2 position:0];
        [CQHud LoadingDismiss];
        loadIsShow = NO;
    }
}

-(void)getStatus
{
    NSString *strGetSignal = @"55AA02000A";
    NSString *strSignal =[strGetSignal stringByAppendingString:[BleUtils makeCheckSum:strGetSignal]];
    [sensor write:peripheral value:strSignal];
    
     [self performSelector:@selector(sendStatus) withObject:nil afterDelay:0.5];
}

-(void)sendStatus
{
    NSString *strGetStatus = @"55AA020025";
    NSString *strStatus =[strGetStatus stringByAppendingString:[BleUtils makeCheckSum:strGetStatus]];
    statuLable.text=@"Get Status...";
    [defaults setObject:@"Get Status..." forKey:@"str"];
    [defaults synchronize];
    if (peripheral!=nil) {
        [sensor write:peripheral value:strStatus];
        [CQHud LoadingShow];
        loadIsShow = YES;
        [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    }
 
}

/*
 虚拟摇杆
 */
- (void)moveViewWithSinX:(float)sinX sinY:(float)sinY {
   
    //虚拟摇杆控制
    NSLog(@"x=%f\ny=%f\n",sinX,sinY);
}

-(void) getData
{
    __weak typeof(self)sf = self;
    sensor.callBackBlock = ^(NSString *text) {
        if (text.length>=12) {
            //判断set cut days
            if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0011"]) {

                if (text.length>=12) {
                    BottomDayView *dayView = [[BottomDayView alloc]initWithData:[text substringWithRange:NSMakeRange(10, 2)]];
                    [dayView showInView:sf.view];
                    dayView.callBackNum = ^(NSString *num) {
                        if (num.length==1) {
                            num = [@"0"stringByAppendingString:num];
                        }
                        NSString *strCheckNum = [@"55AA030012" stringByAppendingString:num];
                        NSString *str=[strCheckNum stringByAppendingString:[BleUtils makeCheckSum:strCheckNum]];
                        [sensor write:peripheral value:str];
                    };
                }
                
                //判断set cut time
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0013"]){

                imageMoreTime.image = [UIImage imageNamed:@"down"];
                timeView.hidden = NO;
                if (text.length>=80) {
                    NSString *t1 = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, 22)]];
                    NSString *t2 = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(34, 22)]];
                    NSString *t3 = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(58, 22)]];
                    [btnTime1 setTitle:t1 forState:UIControlStateNormal];
                    [btnTime2 setTitle:t2 forState:UIControlStateNormal];
                    [btnTime3 setTitle:t3 forState:UIControlStateNormal];
                }
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"001d"]){
        
                if ([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"00"]) {
                    lableLanguage.text = @"Current language:English";
                }else if([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"01"]){
                    lableLanguage.text = @"Current language:Swedish";
                }else if([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"02"]){
                    lableLanguage.text = @"Current language:German";
                }else if([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"03"]){
                    lableLanguage.text = @"Current language:Danish";
                }else if([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"04"]){
                    lableLanguage.text = @"Current language:Spanish";
                }else if([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"05"]){
                    lableLanguage.text = @"Current language:Finnish";
                }else if([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"06"]){
                    lableLanguage.text = @"Current language:French";
                }else if([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"07"]){
                    lableLanguage.text = @"Current language:Ltalian";
                }else if([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"08"]){
                    lableLanguage.text = @"Current language:Dutch";
                }else if([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"09"]){
                    lableLanguage.text = @"Current language:Norwegian";
                }
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"002300"]){
                statuLable.text=@"Running";
                [defaults setObject:@"Running" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0026"]){
                statuLable.text=@"Stop";
                [defaults setObject:@"Stop" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"00230a"]){
                statuLable.text=@"Please Close Cover";
                [defaults setObject:@"Please Close Cover" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"002301"]){
                statuLable.text=@"Home";
                [defaults setObject:@"Home" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"002302"]){
                statuLable.text=@"OutSide";
                [defaults setObject:@"OutSide" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"002303"]){
                statuLable.text=@"No Signal";
                [defaults setObject:@"No Signal" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"002304"]){
                statuLable.text=@"Lift";
                [defaults setObject:@"Lift" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"002305"]){
                statuLable.text=@"Tilt";
                [defaults setObject:@"Tilt" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"002306"]){
                statuLable.text=@"Pit";
                [defaults setObject:@"Pit" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"002307"]){
                statuLable.text=@"Low Voltage";
                [defaults setObject:@"Low Voltage" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"002308"]){
                statuLable.text=@"Waiting";
                [defaults setObject:@"Waiting" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"002309"]){
                statuLable.text=@"Spare Time";
                [defaults setObject:@"Spare Time" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"00230b"]){
                statuLable.text=@"Charging Now";
                [defaults setObject:@"Charging Now" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 6)] isEqualToString:@"00230c"]){
                statuLable.text=@"Stand By";
                [defaults setObject:@"Stand By" forKey:@"str"];
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0025"]){
                if (text.length>=16) {
                   NSString *strPower =  [[BleUtils numberHexString:[text substringWithRange:NSMakeRange(14, 2)]] stringValue];
                    powerLable.text = [strPower stringByAppendingString:@"%"];
                    [defaults setObject:strPower forKey:@"strPower"];
                    if ([[text substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"01"]) {
                        statuLable.text = @"Charging Now";
                        [defaults setObject:@"Charging Now" forKey:@"str"];
                    }
                }
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"001f"]){
                [self.view makeToast:@"Install Success"];
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0024"]){
                NSString *str = [text substringWithRange:NSMakeRange(10, 2)];
                if ([str isEqualToString:@"00"]) {
                    statuLable.text = @"NULL";
                    [defaults setObject:@"NULL" forKey:@"str"];
                }else  if ([str isEqualToString:@"01"]) {
                    statuLable.text = @"Low Bat";
                    [defaults setObject:@"Low Bat" forKey:@"str"];
                }else  if ([str isEqualToString:@"02"]) {
                    statuLable.text = @"No Signal";
                    [defaults setObject:@"No Signal" forKey:@"str"];
                }else  if ([str isEqualToString:@"03"]) {
                    statuLable.text = @"OutSide";
                    [defaults setObject:@"OutSide" forKey:@"str"];
                }else  if ([str isEqualToString:@"04"]) {
                    statuLable.text = @"Pit";
                    [defaults setObject:@"Pit" forKey:@"str"];
                }else  if ([str isEqualToString:@"05"]) {
                    statuLable.text = @"Slope";
                    [defaults setObject:@"Slope" forKey:@"str"];
                }else  if ([str isEqualToString:@"06"]) {
                    statuLable.text = @"Lift";
                    [defaults setObject:@"Lift" forKey:@"str"];
                }else  if ([str isEqualToString:@"07"]) {
                    statuLable.text = @"M1 Brake";
                    [defaults setObject:@"M1 Brake" forKey:@"str"];
                }else  if ([str isEqualToString:@"08"]) {
                    statuLable.text = @"M2 Brake";
                    [defaults setObject:@"M2 Brake" forKey:@"str"];
                }else  if ([str isEqualToString:@"09"]) {
                    statuLable.text = @"Turn Over";
                    [defaults setObject:@"Turn Over" forKey:@"str"];
                }else  if ([str isEqualToString:@"0a"]) {
                    statuLable.text = @"ERROR01";
                    [defaults setObject:@"ERROR01" forKey:@"str"];
                }else  if ([str isEqualToString:@"0b"]) {
                    statuLable.text = @"ERROR020L";
                    [defaults setObject:@"ERROR20L" forKey:@"str"];
                }else  if ([str isEqualToString:@"0c"]) {
                    statuLable.text = @"ERROR21";
                    [defaults setObject:@"ERROR21" forKey:@"str"];
                }else  if ([str isEqualToString:@"0d"]) {
                    statuLable.text = @"ERROR22";
                    [defaults setObject:@"ERROR22" forKey:@"str"];
                }else  if ([str isEqualToString:@"0e"]) {
                    statuLable.text = @"ERROR23";
                    [defaults setObject:@"ERROR23" forKey:@"str"];
                }else  if ([str isEqualToString:@"0f"]) {
                    statuLable.text = @"ERROR24";
                    [defaults setObject:@"ERROR24" forKey:@"str"];
                }else  if ([str isEqualToString:@"10"]) {
                    statuLable.text = @"ERROR3";
                    [defaults setObject:@"ERROR3" forKey:@"str"];
                }else  if ([str isEqualToString:@"11"]) {
                    statuLable.text = @"ERROR4";
                    [defaults setObject:@"ERROR4" forKey:@"str"];
                }else  if ([str isEqualToString:@"12"]) {
                    statuLable.text = @"Trapped";
                    [defaults setObject:@"Trapped" forKey:@"str"];
                }else  if ([str isEqualToString:@"13"]) {
                    statuLable.text = @"ERROR20M";
                    [defaults setObject:@"ERROR20M" forKey:@"str"];
                }else  if ([str isEqualToString:@"1a"]) {
                    statuLable.text = @"12C ERROR";
                    [defaults setObject:@"12C ERROR" forKey:@"str"];
                }else  if ([str isEqualToString:@"1b"]) {
                    statuLable.text = @"ERROR20R";
                    [defaults setObject:@"ERROR20R" forKey:@"str"];
                }
            }else if ([[text substringWithRange:NSMakeRange(4, 6)] isEqualToString:@"03000a"]){
                NSString *strSignal = [text substringWithRange:NSMakeRange(10, 2)];
                if ([strSignal isEqualToString:@"01"]) {
                    singalLable.text = @"S1";
                    [defaults setObject:@"S1" forKey:@"strSignal"];
                }else if([strSignal isEqualToString:@"02"]){
                    singalLable.text = @"S2";
                    [defaults setObject:@"S2" forKey:@"strSignal"];
                }
            }
            [CQHud LoadingDismiss];
            [defaults synchronize];
            loadIsShow = NO;
        }
    };
}



@end
