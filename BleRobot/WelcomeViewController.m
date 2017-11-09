
//
//  WelcomeViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/11/3.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];
}

-(void)createView{
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imageView];
    
    
     [self performSelector:@selector(startNewView) withObject:nil afterDelay:2.5];
}

-(void)startNewView
{
    ViewController *vc = [[ViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
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
