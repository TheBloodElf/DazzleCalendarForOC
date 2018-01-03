//
//  WeekCollectionCell.m
//  RealmDemo
//
//  Created by Mac on 2018/1/2.
//  Copyright © 2018年 com.luohaifang. All rights reserved.
//

#import "WeekCollectionCell.h"

@interface WeekCollectionCell () {
    NSMutableArray<DazzleCalendarDayView*> *_dayViews;
    NSCalendar *_nSCalender;//弄成单例，内存占用太多
}

@end

@implementation WeekCollectionCell

- (void)reloadCurrWeek {
    self.backgroundColor = [UIColor clearColor];
    //初始化
    if(!_weekSendDates)
        _weekSendDates = [@[] mutableCopy];
    if(!_nSCalender)
        _nSCalender = [NSCalendar currentCalendar];
    if(!_dayViews)
        _dayViews = [@[] mutableCopy];
    //添加界面
    if(_dayViews.count == 0) {
        //宽高
        float itemWidth = self.frame.size.width / 7;
        float itemHeight = self.frame.size.height;
        for (int indexY = 0; indexY < 7; indexY ++) {
            DazzleCalendarDayView *dayView = [[DazzleCalendarDayView alloc] initWithFrame:CGRectMake(itemWidth * indexY, 0, itemWidth, itemHeight)];
            [self addSubview:dayView];
            [_dayViews addObject:dayView];
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectDayView:)];
            [dayView addGestureRecognizer:tgr];
        }
    }
    //获取这个月的第一天
    //获取当前日历页面应该显示的第一天
    NSDate *firstDayOfWeek = _weekSendDate;
    if(firstDayOfWeek.weekday != 7) {
        firstDayOfWeek = [NSDate dateWithTimeIntervalSince1970:firstDayOfWeek.timeIntervalSince1970 - 24 * 60 * 60 * firstDayOfWeek.weekday];
    }
    //累计填充7天
    NSMutableArray<NSDate*> *tempArray = [@[] mutableCopy];
    [tempArray addObject:firstDayOfWeek];
    for (int index = 0; index < 6; index ++) {
        firstDayOfWeek = [firstDayOfWeek dateByAddingTimeInterval:24 * 60 * 60];
        [tempArray addObject:firstDayOfWeek];
    }
    [_weekSendDates removeAllObjects];
    [_weekSendDates addObjectsFromArray:tempArray];
    //刷新一下表格视图
    for (int index = 0; index < _weekSendDates.count; index ++) {
        DazzleCalendarDayView *dayView = _dayViews[index];
        dayView.dayDate = _weekSendDates[index];
        dayView.calendarType = DazzleCalendarWeek;
        dayView.monthWeekDate = _weekSendDate;
        if(self.delegate && [self.delegate respondsToSelector:@selector(didShowDayView:)]) {
            [self.delegate didShowDayView:dayView];
        }
    }
}
- (void)didSelectDayView:(UITapGestureRecognizer*)tgr {
    DazzleCalendarDayView *dayView = (DazzleCalendarDayView*)tgr.view;
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectDayView:)]) {
        [self.delegate didSelectDayView:dayView];
    }
}

@end
