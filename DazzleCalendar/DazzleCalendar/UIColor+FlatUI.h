//
//  UIColor+FlatUI.h
//  FlatUI
//
//  Created by Jack Flintermann on 5/3/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

@interface UIColor (FlatUI)

//新版导航栏颜色全部统一为此
+ (UIColor *) bangbangNavColor;
+ (UIColor *) colorFromHexCode:(NSString *)hexString ;
+ (UIColor *) blendedColorWithForegroundColor:(UIColor *)foregroundColor
                              backgroundColor:(UIColor *)backgroundColor
                                 percentBlend:(CGFloat) percentBlend;
@end
