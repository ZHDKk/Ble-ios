//
//  MultiViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/8.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "MultiViewController.h"
#import "BleUtils.h"
#import "DeclareAbnormalAlertView.h"
#import "BleUtils.h"
#import "CQHud.h"
@interface MultiViewController ()<DeclareAbnormalAlertViewDelegate>

@end

@implementation MultiViewController
@synthesize sensor;
@synthesize peripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"Multi-Area"];
    [self createView];
//    self.sensor.delegate = self;
    
    NSString *strMulti = @"55AA02000D";
    NSString *str =[strMulti stringByAppendingString:[BleUtils makeCheckSum:strMulti]];
    [sensor write:peripheral value:str];
    [sensor write:peripheral value:str];
    [CQHud LoadingShow];
    loadIsShow = YES;
    [self performSelector:@selector(dismissLoading) withObject:nil afterDelay:10];
    
    [self getData];
}

-(void)createView
{
    //创建multiViewA
    UIView *multiViewA = [[UIView alloc]init];
    multiViewA.frame = CGRectMake(5,10,self.view.frame.size.width/2-10,self.view.frame.size.width/2-50);
    multiViewA.backgroundColor = [UIColor whiteColor];
    multiViewA.layer.cornerRadius = 5;
    multiViewA.layer.masksToBounds = YES;
    multiViewA.layer.shadowColor = [UIColor blackColor].CGColor;
    multiViewA.layer.shadowOffset = CGSizeMake(4, 4);
    multiViewA.layer.shadowRadius=3;
    multiViewA.layer.shadowOpacity = 1;
    
    UIImageView *imageA = [[UIImageView alloc]init];
    imageA.frame = CGRectMake(multiViewA.frame.size.width/2-15, multiViewA.frame.size.height/2-40, 30, 30);
    imageA.image = [UIImage imageNamed:@"a"];
    [multiViewA addSubview:imageA];
    
     lableA =[[UILabel alloc]init];
    lableA.frame = CGRectMake(multiViewA.frame.size.width/2-40, multiViewA.frame.size.height/2, 80, 40);
    [lableA setText:@"50m,20%"];
    [lableA setFont:[UIFont systemFontOfSize:14]];
    lableA.textAlignment = NSTextAlignmentCenter;
    [multiViewA addSubview:lableA];
    
//   lableAp =[[UILabel alloc]init];
//    lableAp.frame = CGRectMake(multiViewA.frame.size.width/2-40, multiViewA.frame.size.height/2+7, 80, 40);
//    [lableAp setText:@"20%"];
//    [lableAp setFont:[UIFont systemFontOfSize:14]];
//    lableAp.textAlignment = NSTextAlignmentCenter;
//    [multiViewA addSubview:lableAp];
    
    multiViewA.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressA)];
    [multiViewA addGestureRecognizer:tapA];
    [tapA setNumberOfTouchesRequired:1];
    [self.view addSubview:multiViewA];
    
    //创建multiViewB
    UIView *multiViewB = [[UIView alloc]init];
    multiViewB.frame = CGRectMake(self.view.frame.size.width/2+5,10,self.view.frame.size.width/2-10,self.view.frame.size.width/2-50);
    multiViewB.backgroundColor = [UIColor whiteColor];
    multiViewB.layer.cornerRadius = 5;
    multiViewB.layer.masksToBounds = YES;
    multiViewB.layer.shadowColor = [UIColor blackColor].CGColor;
    multiViewB.layer.shadowOffset = CGSizeMake(4, 4);
    multiViewB.layer.shadowRadius=3;
    multiViewB.layer.shadowOpacity = 1;
    
    UIImageView *imageB = [[UIImageView alloc]init];
    imageB.frame = CGRectMake(multiViewB.frame.size.width/2-15, multiViewB.frame.size.height/2-40, 30, 30);
    imageB.image = [UIImage imageNamed:@"b"];
    [multiViewB addSubview:imageB];
    
    lableB =[[UILabel alloc]init];
    lableB.frame = CGRectMake(multiViewB.frame.size.width/2-40, multiViewB.frame.size.height/2, 80, 40);
    [lableB setText:@"50m,20%"];
    [lableB setFont:[UIFont systemFontOfSize:14]];
    lableB.textAlignment = NSTextAlignmentCenter;
    [multiViewB addSubview:lableB];
    
//    lableBp =[[UILabel alloc]init];
//    lableBp.frame = CGRectMake(multiViewB.frame.size.width/2-40, multiViewB.frame.size.height/2+7, 80, 40);
//    [lableBp setText:@"20%"];
//    [lableBp setFont:[UIFont systemFontOfSize:14]];
//    lableBp.textAlignment = NSTextAlignmentCenter;
//    [multiViewB addSubview:lableBp];
    
    multiViewB.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressB)];
    [multiViewB addGestureRecognizer:tapB];
    [tapB setNumberOfTouchesRequired:1];

    [self.view addSubview:multiViewB];
    
    //创建multiViewC
    UIView *multiViewC = [[UIView alloc]init];
    multiViewC.frame = CGRectMake(5,self.view.frame.size.width/2-30,self.view.frame.size.width/2-10,self.view.frame.size.width/2-50);
    multiViewC.backgroundColor = [UIColor whiteColor];
    multiViewC.layer.cornerRadius = 5;
    multiViewC.layer.masksToBounds = YES;
    multiViewC.layer.shadowColor = [UIColor blackColor].CGColor;
    multiViewC.layer.shadowOffset = CGSizeMake(4, 4);
    multiViewC.layer.shadowRadius=3;
    multiViewC.layer.shadowOpacity = 1;
    
    UIImageView *imageC = [[UIImageView alloc]init];
    imageC.frame = CGRectMake(multiViewC.frame.size.width/2-15, multiViewC.frame.size.height/2-40, 30, 30);
    imageC.image = [UIImage imageNamed:@"c"];
    [multiViewC addSubview:imageC];
    
    lableC =[[UILabel alloc]init];
    lableC.frame = CGRectMake(multiViewC.frame.size.width/2-40, multiViewC.frame.size.height/2, 80, 40);
    [lableC setText:@"50m,20%"];
    [lableC setFont:[UIFont systemFontOfSize:14]];
    lableC.textAlignment = NSTextAlignmentCenter;
    [multiViewC addSubview:lableC];
    
//    lableCp =[[UILabel alloc]init];
//    lableCp.frame = CGRectMake(multiViewC.frame.size.width/2-40, multiViewC.frame.size.height/2+7, 80, 40);
//    [lableCp setText:@"20%"];
//    [lableCp setFont:[UIFont systemFontOfSize:14]];
//    lableCp.textAlignment = NSTextAlignmentCenter;
//    [multiViewC addSubview:lableCp];
    
    multiViewC.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressC)];
    [multiViewC addGestureRecognizer:tapC];
    [tapC setNumberOfTouchesRequired:1];

    [self.view addSubview:multiViewC];
    
    //创建multiViewD
    UIView *multiViewD = [[UIView alloc]init];
    multiViewD.frame = CGRectMake(self.view.frame.size.width/2+5,self.view.frame.size.width/2-30,self.view.frame.size.width/2-10,self.view.frame.size.width/2-50
                                  );
    multiViewD.backgroundColor = [UIColor whiteColor];
    multiViewD.layer.cornerRadius = 5;
    multiViewD.layer.masksToBounds = YES;
    multiViewD.layer.shadowColor = [UIColor blackColor].CGColor;
    multiViewD.layer.shadowOffset = CGSizeMake(4, 4);
    multiViewD.layer.shadowRadius=3;
    multiViewD.layer.shadowOpacity = 1;
    
    UIImageView *imageD = [[UIImageView alloc]init];
    imageD.frame = CGRectMake(multiViewD.frame.size.width/2-15, multiViewD.frame.size.height/2-40, 30, 30);
    imageD.image = [UIImage imageNamed:@"d"];
    [multiViewD addSubview:imageD];
    
    lableD =[[UILabel alloc]init];
    lableD.frame = CGRectMake(multiViewD.frame.size.width/2-40, multiViewD.frame.size.height/2, 80, 40);
    [lableD setText:@"50m,20%"];
    [lableD setFont:[UIFont systemFontOfSize:14]];
    lableD.textAlignment = NSTextAlignmentCenter;
    [multiViewD addSubview:lableD];
    
//    lableDp =[[UILabel alloc]init];
//    lableDp.frame = CGRectMake(multiViewD.frame.size.width/2-40, multiViewD.frame.size.height/2+7, 80, 40);
//    [lableDp setText:@"20%"];
//    [lableDp setFont:[UIFont systemFontOfSize:14]];
//    lableDp.textAlignment = NSTextAlignmentCenter;
//    [multiViewD addSubview:lableDp];
    
    multiViewD.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapD = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressD)];
    [multiViewD addGestureRecognizer:tapD];
    [tapD setNumberOfTouchesRequired:1];
    
    [self.view addSubview:multiViewD];
}

-(void)pressA
{
    NSLog(@"点击A");
    NSString *strA = @"A";
    NSString *strDA = lableA.text;
    NSArray *temp = [strDA componentsSeparatedByString:@","];
    NSString *strDistance;
    NSString *strArea;
    for (int i=0; i<temp.count; i++) {
        NSString* s =  temp[0];
        strDistance= [s substringWithRange:NSMakeRange(0, s.length-1)];
        
        NSString *d = temp[1];
        strArea = [d substringWithRange:NSMakeRange(0, d.length-1)];
    }
    [self setArea:strA :strDistance :strArea];
}

-(void)pressB
{
    NSLog(@"点击B");
    NSString *strA = @"B";
    NSString *strDA = lableB.text;
    NSArray *temp = [strDA componentsSeparatedByString:@","];
    NSString *strDistance;
    NSString *strArea;
    for (int i=0; i<temp.count; i++) {
        NSString* s =  temp[0];
        strDistance= [s substringWithRange:NSMakeRange(0, s.length-1)];
        
        NSString *d = temp[1];
        strArea = [d substringWithRange:NSMakeRange(0, d.length-1)];
    }
    [self setArea:strA :strDistance :strArea];
}

-(void)pressC
{
    NSLog(@"点击C");
    NSString *strA = @"C";
    NSString *strDA = lableC.text;
    NSArray *temp = [strDA componentsSeparatedByString:@","];
    NSString *strDistance;
    NSString *strArea;
    for (int i=0; i<temp.count; i++) {
        NSString* s =  temp[0];
        strDistance= [s substringWithRange:NSMakeRange(0, s.length-1)];
        
        NSString *d = temp[1];
        strArea = [d substringWithRange:NSMakeRange(0, d.length-1)];
    }
    [self setArea:strA :strDistance :strArea];
}

-(void)pressD
{
    NSLog(@"点击D");
    NSString *strA = @"D";
    NSString *strDA = lableD.text;
    NSArray *temp = [strDA componentsSeparatedByString:@","];
    NSString *strDistance;
    NSString *strArea;
    for (int i=0; i<temp.count; i++) {
        NSString* s =  temp[0];
        strDistance= [s substringWithRange:NSMakeRange(0, s.length-1)];
        
        NSString *d = temp[1];
        strArea = [d substringWithRange:NSMakeRange(0, d.length-1)];
    }
    [self setArea:strA :strDistance :strArea];
}

-(void)setArea:(NSString *)str:(NSString *)strDistance:(NSString*)strArea
{
    alertView = [[DeclareAbnormalAlertView alloc]initWithTitle:str message1:strDistance message2:strArea delegate:self leftButtonTitle:@"CANCEL" rightButtonTitle:@"OK"];
    [alertView show];
}
-(void)declareAbnormalAlertView:(DeclareAbnormalAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == AMlertButtonRight) {
        distance = alertView.textView1.text;
        area = alertView.textView2.text;
        NSString *title = alertView.title;
        if ([distance isEqualToString:@""] && distance.length == 0) {
            distance = @"0";
        }
        if ([area isEqualToString:@""] && area.length == 0) {
            area = @"0";
        }
        NSString *da = [NSString stringWithFormat:@"%@%@%@%@%@%@",title,@":",distance,@"m,",area,@"%"];
        NSString *textToHex = [BleUtils convertStringToHexStr:da];
        NSString *str=@"";
        if (da.length == 8){
            str = [@"55AA0A000E" stringByAppendingString:textToHex];
        }else if (da.length==9) {
            str = [@"55AA0B000E" stringByAppendingString:textToHex];
        }else if (da.length== 10) {
            str = [@"55AA0C000E" stringByAppendingString:textToHex];
        }else if (da.length == 11) {
            str = [@"55AA0D000E" stringByAppendingString:textToHex];
        }else if (da.length == 12){
            str = [@"55AA0E000E" stringByAppendingString:textToHex];
        }else if (da.length == 13){
            str = [@"55AA0F000E" stringByAppendingString:textToHex];
        }else if (da.length<8){
            str= [NSString stringWithFormat:@"%@%lu%@%@",@"55AA0",da.length,@"000E",textToHex];
        }
        NSString *strSum = [BleUtils makeCheckSum:str];
        NSString *strData = [str stringByAppendingString:strSum];
        [sensor write:peripheral value:strData];
        
        if ([title isEqualToString:@"A"]) {
            lableA.text=[[[distance stringByAppendingString:@"m"] stringByAppendingString:@","] stringByAppendingString:[area stringByAppendingString:@"%"]];
        }else if([title isEqualToString:@"B"]){
            lableB.text=[[[distance stringByAppendingString:@"m"] stringByAppendingString:@","] stringByAppendingString:[area stringByAppendingString:@"%"]];
        }else if([title isEqualToString:@"C"]){
             lableC.text=[[[distance stringByAppendingString:@"m"] stringByAppendingString:@","] stringByAppendingString:[area stringByAppendingString:@"%"]];
        }else if([title isEqualToString:@"D"]){
             lableD.text=[[[distance stringByAppendingString:@"m"] stringByAppendingString:@","] stringByAppendingString:[area stringByAppendingString:@"%"]];
        }
    }
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
            if ([[text substringWithRange:NSMakeRange(6, 4)] isEqualToString:@"000d"]) {
                
                if (text.length>70) {
                    NSString *strData = [BleUtils convertHexStrToString:[text substringWithRange:NSMakeRange(10, text.length-12)]];
                    NSArray *temp = [strData componentsSeparatedByString:@"%"];
                    NSString *a = [temp objectAtIndex:0];
                    NSLog(@"a的值:%@",a);
                    if ([[a substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"A"]) {
                        NSString *strLengthA = [a substringFromIndex:2];
                        lableA.text = [strLengthA stringByAppendingString:@"%"];
                    }
                    
                    NSString *b = [temp objectAtIndex:1];
                     NSLog(@"b的值:%@",b);
                    if ([[b substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"B"]) {
                        NSString *strLengthB = [b substringFromIndex:3];
                        lableB.text = [strLengthB stringByAppendingString:@"%"];
                    }
                    
                    NSString *c = [temp objectAtIndex:2];
                     NSLog(@"c的值:%@",c);
                    if ([[c substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"C"]) {
                        NSString *strLengthC = [c substringFromIndex:3];
                        lableC.text = [strLengthC stringByAppendingString:@"%"];
                    }
                    
                    NSString *d = [temp objectAtIndex:3];
                     NSLog(@"d的值:%@",d);
                    if ([[d substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"D"]) {
                        NSString *strLengthD = [d substringFromIndex:3];
                        lableD.text = [strLengthD stringByAppendingString:@"%"];
                    }
                    
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
