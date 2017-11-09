//
//  FaultBean.h
//  BleRobot
//
//  Created by zh dk on 2017/10/27.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaultBean : NSObject

@property(nonatomic,strong) NSString *strTime;
@property(nonatomic,strong) NSString *strStatus;

@property(nonatomic,strong) NSMutableArray *faultArray;
@end
