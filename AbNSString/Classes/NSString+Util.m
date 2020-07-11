//
//  NSString+Util.m
//  HYMusicComponent
//
//  Created by 刘倩 on 2019/6/6.
//  Copyright © 2019年 CMCC. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

+ (NSString *)stringWithInt:(int)intValue
{
    return [NSString stringWithFormat:@"%d",intValue];
}

+ (NSString *)stringWithInteger:(NSInteger)integerValue
{
    return [NSString stringWithFormat:@"%d",(int)integerValue];
}

- (BOOL)containEmoji
{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            } else if (0x2100 <= hs && hs <= 0x27ff){
                returnValue =YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue =YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue =YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue =YES;
            } else {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    if (ls == 0x20e3) {
                        returnValue =YES;
                    }
                }
            }
            if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0xd83e) {
                returnValue =YES;
            }
        }
    }];
    returnValue = returnValue && ![self isNineKeyBoard];
    return returnValue;
}

// 九宫格键盘
- (BOOL)isNineKeyBoard
{
    NSString * other = @"➋➌➍➎➏➐➑➒";
    int len = (int)self.length;
    for(int i = 0; i < len; i ++) {
        if(!([other rangeOfString:self].location != NSNotFound)) {
            return NO;
        }
    }
    return YES;
}

// 是否包含中文
- (BOOL)containChinese
{
    for (int i = 0; i < self.length; i ++) {
        unichar ch = [self characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)allChinese
{
    for (int i = 0; i < self.length; i ++) {
        unichar ch = [self characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) { // 中文
            
        } else { // 非中文
            return NO;
        }
    }
    return YES;
}

// 包含空格和换行
- (BOOL)containBlank
{
    NSRange range = [self rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(range.location == NSNotFound) {
        return NO;
    }
    return YES;
}

// 手机号码校验
- (BOOL)checkMobile
{
    if (self.length != 11) {
        return NO;
    }
    // 手机号正则匹配
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^((13[0-9])|(14[5,7,9])|(15([0-3]|[5-9]))|(166)|(17[0,1,3,5,6,7,8])|(18[0-9])|(19[8|9]))\\d{8}$"];
    if (![predicate evaluateWithObject:self]) {
        return NO;
    }
    return YES;
}

// UTF-8编码
- (NSString *)encodedURLString
{
    if (![self containChinese] && ![self containBlank]) {
        return self;
    }
    NSString * utf8Str = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return utf8Str;
}

// UTF-解码
- (NSString *)decodedURLString
{
    NSString * str = [self stringByRemovingPercentEncoding];
    return str;
}

// Json
- (id)jsonValue
{
    NSData * jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id value = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    return value;
}


// 过滤后只包含中文
- (NSString *)filterRetainChinese
{
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"[^\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString * result = [regex stringByReplacingMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length) withTemplate:@""];
    return result;
}

@end
