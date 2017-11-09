//
//  DeviceScanViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/25.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "DeviceScanViewController.h"
//#import "ViewController.h"
#import "PinCodeViewController.h"

@interface DeviceScanViewController ()

@end

@implementation DeviceScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Scan the device"];
    
    _sensor = [[SerialGATT alloc]init];
    [_sensor setup];
    _sensor.delegate=self;
    _devicesArray = [[NSMutableArray alloc]init];
    
    devicesTableView =[[UITableView alloc]init];
    devicesTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    devicesTableView.delegate = self;
    devicesTableView.dataSource = self;
    devicesTableView.separatorStyle = UITableViewRowActionStyleNormal;
    devicesTableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    devicesTableView.tableFooterView = [UIView new];
    devicesTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:devicesTableView];
//    [self scanDevices];
    //初始化
    self.cm = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
//    [self createScanView];
    [self createView];

   
}

-(void)createView{
    
   
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height-150, 60, 60);
    btn1.layer.borderWidth = 1;
    btn1.layer.borderColor = [UIColor colorWithRed:69/255.0 green:139/255.0 blue:0 alpha:1].CGColor;
    btn1.backgroundColor =[UIColor colorWithRed:69/255.0 green:139/255.0 blue:0 alpha:1];
    btn1.layer.cornerRadius = 30;
    btn1.layer.masksToBounds = YES;
    [btn1 addTarget:self action:@selector(pressScan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    rotateView = [[UIImageView alloc]init];
    rotateView.frame = CGRectMake(20, 20, 20, 20);
    [rotateView setImage:[UIImage imageNamed:@"rotate"]];
    [btn1 addSubview:rotateView];
    
    scanView.hidden = YES;
    
}

-(void)createScanView
{
    scanView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-((self.view.frame.size.width-20)/2), self.view.frame.size.height/2-((self.view.frame.size.width+100)/2), self.view.frame.size.width-20, self.view.frame.size.width-20)];
    [self.view addSubview:scanView];
    scanView.layer.backgroundColor = [UIColor clearColor].CGColor;
    CAShapeLayer *pulseLayer = [CAShapeLayer layer];
    pulseLayer.frame = scanView.layer.bounds;
    pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
    pulseLayer.fillColor = [UIColor colorWithRed:75/255.0 green:138/255.0 blue:22/255.0 alpha:1].CGColor;//填充色
    pulseLayer.opacity = 0.0;
    
    UIImageView *phoneView = [[UIImageView alloc]init];
    phoneView.frame = CGRectMake(scanView.frame.size.width/2-30, scanView.frame.size.height/2-30, 60, 60);
    
    [phoneView setImage:[UIImage imageNamed:@"phone.png"]];
    [scanView addSubview:phoneView];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = scanView.bounds;
    replicatorLayer.instanceCount = 4;//创建副本的数量,包括源对象。
    replicatorLayer.instanceDelay = 1;//复制副本之间的延迟
    [replicatorLayer addSublayer:pulseLayer];
    [scanView.layer addSublayer:replicatorLayer];
    
    
    
    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnima.fromValue = @(0.3);
    opacityAnima.toValue = @(0.0);
    
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[opacityAnima, scaleAnima];
    groupAnima.duration = 4.0;
    groupAnima.autoreverses = NO;
    groupAnima.repeatCount = HUGE;
    [pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createScanView];
    [self scanDevices];
}

//实现判断蓝牙是否开启的代理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *message = nil;
    switch (central.state) {
        case 1:
            message = @"Bluetooth function is not supported by this device, please check out system setting";
            break;
        case 2:
            message = @"Bluetooth function is not authorized, please check out system setting";
            break;
        case 3:
            message = @"Bluetooth function is not authorized, please check out system setting";
            break;
        case 4:
            message = @"Bluetooth function is closed, please check out system setting";
            devicesTableView.hidden = YES;
            break;
        case 5:
            [self scanDevices];
            break;
        default:
            break;
    }
    if(message!=nil&&message.length!=0)
    {
        alert = [UIAlertController alertControllerWithTitle:@"prompt:" message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action) {
//                                                                  NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
//                                                                  if ([[UIApplication sharedApplication]canOpenURL:url]) {
//                                                                      [[UIApplication sharedApplication]openURL:url];
//                                                                  }
//                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                                 alert = nil;
                                                             }];
        [alert addAction:cancelAction];
//        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//扫描
-(void)scanDevices
{
    scanView.hidden =NO;
    devicesTableView.hidden = YES;
       [rotateView setImage:[UIImage imageNamed:@"stop"]];
    if ([_sensor activePeripheral]) {
        if (_sensor.activePeripheral.state == CBPeripheralStateConnected) {
            [_sensor.manager cancelPeripheralConnection:_sensor.activePeripheral];
            _sensor.activePeripheral = nil;
        }
    }
    if ([_sensor peripherals]) {
        _sensor.peripherals = nil;
        _sensor.activePeripheral = nil;
        [_devicesArray removeAllObjects];
        [devicesTableView reloadData];
    }
    _sensor.delegate = self;
     [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    [_sensor findBLKAppPeripherals:5];
}
-(void)scanTimer:(NSTimer *)timer
{
    scanView.hidden = YES;
    devicesTableView.hidden = NO;
 [rotateView setImage:[UIImage imageNamed:@"rotate"]];
}

-(void)pressScan:(UIButton*)btn{
    if (scanView.hidden) {
        [rotateView setImage:[UIImage imageNamed:@"stop"]];
            [self scanDevices];
        devicesTableView.hidden = YES;
        
    }else{
        [rotateView setImage:[UIImage imageNamed:@"rotate"]];
        scanView.hidden = YES;
        devicesTableView.hidden = NO;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _devicesArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"peripheral";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSUInteger row = [indexPath row];
//    ViewController *controller = [_devicesArray objectAtIndex:row];
     PinCodeViewController *controller = [_devicesArray objectAtIndex:row];
    CBPeripheral *peripheral = [controller peripheral];
    cell.textLabel.text = peripheral.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中的颜色
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSUInteger row = [indexPath row];
//    ViewController *controller = [_devicesArray objectAtIndex:row];
     PinCodeViewController *controller = [_devicesArray objectAtIndex:row];
    
    if (_sensor.activePeripheral && _sensor.activePeripheral != controller.peripheral) {
        [_sensor disconnect:_sensor.activePeripheral];
    }
    
    _sensor.activePeripheral = controller.peripheral;
    [_sensor connect:_sensor.activePeripheral];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:controller animated:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) peripheralFound:(CBPeripheral *)peripheral
{
//    ViewController *controller = [[ViewController alloc] init];
    PinCodeViewController *controller = [[PinCodeViewController alloc]init];
    controller.peripheral = peripheral;
    controller.sensor = _sensor;
    [_devicesArray addObject:controller];
    [devicesTableView reloadData];
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
