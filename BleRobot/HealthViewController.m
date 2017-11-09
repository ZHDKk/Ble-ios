//
//  HealthViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/16.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "HealthViewController.h"
#import "BleUtils.h"
#import "HealthBean.h"
#import "HealthTableViewCell.h"

@interface HealthViewController ()

@end

@implementation HealthViewController
@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Health Record"];
    [self createView];
    self.sensor.delegate = self;
    
    [self requestAPIData];
  
    [self getData];
}

-(void)createView
{
      data = [[NSMutableArray alloc]init];
    healthTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    healthTableView.delegate = self;
    healthTableView.dataSource = self;
    healthTableView.tableFooterView = [UIView new];
    healthTableView.showsVerticalScrollIndicator = NO;
    healthTableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:healthTableView];
    
    healthRefresh = [[UIRefreshControl alloc]init];
    healthRefresh.tintColor = [UIColor lightGrayColor];
    //      faultRefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"drop-down refresh"];
    [healthRefresh addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [healthTableView addSubview:healthRefresh];
}

-(void)refreshControlAction
{
    if (healthRefresh.refreshing) {
        //        faultRefresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"loading..."];
        // 1. 远程请求数据
        [self requestAPIData];
        
        // 2. 结束刷新
        //
        
      
    }
}

-(void)requestAPIData
{
    NSString *strCharge = @"55AA02001A";
    NSString *str =[strCharge stringByAppendingString:[BleUtils makeCheckSum:strCharge]];
    [sensor write:peripheral value:str];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"UITableViewCell";
    HealthTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HealthTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    HealthBean *bean = [data objectAtIndex:indexPath.row];
    NSString *str=bean.strTC;
    NSArray *temp = [str componentsSeparatedByString:@","];
    for (int i=0; i<temp.count; i++) {
        NSString *strH=temp[0];
        NSString *strM = temp[1];
        NSString *strT = temp[2];
        cell.lableW.text = [NSString stringWithFormat:@"%@%@%@%@",strH,@"h",strM,@"min"];
        cell.lableC.text =strT;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//取消选中颜色
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)getData
{
    sensor.callBackBlock = ^(NSString *text) {
        if (text.length>=10) {
            if ([[text substringWithRange:NSMakeRange(6, 4)]isEqualToString:@"0018"]
                &&[[text substringWithRange:NSMakeRange(text.length-2, 2)] isEqualToString:[BleUtils makeCheckSumSmall:[text substringWithRange:NSMakeRange(0, text.length-2)]]]) {
                NSString *strHealth = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, text.length-12)]];
                HealthBean *bean = [[HealthBean alloc]init];
                bean.strTC = strHealth;
                [data addObject:bean];
                // 3. 重新加载数据
                [healthTableView reloadData];
                if (healthRefresh.refreshing) {
                     [healthRefresh endRefreshing];
                }
            }
        }
    };
 
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
