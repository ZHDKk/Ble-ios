//
//  CQHud.h
//  BleRobot
//
//  Created by zh dk on 2017/10/25.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface CQHud : UIView

+(void)LoadingShow;
+(void)LoadingDismiss;
@end
