//
//  CutViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/16.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "CutViewController.h"
#import "CutTableViewCell.h"
#import "BleUtils.h"
#import "CuttingBean.h"

@interface CutViewController ()

@end

@implementation CutViewController
@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Cutting Record"];
    [self createView];
    self.sensor.delegate = self;
    
    [self requestApiData];
    [self getData];
    
}

-(void)createView
{
    array = [[NSMutableArray alloc]init];
    UILabel *lableStart = [[UILabel alloc]init];
    [lableStart setText:@"Start"];
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
    [lableEnd setText:@"End"];
    [lableEnd setFont:[UIFont systemFontOfSize:16]];
    lableEnd.frame = CGRectMake(self.view.frame.size.width/2+1, 0, self.view.frame.size.width/2, 50);
    lableEnd.textAlignment = NSTextAlignmentCenter;
    [lableEnd setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lableEnd];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.frame = CGRectMake(0, 51, self.view.frame.size.width , 1);
    [self.view addSubview:line];
    
    cutTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    cutTableView.frame = CGRectMake(0, 51, self.view.frame.size.width, self.view.frame.size.height-50);
    cutTableView.delegate = self;
    cutTableView.dataSource = self;
    cutTableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    cutTableView.tableFooterView = [UIView new];
    cutTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:cutTableView];
    
    cutrefresh = [[UIRefreshControl alloc]init];
    cutrefresh.tintColor = [UIColor lightGrayColor];
    [cutrefresh addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [cutTableView addSubview:cutrefresh];

}

-(void)refreshControlAction{
    if (cutrefresh.refreshing) {
        //请求数据
        [self requestApiData];
    }
}

-(void)requestApiData{
    //请求数据
    NSString *strCut = @"55AA020018";
    NSString *str =[strCut stringByAppendingString:[BleUtils makeCheckSum:strCut]];
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
    CutTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    CuttingBean *bean = [array objectAtIndex:indexPath.row];
    cell.lableStart.text = bean.strStart;
    cell.lableEnd.text = bean.strEnd;
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
            NSString *jy =[BleUtils makeCheckSumSmall:[text substringWithRange:NSMakeRange(0, text.length-2)]];
            NSString *rejy = [text substringWithRange:NSMakeRange(text.length-2, 2)];
            if ([[text substringWithRange:NSMakeRange(6, 4)]isEqualToString:@"0016"] && [jy isEqualToString:rejy]) {
                NSString *strCut = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, text.length-12)]];
                NSArray *temp = [strCut componentsSeparatedByString:@","];
                for (int i=0; i<temp.count; i++) {
                    NSString *cut = temp[i];
                    CuttingBean *bean = [[CuttingBean alloc]init];
                    if (cut.length>=23) {
                        NSString *strStart = [cut substringWithRange:NSMakeRange(0, 11)];
                        NSString *strEdn = [cut substringWithRange:NSMakeRange(12, 11)];
                        bean.strStart = strStart;
                        bean.strEnd = strEdn;
                        [array addObject:bean];
                         [cutTableView reloadData];
                        if (cutrefresh.refreshing) {
                            [cutrefresh endRefreshing];
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
