//
//  WebViewController.h
//  BleRobot
//
//  Created by zh dk on 2017/9/12.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *webView;
    // 设置加载进度条
}

//创建一个实体变量
@property(nonatomic,strong) WKWebView * ZSJ_WkwebView;
// 加载type
@property(nonatomic,assign) NSInteger  IntegerType;
// 设置加载进度条
@property(nonatomic,strong) UIProgressView *  ProgressView;

@end
