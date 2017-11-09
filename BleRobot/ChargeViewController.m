//
//  ChargeViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/16.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "ChargeViewController.h"
#import "ChargeTableViewCell.h"
#import "BleUtils.h"
#import "ChargingBean.h"
@interface ChargeViewController ()

@end

@implementation ChargeViewController
@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Charge Record"];
    [self createView];
    self.sensor.delegate = self;
    
    [self requestApiData];
   
    [self getData];
}
-(void)createView
{
     array = [[NSMutableArray alloc]init];
    UILabel *lableStart = [[UILabel alloc]init];
    [lableStart setText:@"End"];
    [lableStart setFont:[UIFont systemFontOfSize:16]];
    lableStart.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 50);
    [lableStart setBackgroundColor:[UIColor whiteColor]];
    lableStart.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lableStart];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    lineView.frame = CGRectMake(self.view.frame.size.width/2, 0, 1, 50);
    [self.view addSubview:lineView];
    
    UILabel *lableEnd = [[UILabel alloc]init];
    [lableEnd setText:@"Voltage"];
    [lableEnd setFont:[UIFont systemFontOfSize:16]];
    lableEnd.frame = CGRectMake(self.view.frame.size.width/2+1, 0, self.view.frame.size.width/2, 50);
    lableEnd.textAlignment = NSTextAlignmentCenter;
    [lableEnd setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lableEnd];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.frame = CGRectMake(0, 51, self.view.frame.size.width , 1);
    [self.view addSubview:line];
    
    chargeTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    chargeTableView.frame = CGRectMake(0, 51, self.view.frame.size.width, self.view.frame.size.height-50);
    chargeTableView.delegate = self;
    chargeTableView.dataSource = self;
    chargeTableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    chargeTableView.tableFooterView = [UIView new];
    chargeTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:chargeTableView];
    
    chargeRefresh = [[UIRefreshControl alloc]init];
    chargeRefresh.tintColor = [UIColor lightGrayColor];
    [chargeRefresh addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [chargeTableView addSubview:chargeRefresh];

}
-(void)refreshControlAction{
    if (chargeRefresh.refreshing) {
        //请求数据
        [self requestApiData];
        //结束刷新
        //        [cutrefresh endRefreshing];
       
    }
}

-(void)requestApiData{
    //请求数据
    NSString *strCharge = @"55AA020019";
    NSString *str =[strCharge stringByAppendingString:[BleUtils makeCheckSum:strCharge]];
    [sensor write:peripheral value:str];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"UITableViewCell";
    ChargeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ChargeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    ChargingBean *bean = [array objectAtIndex:indexPath.row];
    cell.lableEnd.text = bean.strEnd;
    cell.lableVoltage.text = bean.strVoltage;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

//取消选中颜色
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData
{
    sensor.callBackBlock = ^(NSString *text) {
        if (text.length>=10) {
            if ([[text substringWithRange:NSMakeRange(6, 4)]isEqualToString:@"0017"]
                &&[[text substringWithRange:NSMakeRange(text.length-2, 2)] isEqualToString:[BleUtils makeCheckSumSmall:[text substringWithRange:NSMakeRange(0, text.length-2)]]]) {
                NSString *strCharge = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, text.length-12)]];
                NSArray *temp = [strCharge componentsSeparatedByString:@","];
                for (int i=0; i<temp.count; i++) {
                    NSString *charge = temp[i];
                    ChargingBean *bean = [[ChargingBean alloc]init];
                    if (charge.length>=10) {
                        NSString *strEnd = [charge substringWithRange:NSMakeRange(0, 11)];
                        NSString *strVoltage = [charge substringFromIndex:12];
                        bean.strEnd = strEnd;
                        bean.strVoltage = strVoltage;
                        [array addObject:bean];
                        [chargeTableView reloadData];
                        if (chargeRefresh.refreshing) {
                             [chargeRefresh endRefreshing];
                        }
                    }
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
