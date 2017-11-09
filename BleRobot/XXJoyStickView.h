//
//  XXJoyStickView.h
//  JoyStickView
//
//  Created by zh dk on 2017/11/06.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AngleBlock)(float sinX, float sinY);

@interface XXJoyStickView : UIView

#pragma mark -- 属性
@property(nonatomic,strong)AngleBlock angleBlock;       // 控制器回传角度

#pragma mark -- 方法
- (instancetype)initWithFrame:(CGRect)frame;

@end
