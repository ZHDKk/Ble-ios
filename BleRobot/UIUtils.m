//
//  UIUtils.m
//  BleRobot
//
//  Created by zh dk on 2017/10/25.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "UIUtils.h"


@implementation UIUtils

+ (void)loadingShow{
    // 获取keyWindow
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    // 添加hud
    CQHudView * hudView = [[CQHudView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [hudView setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.2]];
    [window addSubview:hudView];
    
    // 添加自定义内容（也可以封装到CQHudView里）
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    contentView.center = CGPointMake(screenWidth/2, screenHeight/2);
    [contentView setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
    contentView.layer.cornerRadius = 10;
    [hudView addSubview:contentView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
    imageView.center = CGPointMake(contentView.frame.size.width/2, 30);
    imageView.image = [UIImage imageNamed:@"toast_loading"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), contentView.frame.size.width, 20)];
    label.text = @"小主请稍候";
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor colorWithHexString:@"#ffffff"]];
    [contentView addSubview:label];
    
    //------- 旋转动画 -------//
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    // 围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    // 旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 添加动画
    [imageView.layer addAnimation:animation forKey:nil];
    [contentView addSubview:imageView];
}



@end
