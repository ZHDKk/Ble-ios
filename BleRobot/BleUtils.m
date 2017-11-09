//
//  BleUtils.m
//  BleRobot
//
//  Created by zh dk on 2017/10/12.
//  Copyright © 2017年 zh dk. All rights reserved.
//

#import "BleUtils.h"

@implementation BleUtils

//累加校验和
+(NSString *)makeCheckSum:(NSString *)data
{
    if ([data isEqualToString:@""] || data.length == 0) {
        return @"";
    }
    NSInteger  total = 0;
    NSInteger  len = data.length;
    NSInteger  num = 0;
    while (num<len) {
        NSString* s = [data substringWithRange:NSMakeRange(num, 2)];
        total+=strtol([s UTF8String], 0, 16);
        num=num+2;
    }
    NSInteger mod = total % 256;
    NSString *hex = [self getHexByDecimal:mod];
    len = hex.length;
    if (len<2) {
        hex=[@"0" stringByAppendingString:hex];
    }
    return hex;
}

/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}

//累加校验和
+(NSString *)makeCheckSumSmall:(NSString *)data
{
    if ([data isEqualToString:@""] || data.length == 0) {
        return @"";
    }
    NSInteger  total = 0;
    NSInteger  len = data.length;
    NSInteger  num = 0;
    while (num<len) {
        NSString* s = [data substringWithRange:NSMakeRange(num, 2)];
        total+=strtol([s UTF8String], 0, 16);
        num=num+2;
    }
    NSInteger mod = total % 256;
    NSString *hex = [self getHexByDecimalSmall:mod];
    len = hex.length;
    if (len<2) {
        hex=[@"0" stringByAppendingString:hex];
    }
    return hex;
}

/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimalSmall:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"a"; break;
            case 11:
                letter =@"b"; break;
            case 12:
                letter =@"c"; break;
            case 13:
                letter =@"d"; break;
            case 14:
                letter =@"e"; break;
            case 15:
                letter =@"f"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}

/**
 十进制转换为二进制
 
 @param decimal 十进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal {
    
    NSString *binary = @"";
    while (decimal) {
        
        binary = [[NSString stringWithFormat:@"%ld", decimal % 2] stringByAppendingString:binary];
        if (decimal / 2 < 1) {
            
            break;
        }
        decimal = decimal / 2 ;
    }
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    return binary;
}

/**
 二进制转换成十六进制
 
 @param binary 二进制数
 @return 十六进制数
 */
+ (NSString *)getHexByBinary:(NSString *)binary {
    
    NSMutableDictionary *binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    NSString *hex = @"";
    for (int i=0; i<binary.length; i+=4) {
        
        NSString *key = [binary substringWithRange:NSMakeRange(i, 4)];
        NSString *value = [binaryDic objectForKey:key];
        if (value) {
            
            hex = [hex stringByAppendingString:value];
        }
    }
    return hex;
}

// 16进制转10进制
+ (NSNumber *) numberHexString:(NSString *)aHexString
{
    // 为空,直接返回.
    if (nil == aHexString)
    {
        return nil;
    }
    
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    
    return hexNumber;
    
}

/**
 十六进制转换为二进制
 
 @param hex 十六进制数
 @return 二进制数
 */
//+ (NSString *)getBinaryByHex:(NSString *)hex {
//
//    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
//    [hexDic setObject:@"0000" forKey:@"0"];
//    [hexDic setObject:@"0001" forKey:@"1"];
//    [hexDic setObject:@"0010" forKey:@"2"];
//    [hexDic setObject:@"0011" forKey:@"3"];
//    [hexDic setObject:@"0100" forKey:@"4"];
//    [hexDic setObject:@"0101" forKey:@"5"];
//    [hexDic setObject:@"0110" forKey:@"6"];
//    [hexDic setObject:@"0111" forKey:@"7"];
//    [hexDic setObject:@"1000" forKey:@"8"];
//    [hexDic setObject:@"1001" forKey:@"9"];
//    [hexDic setObject:@"1010" forKey:@"a"];
//    [hexDic setObject:@"1011" forKey:@"b"];
//    [hexDic setObject:@"1100" forKey:@"c"];
//    [hexDic setObject:@"1101" forKey:@"d"];
//    [hexDic setObject:@"1110" forKey:@"e"];
//    [hexDic setObject:@"1111" forKey:@"f"];
//
//    NSString *binary = @"";
//    for (int i=0; i<[hex length]; i++) {
//
//        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
//        NSString *value = [hexDic objectForKey:key.uppercaseString];
//        if (value) {
//
//            binary = [binary stringByAppendingString:value];
//        }
//    }
//    return binary;
//}

+(NSString *)getBinaryByHex:(NSString *)hex
{
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"a"];
    
    [hexDic setObject:@"1011" forKey:@"b"];
    
    [hexDic setObject:@"1100" forKey:@"c"];
    
    [hexDic setObject:@"1101" forKey:@"d"];
    
    [hexDic setObject:@"1110" forKey:@"e"];
    
    [hexDic setObject:@"1111" forKey:@"f"];
    
    NSMutableString *binaryString=[[NSMutableString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        //NSLog(@"%@",[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]);
        
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    //NSLog(@"转化后的二进制为:%@",binaryString);
    
    return binaryString;
    
}

/**
 二进制转换为十进制
 
 @param binary 二进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalByBinary:(NSString *)binary {
    
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    return decimal;
}

//将十六进制的字符串转换成NSString则可使用如下方式:
+ (NSString *)convertHexStrToString:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    NSString *string = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
    return string;
}

//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertStringToHexStr:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


@end
