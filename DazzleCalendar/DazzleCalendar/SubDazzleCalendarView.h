//
//  SubDazzleCalendarView.h
//  RealmDemo
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 com.luohaifang. All rights reserved.
//

#import "DazzleCalendarDayView.h"

//日历子项 用于显示一个月的时间
@protocol SubDazzleCalendarDelegate <NSObject>

//用户选中了某一天
- (void)didSelectDate:(NSDate*)selectDate;
//日历某一天视图展示，用户可以自己对天视图进行修改
- (void)didShowDayView:(DazzleCalendarDayView*)dayView;

@end

@interface SubDazzleCalendarView : UIView

//当前日历页显示的月、周时间
//比较专业的说法是：该月、周种子时间
@property (nonatomic, strong) NSDate *monthWeekDate;
//日历 周、月 默认周
@property (nonatomic, assign) DazzleCalendarType calendarType;
@property (nonatomic, weak) id<SubDazzleCalendarDelegate> delegate;

//初始化日历，周视图还是月视图
- (instancetype)initWithFrame:(CGRect)frame calendarType:(DazzleCalendarType)calendarType;
//显示该月的时间
- (void)showDate:(NSDate*)date;

@end
