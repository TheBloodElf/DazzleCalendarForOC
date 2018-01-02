//
//  DazzleCalendar.h
//  RealmDemo
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 com.luohaifang. All rights reserved.
//

#import "DazzleCalendarDayView.h"

//我们做这个视图讲究的是取巧，为了做到华为日历的效果，我们周月视图并存来实现，这个不难理解

//自己做日历控件，目前只支持月视图
@protocol DazzleCalendarDelegate <NSObject>

//日历某一天视图展示，颜色文字，是否显示全部由外面控制
- (void)didShowDayView:(DazzleCalendarDayView*)dayView;
//用户选中了某一天
- (void)didSelectDayView:(DazzleCalendarDayView*)dayView;
//日程显示到了当前种子时间
- (void)didShowSendDate:(NSDate*)sendDate;

@end

@interface DazzleCalendar : UIView
//日历 周、月 默认周
@property (nonatomic, assign) DazzleCalendarType calendarType;
@property (nonatomic, weak) id<DazzleCalendarDelegate> delegate;
@property (nonatomic, strong) UICollectionView *monthCollectionView;//月表格视图
@property (nonatomic, strong) UICollectionView *weekCollectionView;//月表格视图
//配置月视图
- (void)configMonthCalendar;
//让月视图显示当前时间
- (void)setMonthSendDate:(NSDate*)sendDate;
//配置周视图
- (void)configWeekCalendar;
//让周视图显示当前时间
- (void)setWeekSendDate:(NSDate*)sendDate;
@end
