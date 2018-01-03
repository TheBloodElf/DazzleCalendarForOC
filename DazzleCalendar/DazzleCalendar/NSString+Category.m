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
@end
