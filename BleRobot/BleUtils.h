//
//  BleUtils.h
//  BleRobot
//
//  Created by zh dk on 2017/10/12.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleUtils : NSObject

//累加校验和
+(NSString*)makeCheckSum:(NSString*)data;
//累加校验和
+(NSString*)makeCheckSumSmall:(NSString*)data;
//十进制转十六进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal;
//十进制转十六进制
+ (NSString *)getHexByDecimalSmall:(NSInteger)decimal;


// 16进制转10进制
+ (NSNumber *) numberHexString:(NSString *)aHexString;

//十进制转二进制
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;

//二进制转十六进制
+ (NSString *)getHexByBinary:(NSString *)binary;
//十六进制转二进制
+ (NSString *)getBinaryByHex:(NSString *)hex ;
//二进制转十六进制
+ (NSInteger)getDecimalByBinary:(NSString *)binary;

//将十六进制的字符串转换成NSString则可使用如下方式:
+ (NSString *)convertHexStrToString:(NSString *)str;
//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertStringToHexStr:(NSString *)str;


@end
