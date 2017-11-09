//
//  PinCodeViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/10/11.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "PinCodeViewController.h"
#import "DeviceScanViewController.h"
#import "SYPasswordView.h"
#import "ViewController.h"
#import "BleUtils.h"
#import "CQHud.h"

@interface PinCodeViewController ()

@end

@implementation PinCodeViewController

@synthesize autoAlarmFlag;
@synthesize handAlarmFlag;
@synthesize cancleAlarmFlag;
@synthesize sensor;
@synthesize peripheral;
@synthesize defaults;

- (void)viewDidLoad {
    self.sensor.delegate = self;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    [self setTitle:@"PIN code"];
    [self createView];
    
    if (peripheral != nil) {
//        [self setConnect];
        autoAlarmFlag = 0;
        handAlarmFlag = 0;
        cancleAlarmFlag = 0;
        
       
    }
    
    loadIsShow = YES;
    
  
   
}
//连接
-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    autoAlarmFlag = 0;
    handAlarmFlag = 0;
    cancleAlarmFlag = 0;
    [sensor connect:peripheral];
    
    NSString *strCharge = @"55 AA 02 00 03 04";
    [sensor write:peripheral value:strCharge];
}
//断开连接
-(void)setDisconnect
{
    if (autoAlarmFlag == 0)
    {
        autoAlarmFlag = 1;
        [sensor disconnect:peripheral];
    }
}
-(void)didMoveToParentViewController:(UIViewController *)parent
{
     [super didMoveToParentViewController:parent];
    if (!parent) {
        if (peripheral!=nil) {
            [self setDisconnect];
        }
    }
    
}
-(void)createView
{
    bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(5, 5, self.view.frame.size.width-10, 250);
    [bgView setBackgroundColor:[UIColor whiteColor]];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(4, 4);
    bgView.layer.shadowRadius=5;
    bgView.layer.shadowOpacity = 1;
    
    UILabel *lableCode = [[UILabel alloc]init];
    lableCode.frame = CGRectMake(120, 50, 200, 40);
    lableCode.text = @"Enter PIN Code";
    [lableCode setTextColor:[UIColor colorWithRed:69/255.0 green:139/255.0 blue:0 alpha:1]];
//    lableCode.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:lableCode];
    
    pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(40, 100, bgView.frame.size.width - 80, 45)];
    [bgView addSubview:pasView];
    [self.view addSubview:bgView];
    
    [CQHud LoadingShow];
    loadIsShow = YES;

    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    sensor.callBackBlock = ^(NSString *text) {
        if (text.length>=18) {
            NSString *str = [text substringWithRange:NSMakeRange(6, 4)];
            if ([str isEqualToString:@"0003"]) {
                NSString *pwd = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, 8)]];
                defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:pwd forKey:@"pinCode"];
                [defaults synchronize];
                [CQHud LoadingDismiss];
                loadIsShow = NO;
                [pasView.textField becomeFirstResponder];
            }
        }
       
        
    };
    
    pasView.callBackBlock = ^(NSString *text) {
        NSString *strPwd = [defaults objectForKey:@"pinCode"];
        if (text.length == 4) {
            if ([text isEqualToString:strPwd]) {
                ViewController *controller = [[ViewController alloc]init];
                controller.peripheral = peripheral;
                controller.sensor = sensor;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                alert = [UIAlertController alertControllerWithTitle:@"prompt:" message:@"password is wrong!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action) {
                                                                         [pasView clearUpPassword];
                                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                                         alert = nil;
                                                                     }];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    };
    
}

-(void)dismissLoading
{
    if (loadIsShow) {
        [self.view makeToast:@"Get data error"];
        [CQHud LoadingDismiss];
        [self.navigationController popViewControllerAnimated:YES];
        loadIsShow = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
