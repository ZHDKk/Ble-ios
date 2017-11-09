//
//  SetViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/8.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "SetViewController.h"
#import "BoundaryViewController.h"
#import "PinViewController.h"
#import "MultiViewController.h"
#import "BleUtils.h"
#import "CQHud.h"
#import "SetDeviceNameViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController
@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Setting"];
    [self createView];
//    self.sensor.delegate=self;
    
    NSString *strRain = @"55AA020022";
    NSString *str =[strRain stringByAppendingString:[BleUtils makeCheckSum:strRain]];
    [sensor write:peripheral value:str];
    [CQHud LoadingShow];
    loadIsShow = YES;
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    [self getData];
}

-(void)createView
{
    //创建boundary
    UIView *boundaryView = [[UIView alloc]init];
    boundaryView.frame = CGRectMake(5,5,self.view.frame.size.width-10,50);
    boundaryView.backgroundColor = [UIColor whiteColor];
    boundaryView.layer.cornerRadius = 5;
    boundaryView.layer.masksToBounds = YES;
    boundaryView.layer.shadowColor = [UIColor blackColor].CGColor;
    boundaryView.layer.shadowOffset = CGSizeMake(4, 4);
    boundaryView.layer.shadowRadius=3;
    boundaryView.layer.shadowOpacity = 1;
    
    UIImageView *imagebdv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"boundary"]];
    imagebdv.frame = CGRectMake(30, 10, 30, 30);
    [boundaryView addSubview:imagebdv];
    
    UILabel *lablebdv = [[UILabel alloc]init];
    lablebdv.frame = CGRectMake(80, 0, 200, 50);
    lablebdv.font = [UIFont systemFontOfSize:14];
    lablebdv.textAlignment = NSTextAlignmentLeft;
    [lablebdv setTextColor:[UIColor blackColor]];
    [lablebdv setText:@"Boundary"];
    [boundaryView addSubview:lablebdv];
    

    
    UIImageView *imageMoreBdv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreBdv.frame = CGRectMake(boundaryView.frame.size.width*14/15, 15, 20, 20);
    [boundaryView addSubview:imageMoreBdv];
    
    boundaryView.userInteractionEnabled = YES;
    UITapGestureRecognizer *bdvTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressBdv)];
    [boundaryView addGestureRecognizer:bdvTap];
    [bdvTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:boundaryView];
    
    //创建pin
    UIView *pinView = [[UIView alloc]init];
    pinView.frame = CGRectMake(5,60,self.view.frame.size.width-10,50);
    pinView.backgroundColor = [UIColor whiteColor];
    pinView.layer.cornerRadius = 5;
    pinView.layer.masksToBounds = YES;
    pinView.layer.shadowColor = [UIColor blackColor].CGColor;
    pinView.layer.shadowOffset = CGSizeMake(4, 4);
    pinView.layer.shadowRadius=3;
    pinView.layer.shadowOpacity = 1;
    
    UIImageView *imagePin = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pin"]];
    imagePin.frame = CGRectMake(30, 10, 30, 30);
    [pinView addSubview:imagePin];
    
    UILabel *lablePin = [[UILabel alloc]init];
    lablePin.frame = CGRectMake(80, 0, 200, 50);
    lablePin.font = [UIFont systemFontOfSize:14];
    lablePin.textAlignment = NSTextAlignmentLeft;
    [lablePin setTextColor:[UIColor blackColor]];
    [lablePin setText:@"PIN"];
    [pinView addSubview:lablePin];
    
    
    UIImageView *imageMorePin = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMorePin.frame = CGRectMake(pinView.frame.size.width*14/15, 15, 20, 20);
    [pinView addSubview:imageMorePin];
    
    pinView.userInteractionEnabled = YES;
    UITapGestureRecognizer *pinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPin)];
    [pinView addGestureRecognizer:pinTap];
    [pinTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:pinView];
    
    //创建rain
    UIView *rainView = [[UIView alloc]init];
    rainView.frame = CGRectMake(5,115,self.view.frame.size.width-10,50);
    rainView.backgroundColor = [UIColor whiteColor];
    rainView.layer.cornerRadius = 5;
    rainView.layer.masksToBounds = YES;
    rainView.layer.shadowColor = [UIColor blackColor].CGColor;
    rainView.layer.shadowOffset = CGSizeMake(4, 4);
    rainView.layer.shadowRadius=3;
    rainView.layer.shadowOpacity = 1;
    
    UIImageView *imageRain = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rain"]];
    imageRain.frame = CGRectMake(30, 10, 30, 30);
    [rainView addSubview:imageRain];
    
    UILabel *lableRain = [[UILabel alloc]init];
    lableRain.frame = CGRectMake(80, 0, 200, 50);
    lableRain.font = [UIFont systemFontOfSize:14];
    lableRain.textAlignment = NSTextAlignmentLeft;
    [lableRain setTextColor:[UIColor blackColor]];
    [lableRain setText:@"Rain"];
    [rainView addSubview:lableRain];
    
    lableR= [[UILabel alloc]init];
    lableR.frame = CGRectMake(rainView.frame.size.width*13/15, 0, 100, rainView.frame.size.height);
    lableR.font = [UIFont systemFontOfSize:12];
    [lableR setTextColor:[UIColor lightGrayColor]];
    [lableR setText:@"OFF"];
    [rainView addSubview:lableR];
    
    UIImageView *imageMoreRain = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreRain.frame = CGRectMake(rainView.frame.size.width*14/15, 15, 20, 20);
    [rainView addSubview:imageMoreRain];
    
    rainView.userInteractionEnabled = YES;
    UITapGestureRecognizer *rainTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressRain)];
    [rainView addGestureRecognizer:rainTap];
    [rainTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:rainView];
    
    //创建multi
    UIView *multiView = [[UIView alloc]init];
    multiView.frame = CGRectMake(5,170,self.view.frame.size.width-10,50);
    multiView.backgroundColor = [UIColor whiteColor];
    multiView.layer.cornerRadius = 5;
    multiView.layer.masksToBounds = YES;
    multiView.layer.shadowColor = [UIColor blackColor].CGColor;
    multiView.layer.shadowOffset = CGSizeMake(4, 4);
    multiView.layer.shadowRadius=3;
    multiView.layer.shadowOpacity = 1;
    
    UIImageView *multiPin = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"multi"]];
    multiPin.frame = CGRectMake(30, 10, 30, 30);
    [multiView addSubview:multiPin];
    
    UILabel *lableMulti = [[UILabel alloc]init];
    lableMulti.frame = CGRectMake(80, 0, 200, 50);
    lableMulti.font = [UIFont systemFontOfSize:14];
    lableMulti.textAlignment = NSTextAlignmentLeft;
    [lableMulti setTextColor:[UIColor blackColor]];
    [lableMulti setText:@"Multi-Area"];
    [multiView addSubview:lableMulti];
    
    
    UIImageView *imageMoreMulti = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreMulti.frame = CGRectMake(multiView.frame.size.width*14/15, 15, 20, 20);
    [multiView addSubview:imageMoreMulti];
    
    multiView.userInteractionEnabled = YES;
    UITapGestureRecognizer *multiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressMulti)];
    [multiView addGestureRecognizer:multiTap];
    [multiTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:multiView];
    
    //创建reset
    UIView *resetView = [[UIView alloc]init];
    resetView.frame = CGRectMake(5,225,self.view.frame.size.width-10,50);
    resetView.backgroundColor = [UIColor whiteColor];
    resetView.layer.cornerRadius = 5;
    resetView.layer.masksToBounds = YES;
    resetView.layer.shadowColor = [UIColor blackColor].CGColor;
    resetView.layer.shadowOffset = CGSizeMake(4, 4);
    resetView.layer.shadowRadius=3;
    resetView.layer.shadowOpacity = 1;
    
    UIImageView *resetPin = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reset"]];
    resetPin.frame = CGRectMake(30, 10, 30, 30);
    [resetView addSubview:resetPin];
    
    UILabel *lableReset = [[UILabel alloc]init];
    lableReset.frame = CGRectMake(80, 0, 200, 50);
    lableReset.font = [UIFont systemFontOfSize:14];
    lableReset.textAlignment = NSTextAlignmentLeft;
    [lableReset setTextColor:[UIColor blackColor]];
    [lableReset setText:@"All Reset"];
    [resetView addSubview:lableReset];
    
    
    UIImageView *imageMoreReset = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreReset.frame = CGRectMake(resetView.frame.size.width*14/15, 15, 20, 20);
    [resetView addSubview:imageMoreReset];
    
    resetView.userInteractionEnabled = YES;
    UITapGestureRecognizer *resetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressReset)];
    [resetView addGestureRecognizer:resetTap];
    [resetTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:resetView];
    
    //创建reset
    UIView *reView = [[UIView alloc]init];
    reView.frame = CGRectMake(5,280,self.view.frame.size.width-10,50);
    reView.backgroundColor = [UIColor whiteColor];
    reView.layer.cornerRadius = 5;
    reView.layer.masksToBounds = YES;
    reView.layer.shadowColor = [UIColor blackColor].CGColor;
    reView.layer.shadowOffset = CGSizeMake(4, 4);
    reView.layer.shadowRadius=3;
    reView.layer.shadowOpacity = 1;
    
    UIImageView *rePin = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"review"]];
    rePin.frame = CGRectMake(30, 10, 40, 30);
    [reView addSubview:rePin];
    
    UILabel *lableRe = [[UILabel alloc]init];
    lableRe.frame = CGRectMake(80, 0, 200, 50);
    lableRe.font = [UIFont systemFontOfSize:14];
    lableRe.textAlignment = NSTextAlignmentLeft;
    [lableRe setTextColor:[UIColor blackColor]];
    [lableRe setText:@"Set Device Name"];
    [reView addSubview:lableRe];
    
    
    UIImageView *imageMoreRe = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreRe.frame = CGRectMake(reView.frame.size.width*14/15, 15, 20, 20);
    [reView addSubview:imageMoreRe];
    
    reView.userInteractionEnabled = YES;
    UITapGestureRecognizer *reTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressReview)];
    [reView addGestureRecognizer:reTap];
    [reTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:reView];



}

-(void)pressBdv
{
    NSLog(@"点击boundary");
    BoundaryViewController *bc = [[BoundaryViewController alloc]init];
    bc.sensor=sensor;
    bc.peripheral = peripheral;
    [self.navigationController pushViewController:bc animated:YES];
}

-(void)pressPin
{
    NSLog(@"点击pin");
    PinViewController *pc  = [[PinViewController alloc]init];
    pc.peripheral = peripheral;
    pc.sensor = sensor;
    [self.navigationController pushViewController:pc animated:YES];
}
-(void)pressRain{
    NSLog(@"点击rain");
    alertRain = [UIAlertController alertControllerWithTitle:@"prompt:" message:@"Boundary Trimming" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OFF" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSString *strNum  = @"55AA03002302";
                                                              NSString *str = [strNum stringByAppendingString:[BleUtils makeCheckSum:strNum]];
                                                              [sensor write:peripheral value:str];
                                                              lableR.text = @"OFF";
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"ON" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             NSString *strNum  = @"55AA03002301";
                                                             NSString *str = [strNum stringByAppendingString:[BleUtils makeCheckSum:strNum]];
                                                             [sensor write:peripheral value:str];
                                                             lableR.text = @"ON";
                                                         }];
    [alertRain addAction:cancelAction];
    [alertRain addAction:defaultAction];
    [self presentViewController:alertRain animated:YES completion:nil];
}
-(void)pressMulti
{
    NSLog(@"点击multi");
    
    MultiViewController *mc= [[MultiViewController alloc]init];
    mc.peripheral = peripheral;
    mc.sensor = sensor;
    [self.navigationController pushViewController:mc animated:YES];
}
-(void)pressReset
{
    NSLog(@"点击reset");
    alertReset = [UIAlertController alertControllerWithTitle:@"prompt:" message:@"Boundary Trimming" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSString *strNum  = @"55AA02000F";
                                                              NSString *str = [strNum stringByAppendingString:[BleUtils makeCheckSum:strNum]];
                                                              [sensor write:peripheral value:str];
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [alertReset dismissViewControllerAnimated:YES completion:nil];
                                                             alertReset = nil;
                                                         }];
    [alertReset addAction:cancelAction];
    [alertReset addAction:defaultAction];
    [self presentViewController:alertReset animated:YES completion:nil];
}
-(void)pressReview
{
    NSLog(@"点击review");
    
    SetDeviceNameViewController *sc  = [[SetDeviceNameViewController alloc]init];
    sc.peripheral = peripheral;
    sc.sensor = sensor;
    [self.navigationController pushViewController:sc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    loadIsShow = YES;
//    [self getData];
//}

-(void)dismissLoading
{
    if (loadIsShow) {
        [self.view makeToast:@"Get data error"];
        [CQHud LoadingDismiss];
        loadIsShow = NO;
    }
}

-(void)getData
{
    sensor.callBackBlock = ^(NSString *text) {
        if (text.length>=10) {
            if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0020"]) {
                [CQHud LoadingDismiss];
                loadIsShow = NO;
                if (text.length>=12) {
                    NSString *strStatus = [text substringWithRange:NSMakeRange(10, 2)];
                    if ([strStatus isEqualToString:@"01"]) {
                        lableR.text = @"ON";
                    }else if([strStatus isEqualToString:@"02"]){
                        lableR.text = @"OFF";
                    }
                }
            }else if([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"000f"]){
                [self performSelector:@selector(reSendRain) withObject:nil afterDelay:1];
                
            }
        }
    };
}

-(void)reSendRain{
    NSString *strRain = @"55AA020022";
    NSString *str =[strRain stringByAppendingString:[BleUtils makeCheckSum:strRain]];
    [sensor write:peripheral value:str];
    [CQHud LoadingShow];
    loadIsShow = YES;
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
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
