//
//  WidthAlertView.m
//  BleRobot
//
//  Created by zh dk on 2017/10/18.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "WidthAlertView.h"
#import "UIColor+Util.h"
#import "UIView+frameAdjust.h"
#import "BoundaryViewController.h"

@interface WidthAlertView ()<UITextViewDelegate>

/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;

/** 弹窗message */
@property (nonatomic,copy)   NSString *message1;
@property (nonatomic,copy)   NSString *message2;
/** message label */
@property (nonatomic,strong) UILabel  *messageLabel1;
@property (nonatomic,strong) UILabel  *messageLabel2;
/** 左边按钮title */
@property (nonatomic,copy)   NSString *leftButtonTitle;
/** 右边按钮title */
@property (nonatomic,copy)   NSString *rightButtonTitle;

@end
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation WidthAlertView
{
    UILabel *label;
}

- (instancetype)initWithTitle:(NSString *)title  delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle{
    if (self = [super init]) {
        self.title = title;
        self.delegate = delegate;
        self.leftButtonTitle = leftButtonTitle;
        self.rightButtonTitle = rightButtonTitle;
        
   
        // UI搭建
        [self setUpUI];
    }
    return self;
}

/** UI搭建 */
- (void)setUpUI{
    _btnArray = [NSMutableArray array];
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
    
    //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake((SCREEN_WIDTH - 285) / 2, (SCREEN_HEIGHT - 215) / 2, 300, 215);
    self.contentView.center = self.center;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 6;
    
    // 标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 22)];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = self.title;
    
    CGFloat UI_View_Width = self.contentView.width;
    CGFloat marginX = 30;
    CGFloat top = 100;
    CGFloat btnH = 30;
    CGFloat width = (250 - marginX * 4) / 4;
    // 按钮背景
    UIView *btnsBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.contentView.width, 50)];
    btnsBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView  addSubview:btnsBgView];
    _markArray = @[@"2",@"3",@"4",@"5"];
    // 循环创建按钮
    NSInteger maxCol = 4;
    for (int i=0; i<_markArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        btn.clipsToBounds = YES;
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [btn addTarget:self action:@selector(chooseMark:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger col = i % maxCol; //列
        btn.x = marginX + col * (width + marginX);
        btn.width = 50;
        btn.height = 50;
        [btn setTitle:self.markArray[i] forState:UIControlStateNormal];
        [btnsBgView addSubview:btn];
        btn.tag = i;
        [self.btnArray addObject:btn];
    }
    [self setChooseMark];
    
    // 取消按钮
    UIButton *abnormalButton = [[UIButton alloc]initWithFrame:CGRectMake(btnsBgView.minX+15, btnsBgView.maxY + 15, 100, 40)];
    [self.contentView addSubview:abnormalButton];
    abnormalButton.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
    [abnormalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [abnormalButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [abnormalButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    abnormalButton.layer.cornerRadius = 6;
    [abnormalButton addTarget:self action:@selector(abnormalButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // 确定按钮
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(btnsBgView.maxX - 115, abnormalButton.minY, 100, 40)];
    [self.contentView addSubview:cancelButton];
    [cancelButton setTitle:@"OK" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"458b00"];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    cancelButton.layer.cornerRadius = 6;
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //------- 调整弹窗高度和中心 -------//
    self.contentView.height = cancelButton.maxY + 10;
    self.contentView.center = self.center;
}

-(void)setChooseMark
{
    NSString *strWidth = self.title;
    if ([strWidth isEqualToString:@"0.2"]) {
       UIButton *btn =  self.btnArray[0];
        btn.backgroundColor = [UIColor colorWithHexString:@"458b00"];
         [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }else if ([strWidth isEqualToString:@"0.3"]) {
        UIButton *btn =  self.btnArray[1];
        btn.backgroundColor = [UIColor colorWithHexString:@"458b00"];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }else if ([strWidth isEqualToString:@"0.4"]) {
        UIButton *btn =  self.btnArray[2];
        btn.backgroundColor = [UIColor colorWithHexString:@"458b00"];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }else if ([strWidth isEqualToString:@"0.5"]) {
        UIButton *btn =  self.btnArray[3];
        btn.backgroundColor = [UIColor colorWithHexString:@"458b00"];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
}
- (void)chooseMark:(UIButton *)sender {
    NSLog(@"点击了%@", sender.titleLabel.text);
    self.titleLabel.text =[@"0." stringByAppendingString:sender.titleLabel.text];
    
    self.selectedBtn = sender;
    self.strChooseNum = sender.titleLabel.text;
    
    sender.selected = !sender.selected;
    
    for (NSInteger j = 0; j < [self.btnArray count]; j++) {
        UIButton *btn = self.btnArray[j] ;
        if (sender.tag == j) {
            btn.selected = sender.selected;
        } else {
            btn.selected = NO;
        }
        btn.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    UIButton *btn = self.btnArray[sender.tag];
    if (btn.selected) {
        btn.backgroundColor = [UIColor colorWithHexString:@"458b00"];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    } else {
         btn.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

#pragma mark - 弹出此弹窗
/** 弹出此弹窗 */
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

#pragma mark - 移除此弹窗
/** 移除此弹窗 */
- (void)dismiss{
    [self removeFromSuperview];
}

#pragma mark - 申报异常按钮点击
/** 申报异常按钮点击 */
- (void)abnormalButtonClicked{
    if ([self.delegate respondsToSelector:@selector(declareAbnormalAlertView:clickedButtonAtIndex:)]) {
        [self.delegate declareAbnormalAlertView:self clickedButtonAtIndex:AlertButtonLeft];
    }
    [self dismiss];
}

#pragma mark - 取消按钮点击
/** 取消按钮点击 */
- (void)cancelButtonClicked{
    if ([self.delegate respondsToSelector:@selector(declareAbnormalAlertView:clickedButtonAtIndex:)]) {
        [self.delegate declareAbnormalAlertView:self clickedButtonAtIndex:AlertButtonRight];
    }
    [self dismiss];
}
@end
