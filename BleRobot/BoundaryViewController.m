//
//  BoundaryViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/8.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "BoundaryViewController.h"
#import "BleUtils.h"
#import "CQHud.h"
@interface BoundaryViewController ()<WidthAlerViewDelegaet>

@end

@implementation BoundaryViewController
@synthesize sensor;
@synthesize peripheral;
@synthesize lableWidh;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Boundary"];
    [self createView];
//self.sensor.delegate=self;
    [self sendData];
}

-(void)sendData
{
    NSString *strTrim = @"55AA020006";
    NSString *str =[strTrim stringByAppendingString:[BleUtils makeCheckSum:strTrim]];
    [sensor write:peripheral value:str];
    
    widthThread = [[NSThread alloc]initWithTarget:self selector:@selector(sendWidth) object:nil];
    [widthThread start];
    
    signalThread = [[NSThread alloc]initWithTarget:self selector:@selector(sendSignal) object:nil];
    [signalThread start];
}
-(void)sendWidth
{
     [NSThread sleepForTimeInterval:0.5];
    NSString *strWidth = @"55AA020008";
    NSString *str =[strWidth stringByAppendingString:[BleUtils makeCheckSum:strWidth]];
    [sensor write:peripheral value:str];
}

-(void)sendSignal
{
     [NSThread sleepForTimeInterval:1];
    NSString *strSignal = @"55AA02000A";
    NSString *str =[strSignal stringByAppendingString:[BleUtils makeCheckSum:strSignal]];
    [sensor write:peripheral value:str];
    
    [CQHud LoadingShow];
    loadIsShow = YES;
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
}
-(void)createView
{
    //创建trimming
    UIView *trimView = [[UIView alloc]init];
    trimView.frame = CGRectMake(5,5,self.view.frame.size.width-10,50);
    trimView.backgroundColor = [UIColor whiteColor];
    trimView.layer.cornerRadius = 5;
    trimView.layer.masksToBounds = YES;
    trimView.layer.shadowColor = [UIColor blackColor].CGColor;
    trimView.layer.shadowOffset = CGSizeMake(4, 4);
    trimView.layer.shadowRadius=3;
    trimView.layer.shadowOpacity = 1;
    
    UIImageView *imageTrim = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"trim"]];
    imageTrim.frame = CGRectMake(30, 10, 30, 30);
    [trimView addSubview:imageTrim];
    
    UILabel *lableT = [[UILabel alloc]init];
    lableT.frame = CGRectMake(80, 0, 200, 50);
    lableT.font = [UIFont systemFontOfSize:14];
    lableT.textAlignment = NSTextAlignmentLeft;
    [lableT setTextColor:[UIColor blackColor]];
    [lableT setText:@"Trimming"];
    [trimView addSubview:lableT];
    
    lableTrim= [[UILabel alloc]init];
    lableTrim.frame = CGRectMake(trimView.frame.size.width*13/15, 0, 100, trimView.frame.size.height);
    lableTrim.font = [UIFont systemFontOfSize:12];
    [lableTrim setTextColor:[UIColor lightGrayColor]];
    [lableTrim setText:@"YES"];
    [trimView addSubview:lableTrim];
    
    UIImageView *imageMoreTrim = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreTrim.frame = CGRectMake(trimView.frame.size.width*14/15, 15, 20, 20);
    [trimView addSubview:imageMoreTrim];
    
    trimView.userInteractionEnabled = YES;
    UITapGestureRecognizer *trimTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTrim)];
    [trimView addGestureRecognizer:trimTap];
    [trimTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:trimView];
    
    //创建width
    UIView *widthView = [[UIView alloc]init];
    widthView.frame = CGRectMake(5,60,self.view.frame.size.width-10,50);
    widthView.backgroundColor = [UIColor whiteColor];
    widthView.layer.cornerRadius = 5;
    widthView.layer.masksToBounds = YES;
    widthView.layer.shadowColor = [UIColor blackColor].CGColor;
    widthView.layer.shadowOffset = CGSizeMake(4, 4);
    widthView.layer.shadowRadius=3;
    widthView.layer.shadowOpacity = 1;
    
    UIImageView *imageWidth = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"width"]];
    imageWidth.frame = CGRectMake(30, 10, 30, 30);
    [widthView addSubview:imageWidth];
    
    UILabel *lableW = [[UILabel alloc]init];
    lableW.frame = CGRectMake(80, 0, 200, 50);
    lableW.font = [UIFont systemFontOfSize:14];
    lableW.textAlignment = NSTextAlignmentLeft;
    [lableW setTextColor:[UIColor blackColor]];
    [lableW setText:@"Width"];
    [widthView addSubview:lableW];
    
    lableWidh= [[UILabel alloc]init];
    lableWidh.frame = CGRectMake(widthView.frame.size.width*13/15, 0, 100, widthView.frame.size.height);
    lableWidh.font = [UIFont systemFontOfSize:12];
    [lableWidh setTextColor:[UIColor lightGrayColor]];
    [lableWidh setText:@"0.2"];
    [widthView addSubview:lableWidh];
    
    UIImageView *imageMoreWidth = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreWidth.frame = CGRectMake(widthView.frame.size.width*14/15, 15, 20, 20);
    [widthView addSubview:imageMoreWidth];
    
    widthView.userInteractionEnabled = YES;
    UITapGestureRecognizer *widthTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressWidth)];
    [widthView addGestureRecognizer:widthTap];
    [widthTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:widthView];
    
    //创建width
    UIView *signalView = [[UIView alloc]init];
    signalView.frame = CGRectMake(5,115,self.view.frame.size.width-10,50);
    signalView.backgroundColor = [UIColor whiteColor];
    signalView.layer.cornerRadius = 5;
    signalView.layer.masksToBounds = YES;
    signalView.layer.shadowColor = [UIColor blackColor].CGColor;
    signalView.layer.shadowOffset = CGSizeMake(4, 4);
    signalView.layer.shadowRadius=3;
    signalView.layer.shadowOpacity = 1;
    
    UIImageView *imageSignal = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"single"]];
    imageSignal.frame = CGRectMake(30, 10, 30, 30);
    [signalView addSubview:imageSignal];
    
    UILabel *lableS = [[UILabel alloc]init];
    lableS.frame = CGRectMake(80, 0, 200, 50);
    lableS.font = [UIFont systemFontOfSize:14];
    lableS.textAlignment = NSTextAlignmentLeft;
    [lableS setTextColor:[UIColor blackColor]];
    [lableS setText:@"Signal"];
    [signalView addSubview:lableS];
    
    lableSinal= [[UILabel alloc]init];
    lableSinal.frame = CGRectMake(signalView.frame.size.width*13/15, 0, 100, signalView.frame.size.height);
    lableSinal.font = [UIFont systemFontOfSize:12];
    [lableSinal setTextColor:[UIColor lightGrayColor]];
    [lableSinal setText:@"S1"];
    [signalView addSubview:lableSinal];
    
    UIImageView *imageMoreSignal = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreSignal.frame = CGRectMake(signalView.frame.size.width*14/15, 15, 20, 20);
    [signalView addSubview:imageMoreSignal];
    
    signalView.userInteractionEnabled = YES;
    UITapGestureRecognizer *signalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressSignal)];
    [signalView addGestureRecognizer:signalTap];
    [signalTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:signalView];

}

-(void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        if (widthThread!=nil) {
            [widthThread cancel];
        }
        
        if (signalThread!=nil) {
            [signalThread cancel];
        }
    }
    
}

-(void)pressTrim
{
    NSLog(@"点击trim");
    alertTrim = [UIAlertController alertControllerWithTitle:@"prompt:" message:@"Boundary Trimming" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSString *strNum  = @"55AA03000701";
                                                              NSString *str = [strNum stringByAppendingString:[BleUtils makeCheckSum:strNum]];
                                                              [sensor write:peripheral value:str];
                                                              lableTrim.text=@"YES";
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             NSString *strNum  = @"55AA03000700";
                                                             NSString *str = [strNum stringByAppendingString:[BleUtils makeCheckSum:strNum]];
                                                             [sensor write:peripheral value:str];
                                                             lableTrim.text=@"NO";
                                                         }];
    [alertTrim addAction:cancelAction];
    [alertTrim addAction:defaultAction];
    [self presentViewController:alertTrim animated:YES completion:nil];
}

-(void)pressWidth
{
    NSLog(@"点击width");
    widthAlert = [[WidthAlertView alloc]initWithTitle:lableWidh.text  delegate:self leftButtonTitle:@"CANCEL" rightButtonTitle:@"YES"];
    [widthAlert show];
}
-(void)declareAbnormalAlertView:(WidthAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == AlertButtonRight) {
        NSString *text = alertView.strChooseNum;
        NSString *width = @"02";
        NSString *widthStr = @"0.2";
        if ([text isEqualToString:@"2"]) {
            width = @"02";
            widthStr = @"0.2";
        }else  if ([text isEqualToString:@"3"]) {
            width = @"03";
            widthStr = @"0.3";
        }else  if ([text isEqualToString:@"4"]) {
            width = @"04";
            widthStr = @"0.4";
        }else  if ([text isEqualToString:@"5"]) {
            width = @"05";
            widthStr = @"0.5";
        }
        
        NSString *strText = [@"55AA030009" stringByAppendingString:width] ;
        NSString *str = [strText stringByAppendingString:[BleUtils makeCheckSum:strText]];
        [sensor write:peripheral value:str];
        lableWidh.text = widthStr;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getData];
}
-(void)pressSignal
{
    NSLog(@"点击signal");
    alertSignal = [UIAlertController alertControllerWithTitle:@"prompt:" message:@"Boundary Trimming" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"S2" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSString *strNum  = @"55AA03000B02";
                                                              NSString *str = [strNum stringByAppendingString:[BleUtils makeCheckSum:strNum]];
                                                              [sensor write:peripheral value:str];
                                                              lableSinal.text=@"S2";
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"S1" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             NSString *strNum  = @"55AA03000B01";
                                                             NSString *str = [strNum stringByAppendingString:[BleUtils makeCheckSum:strNum]];
                                                             [sensor write:peripheral value:str];
                                                             lableSinal.text=@"S1";
                                                         }];
    [alertSignal addAction:cancelAction];
    [alertSignal addAction:defaultAction];
    [self presentViewController:alertSignal animated:YES completion:nil];
}

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
        if (text.length >= 10) {
            if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0006"]) {
                if (text.length>=12) {
                    NSString *strTrim = [text substringWithRange:NSMakeRange(10, 2)];
                    if ([strTrim isEqualToString:@"00"]) {
                        lableTrim.text = @"NO";
                    }else if ([strTrim isEqualToString:@"01"]){
                        lableTrim.text = @"YES";
                    }
                }
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0008"]){
                if (text.length>=12) {
                    NSString *strWidth =[text substringWithRange:NSMakeRange(10, 2)];
                    if ([strWidth isEqualToString:@"02"]) {
                        lableWidh.text = @"0.2";
                    }else if ([strWidth isEqualToString:@"03"]) {
                        lableWidh.text = @"0.3";
                    }else if ([strWidth isEqualToString:@"04"]) {
                        lableWidh.text = @"0.4";
                    }else if ([strWidth isEqualToString:@"05"]) {
                        lableWidh.text = @"0.5";
                    }
                }
                
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"000a"]){
                 if (text.length>=12) {
                      NSString *strSiganl =[text substringWithRange:NSMakeRange(10, 2)];
                     if ([strSiganl isEqualToString:@"01"]) {
                         lableSinal.text = @"S1";
                     }else if ([strSiganl isEqualToString:@"02"]){
                         lableSinal.text = @"S2";
                     }
                     [CQHud LoadingDismiss];
                     loadIsShow = NO;
                 }
            }
        }
    };
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
