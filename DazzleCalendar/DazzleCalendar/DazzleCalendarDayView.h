//
//  CalendarCollectionCell.h
//  RealmDemo
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 com.luohaifang. All rights reserved.
//


typedef NS_ENUM(NSInteger, DazzleCalendarType) {
    DazzleCalendarMonth = 0,//月视图
    DazzleCalendarWeek = 1//周视图
};
//每一天的视图
@interface DazzleCalendarDayView : UICollectionViewCell

//该天在哪一个月、周
//比较专业的说法是：改天所在月、周种子时间
@property (strong, nonatomic) NSDate *monthWeekDate;
//当天对应的时间
@property (strong, nonatomic) NSDate *dayDate;
//当天是在哪个类型的日历中 用于月、周单独设置
@property (nonatomic, assign) DazzleCalendarType calendarType;
//实心的背景圆
@property (strong, nonatomic) UIView *solidBgView;
//空心的只有边框的背景圆
@property (strong, nonatomic) UIView *hollowBgView;
//显示天数字的标签 阴历、节假日、节气标签  剧中
@property (strong, nonatomic) UILabel *dateHolidayLabel;


@end
