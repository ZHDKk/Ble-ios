//
//  DateViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/8.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "DateViewController.h"
#import "XHDatePickerView.h"
#import "NSDate+XHExtension.h"
#import "BleUtils.h"
#import "CQHud.h"

@interface DateViewController ()

@end

@implementation DateViewController
@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Time and Date"];
    [self createView];
//     self.sensor.delegate = self;
    
    [self sendData];
    [self getData];
    loadIsShow = YES;
}

-(void)sendData
{
    NSString *strDate = @"55AA02001B";
    NSString *str =[strDate stringByAppendingString:[BleUtils makeCheckSum:strDate]];
    [sensor write:peripheral value:str];
    thread = [[NSThread alloc]initWithTarget:self selector:@selector(sendTime) object:nil];
    [thread start];
    
}
-(void)sendTime
{
    [NSThread sleepForTimeInterval:0.5];
    NSString *strTime = @"55AA02001D";
    NSString *str =[strTime stringByAppendingString:[BleUtils makeCheckSum:strTime]];
    [sensor write:peripheral value:str];
    [CQHud LoadingShow];
    loadIsShow = YES;
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
}
-(void)createView
{
    //创建date
    UIView *dateView = [[UIView alloc]init];
    dateView.frame = CGRectMake(5,5,self.view.frame.size.width-10,50);
    dateView.backgroundColor = [UIColor whiteColor];
    dateView.layer.cornerRadius = 5;
    dateView.layer.masksToBounds = YES;
    dateView.layer.shadowColor = [UIColor blackColor].CGColor;
    dateView.layer.shadowOffset = CGSizeMake(4, 4);
    dateView.layer.shadowRadius=3;
    dateView.layer.shadowOpacity = 1;
    
    UIImageView *imageCd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"calendar"]];
    imageCd.frame = CGRectMake(30, 10, 30, 30);
    [dateView addSubview:imageCd];
    
    UILabel *lableCd = [[UILabel alloc]init];
    lableCd.frame = CGRectMake(80, 0, 200, 50);
    lableCd.font = [UIFont systemFontOfSize:14];
    lableCd.textAlignment = NSTextAlignmentLeft;
    [lableCd setTextColor:[UIColor blackColor]];
    [lableCd setText:@"Date"];
    [dateView addSubview:lableCd];
    
    lableDate = [[UILabel alloc]init];
    lableDate.frame = CGRectMake(dateView.frame.size.width*11/15, 0, 100, dateView.frame.size.height);
    lableDate.font = [UIFont systemFontOfSize:12];
    [lableDate setTextColor:[UIColor lightGrayColor]];
    [lableDate setText:@"2017.01.01"];
    [dateView addSubview:lableDate];
    
    UIImageView *imageMoreCd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreCd.frame = CGRectMake(dateView.frame.size.width*14/15, 15, 20, 20);
    [dateView addSubview:imageMoreCd];
    
    dateView.userInteractionEnabled = YES;
    UITapGestureRecognizer *CdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressCd)];
    [dateView addGestureRecognizer:CdTap];
    [CdTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:dateView];
    
    //创建time
    UIView *timeView = [[UIView alloc]init];
    timeView.frame = CGRectMake(5,60,self.view.frame.size.width-10,50);
    timeView.backgroundColor = [UIColor whiteColor];
    timeView.layer.cornerRadius = 5;
    timeView.layer.masksToBounds = YES;
    timeView.layer.shadowColor = [UIColor blackColor].CGColor;
    timeView.layer.shadowOffset = CGSizeMake(4, 4);
    timeView.layer.shadowRadius=3;
    timeView.layer.shadowOpacity = 1;
    
    UIImageView *imageT = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"times"]];
    imageT.frame = CGRectMake(30, 10, 30, 30);
    [timeView addSubview:imageT];
    
    UILabel *lableT = [[UILabel alloc]init];
    lableT.frame = CGRectMake(80, 0, 200, 50);
    lableT.font = [UIFont systemFontOfSize:14];
    lableT.textAlignment = NSTextAlignmentLeft;
    [lableT setTextColor:[UIColor blackColor]];
    [lableT setText:@"Time"];
    [timeView addSubview:lableT];
    
    lableTime = [[UILabel alloc]init];
    lableTime.frame = CGRectMake(timeView.frame.size.width*12/15, 0, 100, timeView.frame.size.height);
    lableTime.font = [UIFont systemFontOfSize:12];
    [lableTime setTextColor:[UIColor lightGrayColor]];
    [lableTime setText:@"00:00"];
    [timeView addSubview:lableTime];
    
    UIImageView *imageMoreT = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreT.frame = CGRectMake(timeView.frame.size.width*14/15, 15, 20, 20);
    [timeView addSubview:imageMoreT];
    
    timeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTime)];
    [timeView addGestureRecognizer:timeTap];
    [timeTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:timeView];


}

-(void)pressCd
{
    XHDateStyle dateStyle =DateStyleShowYearMonthDay;
    NSString *format=  @"yyyy.MM.dd";
    XHDatePickerView *datepicker = [[XHDatePickerView alloc]initWithCurrentDate:[NSDate date] CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
        NSString *strDate =[startDate stringWithFormat:format];
        NSString *strToHex = [BleUtils convertStringToHexStr:strDate];
        NSString *strSum = [@"55AA0C001C" stringByAppendingString:strToHex];
        NSString *str = [strSum stringByAppendingString:[BleUtils makeCheckSum:strSum]];
        [sensor write:peripheral value:str];
        lableDate.text =strDate;
        
    }];
    
    datepicker.datePickerStyle = dateStyle;
    datepicker.dateType = DateTypeStartDate;
    datepicker.segmentView.hidden = YES;
    datepicker.minLimitDate = [NSDate date:@"2017.2.28 12:22" WithFormat:@"yyyy.MM.dd HH:mm"];
    datepicker.maxLimitDate = [NSDate date:@"2018.2.28 12:12" WithFormat:@"yyyy.MM.dd HH:mm"];
    [datepicker show];
}

-(void)pressTime
{
    NSLog(@"点击Time");
    
    XHDateStyle dateStyle =DateStyleShowHourMinute;
    NSString *format=  @"HH:mm";
    XHDatePickerView *datepicker = [[XHDatePickerView alloc]initWithCurrentDate:[NSDate date] CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
        NSString *strTime =[startDate stringWithFormat:format];
        NSString *strToHex = [BleUtils convertStringToHexStr:strTime];
        NSString *strSum = [@"55AA07001E" stringByAppendingString:strToHex];
        NSString *str = [strSum stringByAppendingString:[BleUtils makeCheckSum:strSum]];
        [sensor write:peripheral value:str];
        lableTime.text =strTime;
        
    }];
    
    datepicker.datePickerStyle = dateStyle;
    datepicker.dateType = DateTypeStartDate;
    datepicker.segmentView.hidden = YES;
    datepicker.minLimitDate = [NSDate date:@"2017.2.28 12:22" WithFormat:@"yyyy.MM.dd HH:mm"];
    datepicker.maxLimitDate = [NSDate date:@"2018.2.28 12:12" WithFormat:@"yyyy.MM.dd HH:mm"];
    [datepicker show];
    
}

-(void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    if (!parent) {
        if (thread!=nil) {
            [thread cancel];
        }
    }
    
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
        if(text.length>=10){
            if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0019"]) {
                if (text.length>=30) {
                    NSString *strDate = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, 20)]];
                    lableDate.text = strDate;
                }
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"001b"]){
                if (text.length>=20) {
                     NSString *strTime = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, 10)]];
                    lableTime.text = strTime;
                    if (loadIsShow) {
                        [CQHud LoadingDismiss];
                        loadIsShow = NO;
                    }
                   
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
