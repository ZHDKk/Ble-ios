//
//  SetDeviceNameViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/11/2.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "SetDeviceNameViewController.h"
#import "BleUtils.h"
#import "CQHud.h"
@interface SetDeviceNameViewController ()

@end

@implementation SetDeviceNameViewController
@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Set Device Name"];
    
    defaults = [[NSUserDefaults alloc]init];
    [self createView];
}


-(void)createView
{
    
    strName = peripheral.name;
    reNewName = [[UITextField alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 40)];
    reNewName.borderStyle = UITextBorderStyleRoundedRect;
    reNewName.placeholder = @"Enten New Device Name";
    reNewName.clearButtonMode = UITextFieldViewModeWhileEditing;
    reNewName.delegate = self;
    [reNewName addTarget:self action:@selector(enterNewName:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:reNewName];
    
    btnDn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnDn.frame = CGRectMake(20, 68, self.view.frame.size.width - 40, 40);
    [btnDn setTitle:@"Confim Change Device Name" forState:UIControlStateNormal];
    [btnDn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDn.layer.cornerRadius= 8;
    btnDn.layer.masksToBounds = YES;
    btnDn.backgroundColor = [UIColor colorWithRed:69/255.0 green:139/255.0 blue:0 alpha:1];
    [btnDn addTarget:self action:@selector(pressBtnCn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDn];
    
    NSString *changeName = [defaults objectForKey:@"changeName"];
    
    if (changeName.length != 0 && ![changeName isEqualToString:strName]) {
        reNewName.text = changeName;
    }else{
        reNewName.text = strName;
    }
    
}


-(void)enterNewName:(UITextField*)textFiled
{
    strNewName = textFiled.text;
}

-(void)pressBtnCn{
    [reNewName resignFirstResponder];
    if (strNewName.length!=0 || strName.length!=0) {
        NSString *str = [BleUtils convertStringToHexStr:strNewName];
        [sensor changeName:peripheral value:str];
        [defaults setObject:strNewName forKey:@"changeName"];
        [defaults synchronize];
        [self.view makeToast:@"success"];
         [self performSelector:@selector(exitView) withObject:nil afterDelay:1];
    }else{
        [self.view makeToast:@"Name cannot be empty"];
    }
}

-(void)exitView
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [reNewName resignFirstResponder];

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
