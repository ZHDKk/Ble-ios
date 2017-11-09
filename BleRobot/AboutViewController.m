//
//  AboutViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/12.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "AboutViewController.h"
#import "WebViewController.h"
#import "BleUtils.h"
#import "CQHud.h"
@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"About"];
    [self createView];
    [self sendData];
    [self getData];
}

-(void)sendData
{
    NSString *strSf = @"55AA020001";
    NSString *str =[strSf stringByAppendingString:[BleUtils makeCheckSum:strSf]];
    [sensor write:peripheral value:str];
    
    [self performSelector:@selector(sendSn) withObject:nil afterDelay:0.5];
}
-(void)sendSn
{
    NSString *strSn = @"55AA020002";
    NSString *str =[strSn stringByAppendingString:[BleUtils makeCheckSum:strSn]];
    [sensor write:peripheral value:str];
    
    [CQHud LoadingShow];
    loadIsShow = YES;
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
}
-(void)createView
{
    UIImageView *imageLogo = [[UIImageView alloc]init];
    imageLogo.frame = CGRectMake(self.view.frame.size.width/2-30, self.view.frame.size.height/2-250, 60, 60);
    imageLogo.image = [UIImage imageNamed:@"test"];
    
    UILabel *lableVersion = [[UILabel alloc]init];
    [lableVersion setText:@"version 1.0"];
    [lableVersion setFont:[UIFont systemFontOfSize:14]];
    lableVersion.frame = CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-190, 100, 40);
    lableVersion.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lableVersion];
    [self.view addSubview:imageLogo];
    
    //创建softwrae
    UIView *softView = [[UIView alloc]init];
    softView.frame = CGRectMake(5,240,self.view.frame.size.width-10,50);
    softView.backgroundColor = [UIColor whiteColor];
    softView.layer.cornerRadius = 5;
    softView.layer.masksToBounds = YES;
    softView.layer.shadowColor = [UIColor blackColor].CGColor;
    softView.layer.shadowOffset = CGSizeMake(4, 4);
    softView.layer.shadowRadius=3;
    softView.layer.shadowOpacity = 1;
    
    UILabel *lableSoft = [[UILabel alloc]init];
    lableSoft.frame = CGRectMake(30, 0, 200, 50);
    lableSoft.font = [UIFont systemFontOfSize:14];
    lableSoft.textAlignment = NSTextAlignmentLeft;
    [lableSoft setTextColor:[UIColor blackColor]];
    [lableSoft setText:@"SoftWare Version"];
    [softView addSubview:lableSoft];
    
    softText = [[UILabel alloc]init];
    softText.frame =CGRectMake(softView.frame.size.width*1/2, 15, 170, 20);
    softText.font = [UIFont systemFontOfSize:14];
    softText.textAlignment = NSTextAlignmentRight;
    [softText setTextColor:[UIColor blackColor]];
    [softView addSubview:softText];
    [self.view addSubview:softView];
    
    //创建sn
    UIView *snView = [[UIView alloc]init];
    snView.frame = CGRectMake(5,295,self.view.frame.size.width-10,50);
    snView.backgroundColor = [UIColor whiteColor];
    snView.layer.cornerRadius = 5;
    snView.layer.masksToBounds = YES;
    snView.layer.shadowColor = [UIColor blackColor].CGColor;
    snView.layer.shadowOffset = CGSizeMake(4, 4);
    snView.layer.shadowRadius=3;
    snView.layer.shadowOpacity = 1;
    
    UILabel *lableSn = [[UILabel alloc]init];
    lableSn.frame = CGRectMake(30, 0, 200, 50);
    lableSn.font = [UIFont systemFontOfSize:14];
    lableSn.textAlignment = NSTextAlignmentLeft;
    [lableSn setTextColor:[UIColor blackColor]];
    [lableSn setText:@"SN"];
    [snView addSubview:lableSn];
    
    snText = [[UILabel alloc]init];
    snText.frame =CGRectMake(softView.frame.size.width*1/2, 15, 170, 20);
    snText.font = [UIFont systemFontOfSize:14];
    snText.textAlignment = NSTextAlignmentRight;
    [snText setTextColor:[UIColor blackColor]];
    [snView addSubview:snText];
    [self.view addSubview:snView];
    
    //创建website
    UIView *webView = [[UIView alloc]init];
    webView.frame = CGRectMake(5,350,self.view.frame.size.width-10,50);
    webView.backgroundColor = [UIColor whiteColor];
    webView.layer.cornerRadius = 5;
    webView.layer.masksToBounds = YES;
    webView.layer.shadowColor = [UIColor blackColor].CGColor;
    webView.layer.shadowOffset = CGSizeMake(4, 4);
    webView.layer.shadowRadius=3;
    webView.layer.shadowOpacity = 1;
    
//    UIImageView *webPin = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"review"]];
//    webPin.frame = CGRectMake(30, 10, 40, 30);
//    [webView addSubview:webPin];
    
    UILabel *lableRe = [[UILabel alloc]init];
    lableRe.frame = CGRectMake(30, 0, 200, 50);
    lableRe.font = [UIFont systemFontOfSize:14];
    lableRe.textAlignment = NSTextAlignmentLeft;
    [lableRe setTextColor:[UIColor blackColor]];
    [lableRe setText:@"Offical website"];
    [webView addSubview:lableRe];
    
    
    UIImageView *imageMoreRe = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    imageMoreRe.frame = CGRectMake(webView.frame.size.width*14/15, 15, 20, 20);
    [webView addSubview:imageMoreRe];
    
    webView.userInteractionEnabled = YES;
    UITapGestureRecognizer *reTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressWebView)];
    [webView addGestureRecognizer:reTap];
    [reTap setNumberOfTouchesRequired:1];
    
    [self.view addSubview:webView];

}

-(void)pressWebView
{
    WebViewController *wc=[[WebViewController alloc]init];
    [self.navigationController pushViewController:wc animated:YES];
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
        if (text.length>=10) {
            if ([[text substringWithRange:NSMakeRange(6, 4)]isEqualToString:@"0001"]) {
                if (text.length>45) {
                    NSString *strSf = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, text.length-12)]];
                    softText.text = strSf;
                }
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0002"]){
                if (text.length>=30) {
                    NSString *strSn = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, text.length-12)]];
                    snText.text = strSn;
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
