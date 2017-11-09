//
//  LeftMenuView.h
//  BleRobot
//
//  Created by zh dk on 2017/9/5.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeMenuViewDelegate <NSObject>

-(void) LeftMenuViewClick:(NSInteger)tag;

@end

@interface LeftMenuView : UIView

@property (nonatomic,weak)id<HomeMenuViewDelegate> customDelegate;

@end
