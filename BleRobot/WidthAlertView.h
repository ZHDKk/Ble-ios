//
//  WidthAlertView.h
//  BleRobot
//
//  Created by zh dk on 2017/10/18.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 弹窗上的按钮
 
 - AlertButtonLeft: 左边的按钮
 - AlertButtonRight: 右边的按钮
 */
typedef NS_ENUM(NSUInteger, AbnormalButton) {
    AlertButtonLeft = 0,
    AlertButtonRight
};


#pragma mark - 协议

@class WidthAlertView;

@protocol WidthAlerViewDelegaet <NSObject>

- (void)declareAbnormalAlertView:(WidthAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface WidthAlertView : UIView

/** 这个弹窗对应的orderID */
@property (nonatomic,copy) NSString *orderID;
/** 用户填写异常情况的textView */
@property (nonatomic,strong) UITextView *textView1;
@property (nonatomic,strong) UITextView *textView2;
/** 弹窗标题 */
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,weak) id<WidthAlerViewDelegaet> delegate;

// 标签数组(按钮文字)
@property (nonatomic, strong) NSArray *markArray;

// 按钮数组
@property (nonatomic, strong) NSMutableArray *btnArray;

// 选中按钮
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong)  UILabel *titleLabel;

@property (nonatomic, strong)  NSString *strChooseNum;

/**
 弹窗的构造方法

 */
- (instancetype)initWithTitle:(NSString *)title  delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

/** show出这个弹窗 */
- (void)show;


@end
