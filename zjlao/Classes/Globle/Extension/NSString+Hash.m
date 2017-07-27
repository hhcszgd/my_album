
//
//  NSString+Hash.m
//  01-数据安全
//
//  Created by wangyuanfei on 14/11/12.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSString+Hash.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (Hash)

#pragma mark - 散列函数


NSDate * _previousDate = nil  ;

- (NSString *)md5String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)sha1String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha256String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha512String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - HMAC 散列函数
- (NSString *)hmacMD5StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)hmacSHA256StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)hmacSHA512StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - 文件散列函数

#define FileHashDefaultChunkSizeForReadingData 4096

- (NSString *)fileMD5Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_MD5_CTX hashCtx;
    CC_MD5_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)fileSHA1Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA1_CTX hashCtx;
    CC_SHA1_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)fileSHA256Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA256_CTX hashCtx;
    CC_SHA256_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)fileSHA512Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA512_CTX hashCtx;
    CC_SHA512_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - 助手方法
/**
 *  返回二进制 Bytes 流的字符串表示形式
 *
 *  @param bytes  二进制 Bytes 数组
 *  @param length 数组长度
 *
 *  @return 字符串表示形式
 */
- (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return [strM copy];
}

- (NSString *)customFirstCharUpper
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}



-(NSString*)convertToYuan{
    if (self.length==0) {
        return @"null";
    }else if (self.length == 1){
        return [[NSString stringWithFormat:@"0.0%@",self] cutLastZero];
    }else if (self.length == 2 ){
        return [[NSString stringWithFormat:@"0.%@",self] cutLastZero];
    }else{
        NSString * lastTwo = [self substringWithRange:NSMakeRange(self.length-2, 2)];
        NSString * targetPrice = [self stringByReplacingOccurrencesOfString:lastTwo withString:[NSString stringWithFormat:@".%@",lastTwo] options:NSBackwardsSearch range:NSMakeRange(self.length-2, 2)];
        return [targetPrice cutLastZero];
    }
}

/** 元转换成分 */
-(NSString*)convertToFen{//好笨 , 应该用正则
    if ([self containsString:@"."]) {
        NSRange pointRange = [self rangeOfString:@"."];
        NSString * lastStr = [self substringFromIndex:pointRange.location];
        if (lastStr.length==2) {
            NSString * temp = [self stringByReplacingOccurrencesOfString:@"." withString:@""];
            return [temp stringByAppendingString:@"0"];
        }else if (lastStr.length==3){
            return [self stringByReplacingOccurrencesOfString:@"." withString:@""];
        }else{
            NSString * temp = [lastStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString * tempPrefix = [temp substringToIndex:2];
            NSString * tempSuffix = [temp substringFromIndex:2];
            return [self stringByReplacingOccurrencesOfString:lastStr withString:[NSString stringWithFormat:@"%@.%@",tempPrefix,tempSuffix]];
        }
    }else{
        if ([self isEqualToString:@"0"]) {
            return self;
        }else{
            return [self stringByAppendingString:@"00"];
        }
    }
    
}
-(NSString*)cutLastZero
{
    if ([self hasSuffix:@".00"]) {
        return [self stringByReplacingOccurrencesOfString:@".00" withString:@"" options:NSBackwardsSearch range:NSMakeRange(self.length-3, 3)];
    }else if ([self hasSuffix:@".0"]){
        return [self stringByReplacingOccurrencesOfString:@".0" withString:@"" options:NSBackwardsSearch range:NSMakeRange(self.length-2, 2)];
    }else{
        return self;
    }
}

/** 返回只显示年月日 */
-(NSString*)formatterDateString{
    
    /////////
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone localTimeZone]];
    NSDate * targetDate = nil;
    
    for (NSString * formatterStr in self.dateFormatters) {
        [formater setDateFormat:formatterStr];
        targetDate =  [formater dateFromString:self];
        if (targetDate) {
            [formater setDateFormat:@"yyyy.MM.dd"];
            
            return [formater  stringFromDate:targetDate] ;
        }
    }
    //
    //
    //
    //    [formater setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //    targetDate = [formater dateFromString:dateStr];
    //    if (!targetDate) {
    //        [formater  setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
    //    }
    //    NSString * startTime = [self.composeModel.start_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    //
    //
    //    [formater setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //    NSDate * startDate = [formater dateFromString:@"2011-11-11"];
    //    LOG(@"_%@_%d_%@",[self class] , __LINE__,startDate);
    //    [formater setDateFormat:@"yyyy.MM.dd"];
    //    NSString * startstr =  [formater  stringFromDate:startDate];
    //    LOG(@"_%@_%d_%@",[self class] , __LINE__,startstr);
    
    ///////////
    return self ;
}

-(NSArray*)dateFormatters
{
    return [NSArray arrayWithObjects:@"yyyy-MM-dd HH:mm:ss",@"yyyy.MM.dd HH:mm:ss",@"yyyy MM dd HH:mm:ss",@"yyyy-MM-dd",@"yyyy.MM.dd",@"yyyy MM dd",@"yyyy-MM-dd HH:mm:ss zzzz", nil];
}




-(NSString*)formatterDateStringToMinute{
    if (!_previousDate) {
        _previousDate = [NSDate date];
        //        _previousDate.t
    }
    /////////
    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDate * targetDate = nil;
    
    for (NSString * formatterStr in self.dateFormatters) {
        [formater setDateFormat:formatterStr];
        targetDate =  [formater dateFromString:self];
        if (targetDate) {
            if ([targetDate timeIntervalSinceDate : [NSDate date]]< 60 * 60 *24) {
                if ([_previousDate  timeIntervalSinceDate:targetDate]<60 *10 /** 十分钟显示一次 */) {
                    return nil;
                }else{
                    _previousDate = targetDate;
                    [formater setDateFormat:@"今天 HH:mm"];
                }
            }else{
                if ([_previousDate  timeIntervalSinceDate:targetDate]<60 *10 /** 十分钟显示一次 */) {
                    return nil;
                }else{
                    _previousDate = targetDate;
                    [formater setDateFormat:@"yyyy.MM.dd HH:mm"];
                }
            }
            NSString * thereturnStr = [formater  stringFromDate:targetDate] ;
            return  thereturnStr ;
        }
    }
    //
    //
    //
    //    [formater setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //    targetDate = [formater dateFromString:dateStr];
    //    if (!targetDate) {
    //        [formater  setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
    //    }
    //    NSString * startTime = [self.composeModel.start_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    //
    //
    //    [formater setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //    NSDate * startDate = [formater dateFromString:@"2011-11-11"];
    //    LOG(@"_%@_%d_%@",[self class] , __LINE__,startDate);
    //    [formater setDateFormat:@"yyyy.MM.dd"];
    //    NSString * startstr =  [formater  stringFromDate:startDate];
    //    LOG(@"_%@_%d_%@",[self class] , __LINE__,startstr);
    
    ///////////
    return self ;
}
//
///** 解析属性字符串 */
//-(NSAttributedString*)dealStrWithLabelFont:(UIFont*)font;{
//    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"/[a-zA-Z]+;" options:NSRegularExpressionCaseInsensitive error:nil];
//    
//    NSArray * matches = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
//    NSMutableAttributedString * attM = [[NSMutableAttributedString alloc]init];
//    /** 就这一个地方用 , 就不用三方框架了 , 自己写吧, */
//    if (matches.count>0) {
//        for (int i = 0 ; i< matches.count; i++) {
//            NSTextCheckingResult * result = matches[i];
//            NSString * imgName = [self substringWithRange:result.range];
//            /** 获取图片名 */
//            imgName=  [imgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
//            imgName= [imgName stringByReplacingOccurrencesOfString:@";" withString:@""];
//            
//            /** 创建富文本 */
//            GDTextAttachment * tachment = [[GDTextAttachment alloc]init];
//            UIImage* gif = [UIImage sd_animatedGIFNamed:gotResourceInSubBundle(imgName, @"gif", @"face_img")];
//            //            tachment.image = [UIImage imageWithContentsOfFile:gotResourceInSubBundle(imgName, @"gif", @"face_img")];
//            tachment.image = gif;
//            tachment.bounds = CGRectMake(0, -4, font.lineHeight, font.lineHeight);
//            NSAttributedString * imgStr = [NSAttributedString attributedStringWithAttachment:tachment];
//            
//            
//            if (i==0) {//第一个
//                if (result.range.location==0) {//第一个是表情
//                }else{//第一个非表情
//                    NSString * sub = [self substringWithRange:NSMakeRange(0, result.range.location)];
//                    //                    LOG(@"_%@_%d_%@",[self class] , __LINE__,sub);
//                    [attM appendAttributedString:  [ [NSAttributedString alloc] initWithString:sub]];
//                }
//                [attM appendAttributedString:imgStr];
//                if (matches.count==1 && result.range.location + result.range.length < self.length) {
//                    NSString * subsub = [self substringFromIndex:result.range.location + result.range.length];
//                    [attM appendAttributedString:[ [NSAttributedString alloc] initWithString:subsub]];
//                    LOG(@"_%@_%d_%@",[self class] , __LINE__,subsub);
//                }
//            }else  if(i < matches.count-1){//中间
//                
//                NSTextCheckingResult * lastResult = matches[i-1];
//                NSString * sub = [self substringWithRange:NSMakeRange(lastResult.range.location+lastResult.range.length, result.range.location-(lastResult.range.location+lastResult.range.length))];
//                //                LOG(@"_%@_%d_%@",[self class] , __LINE__,sub);
//                [attM appendAttributedString:  [ [NSAttributedString alloc] initWithString:sub]];
//                [attM appendAttributedString:imgStr];
//                //                    LOG(@"_%@_%d_%@",[self class] , __LINE__,sub);
//                
//                
//                
//            }else{
//                NSTextCheckingResult * lastResult = matches[i-1];
//                NSString * sub = [self substringWithRange:NSMakeRange(lastResult.range.location+lastResult.range.length, result.range.location-(lastResult.range.location+lastResult.range.length))];
//                [attM appendAttributedString:  [ [NSAttributedString alloc] initWithString:sub]];
//                [attM appendAttributedString:imgStr];
//                //                LOG(@"_%@_%d_%@",[self class] , __LINE__,sub);
//                if (result.range.location + result.range.length < self.length) {//最后一个是文本
//                    NSString * subsub = [self substringFromIndex:result.range.location + result.range.length];
//                    [attM appendAttributedString:[ [NSAttributedString alloc] initWithString:subsub]];
//                    LOG(@"_%@_%d_%@",[self class] , __LINE__,subsub);
//                }else{//最后一个是表情
//                    
//                }
//                
//            }
//            
//        }
//        
//    }else {
//        NSMutableAttributedString * returnstr  = [[NSMutableAttributedString alloc]initWithString:self] ;
//        [returnstr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, returnstr.length)];
//        return returnstr;
//        
//    }
//    
//    
//    
//    
//    [attM addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attM.length)];
//    return attM;
//    
//    //        return  [[NSMutableAttributedString alloc]initWithString:str];
//}

@end






















































////
////  NSString+Hash.m
////  01-数据安全
////
////  Created by wangyuanfei on 14/11/12.
////  Copyright (c) 2014年 itcast. All rights reserved.
////
//
//#import "NSString+Hash.h"
//#import <CommonCrypto/CommonCrypto.h>
//
//@implementation NSString (Hash)
//
//#pragma mark - 散列函数
//
//
//NSDate * _previousDate = nil  ;
//
//- (NSString *)md5String {
//    const char *str = self.UTF8String;
//    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
//    
//    CC_MD5(str, (CC_LONG)strlen(str), buffer);
//    
//    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
//}
//
//- (NSString *)sha1String {
//    const char *str = self.UTF8String;
//    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
//    
//    CC_SHA1(str, (CC_LONG)strlen(str), buffer);
//    
//    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
//}
//
//- (NSString *)sha256String {
//    const char *str = self.UTF8String;
//    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
//    
//    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
//    
//    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
//}
//
//- (NSString *)sha512String {
//    const char *str = self.UTF8String;
//    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
//    
//    CC_SHA512(str, (CC_LONG)strlen(str), buffer);
//    
//    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
//}
//
//#pragma mark - HMAC 散列函数
//- (NSString *)hmacMD5StringWithKey:(NSString *)key {
//    const char *keyData = key.UTF8String;
//    const char *strData = self.UTF8String;
//    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
//    
//    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);
//    
//    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
//}
//
//- (NSString *)hmacSHA1StringWithKey:(NSString *)key {
//    const char *keyData = key.UTF8String;
//    const char *strData = self.UTF8String;
//    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
//    
//    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);
//    
//    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
//}
//
//- (NSString *)hmacSHA256StringWithKey:(NSString *)key {
//    const char *keyData = key.UTF8String;
//    const char *strData = self.UTF8String;
//    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
//    
//    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);
//    
//    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
//}
//
//- (NSString *)hmacSHA512StringWithKey:(NSString *)key {
//    const char *keyData = key.UTF8String;
//    const char *strData = self.UTF8String;
//    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
//    
//    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);
//    
//    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
//}
//
//#pragma mark - 文件散列函数
//
//#define FileHashDefaultChunkSizeForReadingData 4096
//
//- (NSString *)fileMD5Hash {
//    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
//    if (fp == nil) {
//        return nil;
//    }
//    
//    CC_MD5_CTX hashCtx;
//    CC_MD5_Init(&hashCtx);
//    
//    while (YES) {
//        @autoreleasepool {
//            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
//            
//            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
//            
//            if (data.length == 0) {
//                break;
//            }
//        }
//    }
//    [fp closeFile];
//    
//    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
//    CC_MD5_Final(buffer, &hashCtx);
//    
//    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
//}
//
//- (NSString *)fileSHA1Hash {
//    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
//    if (fp == nil) {
//        return nil;
//    }
//    
//    CC_SHA1_CTX hashCtx;
//    CC_SHA1_Init(&hashCtx);
//    
//    while (YES) {
//        @autoreleasepool {
//            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
//            
//            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
//            
//            if (data.length == 0) {
//                break;
//            }
//        }
//    }
//    [fp closeFile];
//    
//    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
//    CC_SHA1_Final(buffer, &hashCtx);
//    
//    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
//}
//
//- (NSString *)fileSHA256Hash {
//    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
//    if (fp == nil) {
//        return nil;
//    }
//    
//    CC_SHA256_CTX hashCtx;
//    CC_SHA256_Init(&hashCtx);
//    
//    while (YES) {
//        @autoreleasepool {
//            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
//            
//            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
//            
//            if (data.length == 0) {
//                break;
//            }
//        }
//    }
//    [fp closeFile];
//    
//    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
//    CC_SHA256_Final(buffer, &hashCtx);
//    
//    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
//}
//
//- (NSString *)fileSHA512Hash {
//    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
//    if (fp == nil) {
//        return nil;
//    }
//    
//    CC_SHA512_CTX hashCtx;
//    CC_SHA512_Init(&hashCtx);
//    
//    while (YES) {
//        @autoreleasepool {
//            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
//            
//            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
//            
//            if (data.length == 0) {
//                break;
//            }
//        }
//    }
//    [fp closeFile];
//    
//    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
//    CC_SHA512_Final(buffer, &hashCtx);
//    
//    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
//}
//
//#pragma mark - 助手方法
///**
// *  返回二进制 Bytes 流的字符串表示形式
// *
// *  @param bytes  二进制 Bytes 数组
// *  @param length 数组长度
// *
// *  @return 字符串表示形式
// */
//- (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
//    NSMutableString *strM = [NSMutableString string];
//    
//    for (int i = 0; i < length; i++) {
//        [strM appendFormat:@"%02x", bytes[i]];
//    }
//    
//    return [strM copy];
//}
//
//- (NSString *)customFirstCharUpper
//{
//    if (self.length == 0) return self;
//    NSMutableString *string = [NSMutableString string];
//    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
//    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
//    return string;
//}
//
//
//
//-(NSString*)convertToYuan{
//    if (self.length==0) {
//        return @"null";
//    }else if (self.length == 1){
//        return [[NSString stringWithFormat:@"0.0%@",self] cutLastZero];
//    }else if (self.length == 2 ){
//        return [[NSString stringWithFormat:@"0.%@",self] cutLastZero];
//    }else{
//        NSString * lastTwo = [self substringWithRange:NSMakeRange(self.length-2, 2)];
//        NSString * targetPrice = [self stringByReplacingOccurrencesOfString:lastTwo withString:[NSString stringWithFormat:@".%@",lastTwo] options:NSBackwardsSearch range:NSMakeRange(self.length-2, 2)];
//        return [targetPrice cutLastZero];
//    }
//}
//
///** 元转换成分 */
//-(NSString*)convertToFen{//好笨 , 应该用正则
//    if ([self containsString:@"."]) {
//        NSRange pointRange = [self rangeOfString:@"."];
//        NSString * lastStr = [self substringFromIndex:pointRange.location];
//        if (lastStr.length==2) {
//            NSString * temp = [self stringByReplacingOccurrencesOfString:@"." withString:@""];
//            return [temp stringByAppendingString:@"0"];
//        }else if (lastStr.length==3){
//            return [self stringByReplacingOccurrencesOfString:@"." withString:@""];
//        }else{
//            NSString * temp = [lastStr stringByReplacingOccurrencesOfString:@"." withString:@""];
//            NSString * tempPrefix = [temp substringToIndex:2];
//            NSString * tempSuffix = [temp substringFromIndex:2];
//            return [self stringByReplacingOccurrencesOfString:lastStr withString:[NSString stringWithFormat:@"%@.%@",tempPrefix,tempSuffix]];
//        }
//    }else{
//        if ([self isEqualToString:@"0"]) {
//            return self;
//        }else{
//            return [self stringByAppendingString:@"00"];
//        }
//    }
//
//}
//-(NSString*)cutLastZero
//{
//    if ([self hasSuffix:@".00"]) {
//        return [self stringByReplacingOccurrencesOfString:@".00" withString:@"" options:NSBackwardsSearch range:NSMakeRange(self.length-3, 3)];
//    }else if ([self hasSuffix:@".0"]){
//        return [self stringByReplacingOccurrencesOfString:@".0" withString:@"" options:NSBackwardsSearch range:NSMakeRange(self.length-2, 2)];
//    }else{
//        return self;
//    }
//}
//
///** 返回只显示年月日 */
//-(NSString*)formatterDateString{
//
//    /////////
//    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
//    [formater setTimeZone:[NSTimeZone localTimeZone]];
//    NSDate * targetDate = nil;
//    
//    for (NSString * formatterStr in self.dateFormatters) {
//        [formater setDateFormat:formatterStr];
//        targetDate =  [formater dateFromString:self];
//        if (targetDate) {
//              [formater setDateFormat:@"yyyy.MM.dd"];
//            
//            return [formater  stringFromDate:targetDate] ;
//        }
//    }
////    
////    
////    
////    [formater setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
////    targetDate = [formater dateFromString:dateStr];
////    if (!targetDate) {
////        [formater  setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
////    }
////    NSString * startTime = [self.composeModel.start_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
////    
////
////    [formater setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
////    NSDate * startDate = [formater dateFromString:@"2011-11-11"];
////    LOG(@"_%@_%d_%@",[self class] , __LINE__,startDate);
////    [formater setDateFormat:@"yyyy.MM.dd"];
////    NSString * startstr =  [formater  stringFromDate:startDate];
////    LOG(@"_%@_%d_%@",[self class] , __LINE__,startstr);
//    
//    ///////////
//    return self ;
//}
//
//-(NSArray*)dateFormatters
//{
//    return [NSArray arrayWithObjects:@"yyyy-MM-dd HH:mm:ss",@"yyyy.MM.dd HH:mm:ss",@"yyyy MM dd HH:mm:ss",@"yyyy-MM-dd",@"yyyy.MM.dd",@"yyyy MM dd",@"yyyy-MM-dd HH:mm:ss zzzz", nil];
//}
//-(NSString*)formatterDateStringToMinute{
//    if (!_previousDate) {
//        _previousDate = [NSDate date];
////        _previousDate.t
//    }
//    /////////
//    NSDateFormatter * formater = [[NSDateFormatter alloc]init];
//    [formater setTimeZone:[NSTimeZone defaultTimeZone]];
//    NSDate * targetDate = nil;
//    
//    for (NSString * formatterStr in self.dateFormatters) {
//        [formater setDateFormat:formatterStr];
//        targetDate =  [formater dateFromString:self];
//        if (targetDate) {
//            if ([targetDate timeIntervalSinceDate : [NSDate date]]< 60 * 60 *24) {
//                if ([_previousDate  timeIntervalSinceDate:targetDate]<60 *10 /** 十分钟显示一次 */) {
//                    return nil;
//                }else{
//                    _previousDate = targetDate;
//                    [formater setDateFormat:@"今天 HH:mm"];
//                }
//            }else{
//                if ([_previousDate  timeIntervalSinceDate:targetDate]<60 *10 /** 十分钟显示一次 */) {
//                    return nil;
//                }else{
//                    _previousDate = targetDate;
//                    [formater setDateFormat:@"yyyy.MM.dd HH:mm"];
//                }
//            }
//            NSString * thereturnStr = [formater  stringFromDate:targetDate] ;
//            return  thereturnStr ;
//        }
//    }
//    //
//    //
//    //
//    //    [formater setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    //    targetDate = [formater dateFromString:dateStr];
//    //    if (!targetDate) {
//    //        [formater  setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
//    //    }
//    //    NSString * startTime = [self.composeModel.start_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//    //
//    //
//    //    [formater setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    //    NSDate * startDate = [formater dateFromString:@"2011-11-11"];
//    //    LOG(@"_%@_%d_%@",[self class] , __LINE__,startDate);
//    //    [formater setDateFormat:@"yyyy.MM.dd"];
//    //    NSString * startstr =  [formater  stringFromDate:startDate];
//    //    LOG(@"_%@_%d_%@",[self class] , __LINE__,startstr);
//    
//    ///////////
//    return self ;
//}
//
//@end
