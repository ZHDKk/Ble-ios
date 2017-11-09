//
//  WebViewController.m
//  BleRobot
//
//  Created by zh dk on 2017/9/12.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self setTitle:@"gforce-tools"];
    [self createView];
}

-(void)createView
{
    if (webView == nil) {
        webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        [webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [webView setNavigationDelegate:self];
        [webView setUIDelegate:self];
        [webView setMultipleTouchEnabled:YES];
        [webView setAutoresizesSubviews:YES];
        [webView.scrollView setAlwaysBounceVertical:YES];
        // 这行代码可以是侧滑返回webView的上一级，而不是根控制器（*只针对侧滑有效）
        [webView setAllowsBackForwardNavigationGestures:true];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gforce-tools.com"]]];
        [self.view addSubview:webView];
    }
   }

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    UILabel *lableError = [[UILabel alloc]init];
    [lableError setText:@"error"];
    [lableError setFont:[UIFont systemFontOfSize:14]];
    lableError.frame = CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.width/2-20, 80, 40);
    lableError.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lableError];
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
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
