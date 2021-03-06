//
//  CalendarCollectionCell.m
//  RealmDemo
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 com.luohaifang. All rights reserved.
//

#import "DazzleCalendarDayView.h"

@interface DazzleCalendarDayView ()

@end

@implementation DazzleCalendarDayView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    //得到最小的宽高
    CGFloat minWidthHeight = frame.size.width;
    if(minWidthHeight > frame.size.height)
        minWidthHeight = frame.size.height;
    //背景圆
    if(_solidBgView == nil) {
        _solidBgView = [[UIView alloc] initWithFrame:CGRectMake(0.5 * (frame.size.width - minWidthHeight), 0.5 * (frame.size.height - minWidthHeight), minWidthHeight, minWidthHeight)];
        _solidBgView.layer.cornerRadius = minWidthHeight/2;
        _solidBgView.clipsToBounds = YES;
        [self addSubview:_solidBgView];
    }
    //中间的文本框
    if(_dateHolidayLabel == nil) {
        _dateHolidayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.5 * (frame.size.height - 12), frame.size.width, 12)];
        _dateHolidayLabel.font = [UIFont systemFontOfSize:12];
        _dateHolidayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateHolidayLabel];
    }
}

@end
