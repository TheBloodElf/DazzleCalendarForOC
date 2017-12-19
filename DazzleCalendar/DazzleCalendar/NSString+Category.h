//
//  NSString+isBlank.h
//  BangBang
//
//  Created by lottak_mac2 on 16/5/20.
//  Copyright © 2016年 Lottak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (isBlank)
//字符串是否为空
+ (BOOL)isBlank:(NSString*)str;
//是不是纯数字
+ (BOOL)isPhoneNumber:(NSString *)string;
//隐藏电话的中间4位
+ (NSString*)simplePhoneString:(NSString *)string;
//隐藏邮箱的前面几位
+ (NSString*)simpleEmailString:(NSString *)string;
//密码强度0 1 2 3 4 ，0、1表示弱 2 表示中 3、4表示强
+ (int)passwordStrength:(NSString*)string;
/**
 * 返回字符串的 自定义 大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (NSString*)firstChar;

@end
