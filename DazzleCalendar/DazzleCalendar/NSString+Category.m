//
//  NSString+isBlank.m
//  BangBang
//
//  Created by lottak_mac2 on 16/5/20.
//  Copyright © 2016年 Lottak. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (isBlank)

+ (BOOL)isBlank:(NSString*)str
{
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([str isEqualToString:@"null"])
        return YES;
    return NO;
}

+ (BOOL)isPhoneNumber:(NSString *)string
{
    if (![string hasPrefix:@"1"]) {
        return NO;
    }
    NSString * MOBILE = @"^[1-9]\\d{10}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return  [regextestMobile evaluateWithObject:string];
}
+ (NSString*)simplePhoneString:(NSString *)str {
    if([self isBlank:str])
        return @"";
    //如果长度小于4，没办法玩了，随便返回一个吧
    if(str.length < 4)
        return @"134****428";
    return [NSString stringWithFormat:@"%@****%@",[str substringWithRange:NSMakeRange(0, 3)],[str substringWithRange:NSMakeRange(str.length - 4, 4)]];
}
+ (NSString*)simpleEmailString:(NSString *)str {
    if([self isBlank:str])
        return @"";
    //没有@，没办法玩了，随便返回一个吧
    if(![str containsString:@"@"])
        return @"yh****@163.com";
    //如果有@，那么就需要取前后的字符串来拼接
    NSRange range = [str rangeOfString:@"@"];
    NSString *frontString = [str substringToIndex:range.location];
    if(frontString.length > 3)
        frontString = [frontString substringToIndex:3];
    NSString *beforeString = [str substringFromIndex:range.location];
    return [NSString stringWithFormat:@"%@****%@",frontString,beforeString];
}
//密码强度0 1 2 3 4 ，0、1表示弱 2 表示中 3、4表示强
+ (int)passwordStrength:(NSString*)string {
    int passwordStrength = 0;
    //是否包含大写字母
    NSString * upperCase = @".*[A-Z].*";
    NSPredicate *regextestupperCase = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", upperCase];
    if([regextestupperCase evaluateWithObject:string])
        passwordStrength ++;
    //是否包含小写字母
    NSString * lowerCase = @".*[a-z].*";
    NSPredicate *regextestlowerCase = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", lowerCase];
    if([regextestlowerCase evaluateWithObject:string])
        passwordStrength ++;
    //是否包含数字
    NSString * numbers = @".*[1-9].*";
    NSPredicate *regextestnumbers = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numbers];
    if([regextestnumbers evaluateWithObject:string])
        passwordStrength ++;
    //是否包含特殊符号
    NSString * specialchars = @".*[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？].*";
    NSPredicate *regextestspecialchars = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", specialchars];
    if([regextestspecialchars evaluateWithObject:string])
        passwordStrength ++;
    if(string.length < 8)
        passwordStrength --;
    return passwordStrength;
}
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}
- (NSString*)firstChar
{
    if([NSString isBlank:self])
        return @"#";
    NSMutableString *source = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *str = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *ss = [[NSString stringWithFormat:@"%@",[source substringToIndex:1]] uppercaseString];
    if([str rangeOfString:ss].location == NSNotFound)
        return @"#";
    return ss;
}

@end
