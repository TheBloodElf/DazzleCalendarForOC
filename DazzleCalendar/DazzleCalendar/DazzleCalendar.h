//
//  DazzleCalendar.h
//  RealmDemo
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 com.luohaifang. All rights reserved.
//

#import "DazzleCalendarDayView.h"
#import "SubDazzleCalendarView.h"

//我们做这个视图讲究的是取巧，为了做到华为日历的效果，我们周月视图并存来实现，这个不难理解
//本日历的每一天、周高度为42.5，所以很多地方是写死的，主要提供的是思路

//自己做日历控件，目前只支持月视图
@protocol DazzleCalendarDelegate <NSObject>

//日历某一天视图展示，颜色文字，是否显示全部由外面控制
- (void)didShowDayView:(DazzleCalendarDayView*)dayView;
//用户选中了某一天
- (void)didSelectDate:(NSDate*)date;
//已经滚动到了了当前月、周
- (void)didScrollDate:(NSDate*)date;
//已经显示了当前月、周时间
- (void)didLoadDate:(NSDate*)date;

@end

@interface DazzleCalendar : UIView

//月视图的滚动视图 高度为255
@property (nonatomic, strong) UIScrollView *monthScrollView;
//周视图的滚动视图 高度为42.5
@property (nonatomic, strong) UIScrollView *weekScrollView;
//日历 周、月 默认周
@property (nonatomic, assign) DazzleCalendarType calendarType;
@property (nonatomic, weak) id<DazzleCalendarDelegate> delegate;

//初始化日历，周视图还是月视图
- (instancetype)initWithFrame:(CGRect)frame calendarType:(DazzleCalendarType)calendarType;
//让日历显示当前月、周的时间
- (void)showDate:(NSDate*)date;

@end
