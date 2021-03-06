

//========== 申报异常弹窗 ==========//

#import <UIKit/UIKit.h>


/**
 弹窗上的按钮

 - AlertButtonLeft: 左边的按钮
 - AlertButtonRight: 右边的按钮
 */
typedef NS_ENUM(NSUInteger, AMbnormalButton) {
    AMlertButtonLeft = 0,
    AMlertButtonRight
};


#pragma mark - 协议

@class DeclareAbnormalAlertView;

@protocol DeclareAbnormalAlertViewDelegate <NSObject>

- (void)declareAbnormalAlertView:(DeclareAbnormalAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


#pragma mark - interface

/** 申报异常弹窗 */
@interface DeclareAbnormalAlertView : UIView

/** 这个弹窗对应的orderID */
@property (nonatomic,copy) NSString *orderID;
/** 用户填写异常情况的textView */
@property (nonatomic,strong) UITextView *textView1;
@property (nonatomic,strong) UITextView *textView2;
/** 弹窗标题 */
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,weak) id<DeclareAbnormalAlertViewDelegate> delegate;

/**
 申报异常弹窗的构造方法

 @param title 弹窗标题
 @param message 弹窗message
 @param delegate 确定代理方
 @param leftButtonTitle 左边按钮的title
 @param rightButtonTitle 右边按钮的title
 @return 一个申报异常的弹窗
 */
- (instancetype)initWithTitle:(NSString *)title message1:(NSString *)message1 message2:(NSString *)message2 delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

/** show出这个弹窗 */
- (void)show;

@end
