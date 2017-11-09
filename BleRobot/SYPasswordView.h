

#import <UIKit/UIKit.h>

@interface SYPasswordView : UIView<UITextFieldDelegate>
{
    UIAlertController  *alert;
}

/**
 *  清除密码
 */
- (void)clearUpPassword;
@property(nonatomic,strong)NSString *numText;

typedef void(^CallBackBlcok) (NSString *text);

 @property (nonatomic,copy)CallBackBlcok callBackBlock;
@property (nonatomic, strong) UITextField *textField;

@end
