//
//  PinViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/8.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "PinViewController.h"
#import "BleUtils.h"
#import "CQHud.h"
#import "SetViewController.h"
@interface PinViewController ()

@end

@implementation PinViewController
@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Change PIN"];
    [self createView];

//    self.sensor.delegate = self;
    NSString *strPin = @"55AA020003";
    NSString *str =[strPin stringByAppendingString:[BleUtils makeCheckSum:strPin]];
    [sensor write:peripheral value:str];
    [CQHud LoadingShow];
    loadIsShow = YES;
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    
    [self getData];
    
}

-(void)createView
{
    oldPin = [[UITextField alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 40)];
    oldPin.borderStyle = UITextBorderStyleRoundedRect;
    oldPin.placeholder = @"enter old PIN code";
    oldPin.clearButtonMode = UITextFieldViewModeWhileEditing;
    oldPin.secureTextEntry = YES;
    oldPin.keyboardType = UIKeyboardTypeNumberPad;
    oldPin.delegate = self;
    [oldPin addTarget:self action:@selector(enterOldPin:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:oldPin];
    
    newPin = [[UITextField alloc]initWithFrame:CGRectMake(10, 68, self.view.frame.size.width-20, 40)];
    newPin.borderStyle = UITextBorderStyleRoundedRect;
    newPin.placeholder = @"enter new PIN code";
    newPin.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPin.secureTextEntry = YES;
    newPin.keyboardType = UIKeyboardTypeNumberPad;
    newPin.delegate = self;
    [newPin addTarget:self action:@selector(enterNewPin:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:newPin];
    
    reNewPin = [[UITextField alloc]initWithFrame:CGRectMake(10, 116, self.view.frame.size.width-20, 40)];
    reNewPin.borderStyle = UITextBorderStyleRoundedRect;
    reNewPin.placeholder = @"Re-enter new PIN code";
    reNewPin.clearButtonMode = UITextFieldViewModeWhileEditing;
    reNewPin.secureTextEntry = YES;
    reNewPin.keyboardType = UIKeyboardTypeNumberPad;
    reNewPin.delegate = self;
    [reNewPin addTarget:self action:@selector(enterReNewPin:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:reNewPin];
    
    btnPin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnPin.frame = CGRectMake(20, 168, self.view.frame.size.width - 40, 40);
    [btnPin setTitle:@"Confim Change Password" forState:UIControlStateNormal];
    [btnPin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPin.layer.cornerRadius= 8;
    btnPin.layer.masksToBounds = YES;
    btnPin.backgroundColor = [UIColor colorWithRed:69/255.0 green:139/255.0 blue:0 alpha:1];
    [btnPin addTarget:self action:@selector(pressBtnCp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPin];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 4) {
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [oldPin resignFirstResponder];
    [newPin resignFirstResponder];
    [reNewPin resignFirstResponder];
}
-(void)enterOldPin:(UITextField*)textFiled
{
    strOldPwd = textFiled.text;
}

-(void)enterNewPin:(UITextField*)textFiled
{
    strNewPwd = textFiled.text;
}

-(void)enterReNewPin:(UITextField*)textFiled
{
    strReNewPwd = textFiled.text;
}
-(void)pressBtnCp
{
    [oldPin resignFirstResponder];
    [newPin resignFirstResponder];
    [reNewPin resignFirstResponder];
    if (strOldPwd.length!=0 && strNewPwd!=0 && strReNewPwd!=0) {
        if ([strOldPwd isEqualToString:strReturnPwd]) {
            if ([strNewPwd isEqualToString:strReNewPwd]) {
               NSString *msg =[@"55AA06000C"stringByAppendingString:[BleUtils convertStringToHexStr:strNewPwd]];
                NSString *strPwd = [msg stringByAppendingString:[BleUtils makeCheckSum:msg]];
                [sensor write:peripheral value:strPwd];
            }else{
               [self.view makeToast:@"Entered passwords differ from the another"];
            }
        }else{
            [self.view makeToast:@"Original password is incorrect"];
        }
    }else{
        [self.view makeToast:@"Password cannot be empty"];
    }
    NSLog(@"点击 %@",strOldPwd);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"0003"]) {
                if (text.length>=18) {
                    strReturnPwd = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, 8)]];
                    [CQHud LoadingDismiss];
                    loadIsShow = NO;
                }
            }else if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"000c"]){
                 [self.view makeToast:@"Success"];
                [self performSelector:@selector(popView) withObject:nil afterDelay:1];
                
            }
        }
    };
}

-(void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
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
