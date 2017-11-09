//
//  SensorViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/11/6.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "SensorViewController.h"


@interface SensorViewController ()

@end

@implementation SensorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
//    [self setTitle:@"Set Device Name"];
    [[UIAccelerometer sharedAccelerometer]setDelegate:self];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:
(UIAcceleration *)acceleration{
    NSLog(@"x:%f,y:%f,z%f",acceleration.x,acceleration.y,acceleration.z);
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
