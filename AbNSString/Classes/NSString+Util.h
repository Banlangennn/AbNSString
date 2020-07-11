//
//  NSString+Util.h
//  HYMusicComponent
//
//  Created by 刘倩 on 2019/6/6.
//  Copyright © 2019年 CMCC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

+ (NSString *)stringWithInt:(int)intValue;
+ (NSString *)stringWithInteger:(NSInteger)integerValue;

// 是否包含emoji
- (BOOL)containEmoji;
// 是否包含中文
- (BOOL)containChinese;
// 是否全是中文
- (BOOL)allChinese;
// 手机号码校验
- (BOOL)checkMobile;

// UTF-8编码
- (NSString *)encodedURLString;
// UTF-解码
- (NSString *)decodedURLString;

// Json
- (id)jsonValue;

// 过滤后只包含中文
- (NSString *)filterRetainChinese;


@end

