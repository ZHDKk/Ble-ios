
//========== 申报异常弹窗 ==========//

#import "DeclareAbnormalAlertView.h"
#import "UIColor+Util.h"
#import "UIView+frameAdjust.h"

@interface DeclareAbnormalAlertView ()<UITextViewDelegate>

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

@implementation DeclareAbnormalAlertView{
    UILabel *label;
}

#pragma mark - 构造方法
/**
 申报异常弹窗的构造方法
 
 @param title 弹窗标题
 @param message 弹窗message
 @param delegate 确定代理方
 @param leftButtonTitle 左边按钮的title
 @param rightButtonTitle 右边按钮的title
 @return 一个申报异常的弹窗
 */
- (instancetype)initWithTitle:(NSString *)title message1:(NSString *)message1 message2:(NSString *)message2 delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle{
    if (self = [super init]) {
        self.title = title;
        self.message1 = message1;
        self.message2 = message2;
        self.delegate = delegate;
        self.leftButtonTitle = leftButtonTitle;
        self.rightButtonTitle = rightButtonTitle;
        
        // 接收键盘显示隐藏的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI{
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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 22)];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.title;
    
    UILabel *lableDistance = [[UILabel alloc]init];
    lableDistance.frame = CGRectMake(20, titleLabel.maxY+10, self.contentView.width-40, 20);
    lableDistance.text = @"Enter Distance:(m,max length:3)";
    [self.contentView addSubview:lableDistance];
    // 填写异常情况描述的textView
    self.textView1 = [[UITextView alloc]initWithFrame:CGRectMake(20, titleLabel.maxY + 35, self.contentView.width - 40, 40)];
    [self.contentView addSubview:self.textView1];
    self.textView1.text = self.message1;
    self.textView1.layer.cornerRadius = 6;
    self.textView1.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    self.textView1.font = [UIFont systemFontOfSize:14];
    self.textView1.keyboardType = UIKeyboardTypeNumberPad;
    [self.textView1 becomeFirstResponder];
    self.textView1.tag = 1;
    self.textView1.delegate = self;
    
    // textView里面的占位label
    self.messageLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, self.textView1.width - 16, self.textView1.height - 16)];
//    self.messageLabel1.text = self.message1;
    self.messageLabel1.numberOfLines = 0;
    self.messageLabel1.font = [UIFont systemFontOfSize:14];
    self.messageLabel1.textColor = [UIColor colorWithHexString:@"484848"];
    [self.messageLabel1 sizeToFit];
    [self.textView1 addSubview:self.messageLabel1];
    
    UILabel *lableArea = [[UILabel alloc]init];
    lableArea.frame = CGRectMake(22, titleLabel.maxY+85, self.contentView.width-44, 20);
    lableArea.text = @"Enter Area:(%,max length:2)";
    [self.contentView addSubview:lableArea];
    // 填写异常情况描述的textView
    self.textView2 = [[UITextView alloc]initWithFrame:CGRectMake(20, titleLabel.maxY + 115, self.contentView.width - 40, 40)];
    [self.contentView addSubview:self.textView2];
    self.textView2.text = self.message2;
    self.textView2.layer.cornerRadius = 6;
    self.textView2.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    self.textView2.font = [UIFont systemFontOfSize:14];
    self.textView2.keyboardType = UIKeyboardTypeNumberPad;
    [self.textView2 becomeFirstResponder];
    self.textView2.delegate = self;
    self.textView2.tag = 2;
    
    // textView里面的占位label
    self.messageLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, self.textView2.width - 16, self.textView2.height - 16)];
//    self.messageLabel2.text = self.message2;
    self.messageLabel2.numberOfLines = 0;
    self.messageLabel2.font = [UIFont systemFontOfSize:14];
    self.messageLabel2.textColor = [UIColor colorWithHexString:@"484848"];
    [self.messageLabel2 sizeToFit];
    [self.textView2 addSubview:self.messageLabel2];
    
   
    
    // 取消按钮
    UIButton *abnormalButton = [[UIButton alloc]initWithFrame:CGRectMake(self.textView2.minX, _textView2.maxY + 5, 100, 40)];
    [self.contentView addSubview:abnormalButton];
    abnormalButton.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
    [abnormalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [abnormalButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [abnormalButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    abnormalButton.layer.cornerRadius = 6;
    [abnormalButton addTarget:self action:@selector(abnormalButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // 确定按钮
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(self.textView2.maxX - 100, abnormalButton.minY, 100, 40)];
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
        [self.delegate declareAbnormalAlertView:self clickedButtonAtIndex:AMlertButtonLeft];
    }
    [self dismiss];
}

#pragma mark - 取消按钮点击
/** 取消按钮点击 */
- (void)cancelButtonClicked{
    if ([self.delegate respondsToSelector:@selector(declareAbnormalAlertView:clickedButtonAtIndex:)]) {
        [self.delegate declareAbnormalAlertView:self clickedButtonAtIndex:AMlertButtonRight];
    }
    [self dismiss];
}

#pragma mark - UITextView代理方法
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.messageLabel1.hidden = NO;
    }else{
        self.messageLabel1.hidden = YES;
    }
    
    if ([textView.text isEqualToString:@""]) {
        self.messageLabel2.hidden = NO;
    }else{
        self.messageLabel2.hidden = YES;
    }
}

//如果输入超过规定的字数3，就不再让输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.tag == 1 && range.location>=3)
    {
        return  NO;
    }else if (textView.tag == 2 && range.location>=2){
        return NO;
    }else{
        return YES;
    }
}

/**
 *  键盘将要显示
 *
 *  @param notification 通知
 */
-(void)keyboardWillShow:(NSNotification *)notification
{
    // 获取到了键盘frame
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = frame.size.height;
    
    self.contentView.maxY = SCREEN_HEIGHT - keyboardHeight - 10;
}
/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
-(void)keyboardWillHidden:(NSNotification *)notification
{
    // 弹窗回到屏幕正中
    self.contentView.centerY = SCREEN_HEIGHT / 2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView1 resignFirstResponder];
}

@end
