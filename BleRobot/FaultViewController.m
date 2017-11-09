//
//  FaultViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/16.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "FaultViewController.h"
#import "BleUtils.h"
#import "FaultTableViewTableViewCell.h"
#import "FaultBean.h"


@interface FaultViewController ()

@end

@implementation FaultViewController

@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Fault Record"];
    [self createView];
    
    self.sensor.delegate = self;
    
    [self requestAPIData];
    [self getData];
    
}

-(void)createView
{
    
    array = [[NSMutableArray alloc]init];
    faultTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    faultTableView.delegate = self;
    faultTableView.dataSource = self;
    faultTableView.tableFooterView = [UIView new];
    faultTableView.showsVerticalScrollIndicator = NO;
    faultTableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:faultTableView];
    
    faultRefresh = [[UIRefreshControl alloc]init];
    faultRefresh.tintColor = [UIColor lightGrayColor];
//      faultRefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"drop-down refresh"];
    [faultRefresh addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [faultTableView addSubview:faultRefresh];
}

-(void)refreshControlAction
{
    if (faultRefresh.refreshing) {
//        faultRefresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"loading..."];
        // 1. 远程请求数据
        [self requestAPIData];
        
        // 2. 结束刷新
//

    }
}

-(void)requestAPIData
{

    NSString *strFault = @"55AA020017";
    NSString *str =[strFault stringByAppendingString:[BleUtils makeCheckSum:strFault]];
    [sensor write:peripheral value:str];
  
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"UITableViewCell";
    FaultTableViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[FaultTableViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    FaultBean *bean = [array objectAtIndex:indexPath.row];
    cell.lableTime.text = bean.strTime;
    NSString *status = bean.strStatus;
    if ([status isEqualToString:@"00"]) {
         cell.lableStatus.text = @"NULL";
    }else if ([status isEqualToString:@"01"]) {
        cell.lableStatus.text = @"Low Bat";
    }else if ([status isEqualToString:@"02"]) {
        cell.lableStatus.text = @"No Signal";
    }else if ([status isEqualToString:@"03"]) {
        cell.lableStatus.text = @"Out Side";
    }else if ([status isEqualToString:@"04"]) {
        cell.lableStatus.text = @"Pit";
    }else if ([status isEqualToString:@"05"]) {
        cell.lableStatus.text = @"Slope";
    }else if ([status isEqualToString:@"06"]) {
        cell.lableStatus.text = @"Lift";
    }else if ([status isEqualToString:@"07"]) {
        cell.lableStatus.text = @"M1 Brake";
    }else if ([status isEqualToString:@"08"]) {
        cell.lableStatus.text = @"M2 Brake";
    }else if ([status isEqualToString:@"09"]) {
        cell.lableStatus.text = @"Turn Over";
    }else if ([status isEqualToString:@"10"]) {
        cell.lableStatus.text = @"ERROR1";
    }else if ([status isEqualToString:@"11"]) {
        cell.lableStatus.text = @"ERROR20L";
    }else if ([status isEqualToString:@"12"]) {
        cell.lableStatus.text = @"ERROR21";
    }else if ([status isEqualToString:@"13"]) {
        cell.lableStatus.text = @"ERROR22";
    }else if ([status isEqualToString:@"14"]) {
        cell.lableStatus.text = @"ERROR23";
    }else if ([status isEqualToString:@"15"]) {
        cell.lableStatus.text = @"ERROR24";
    }else if ([status isEqualToString:@"16"]) {
        cell.lableStatus.text = @"ERROR3";
    }else if ([status isEqualToString:@"17"]) {
        cell.lableStatus.text = @"ERROR4";
    }else if ([status isEqualToString:@"18"]) {
        cell.lableStatus.text = @"Trapped";
    }else if ([status isEqualToString:@"19"]) {
        cell.lableStatus.text = @"ERROR20M";
    }else if ([status isEqualToString:@"20"]) {
        cell.lableStatus.text = @"12C ERROR";
    }else if ([status isEqualToString:@"28"]) {
        cell.lableStatus.text = @"ERROR20R";
    }
   
    return cell;
}

//取消选中颜色
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)getData
{
    sensor.callBackBlock = ^(NSString *text) {
        if (text.length>=10) {
            if ([[text substringWithRange:NSMakeRange(6, 4)]isEqualToString:@"0015"]
                &&[[text substringWithRange:NSMakeRange(text.length-2, 2)] isEqualToString:[BleUtils makeCheckSumSmall:[text substringWithRange:NSMakeRange(0, text.length-2)]]] ) {
                NSString *strFault = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, text.length-12)]];
                NSArray *temp = [strFault componentsSeparatedByString:@","];
                for (int i=0; i<temp.count; i++) {
                    NSString *strF = temp[i];
                    if (strF.length>=14) {
                        NSString *time = [strF substringWithRange:NSMakeRange(0, 11)];
                        NSString *status = [strF substringWithRange:NSMakeRange(12, 2)];
                        FaultBean *bean = [[FaultBean alloc]init];
                        bean.strTime = time;
                        bean.strStatus = status;
                        [array addObject:bean];
                        // 3. 重新加载数据
                        [faultTableView reloadData];
                        if (faultRefresh.refreshing) {
                            [faultRefresh endRefreshing];
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
