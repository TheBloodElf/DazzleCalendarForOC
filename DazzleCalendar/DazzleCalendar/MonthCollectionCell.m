//
//  MonthCollectionCell.m
//  RealmDemo
//
//  Created by Mac on 2018/1/1.
//  Copyright © 2018年 com.luohaifang. All rights reserved.
//

#import "MonthCollectionCell.h"

@interface MonthCollectionCell () {
    NSMutableArray<DazzleCalendarDayView*> *_dayViews;
    NSCalendar *_nSCalender;//弄成单例，内存占用太多
}

@end

@implementation MonthCollectionCell

- (void)reloadCurrMonth {
    self.backgroundColor = [UIColor clearColor];
    //初始化
    if(!_monthSendDates)
        _monthSendDates = [@[] mutableCopy];
    if(!_nSCalender)
        _nSCalender = [NSCalendar currentCalendar];
    if(!_dayViews)
        _dayViews = [@[] mutableCopy];
    //添加界面
    if(_dayViews.count == 0) {
        //宽高
        float itemWidth = self.frame.size.width / 7;
        float itemHeight = self.frame.size.height / 6;
        for (int indexX = 0; indexX < 6 ; indexX ++) {
            for (int indexY = 0; indexY < 7; indexY ++) {
                DazzleCalendarDayView *dayView = [[DazzleCalendarDayView alloc] initWithFrame:CGRectMake(itemWidth * indexY, itemHeight * indexX, itemWidth, itemHeight)];
                [self addSubview:dayView];
                [_dayViews addObject:dayView];
                UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectDayView:)];
                [dayView addGestureRecognizer:tgr];
            }
        }
    }
    //获取这个月的第一天
    NSDateComponents *leftCmp = [_nSCalender components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:_monthSendDate];
    [leftCmp setDay:1];
    NSDate *firstDay = [_nSCalender dateFromComponents:leftCmp];
    //获取当前日历页面应该显示的第一天
    NSDate *firstDayOfMonth;
    if(firstDay.weekday == 7)
        firstDayOfMonth = firstDay;
    else
        firstDayOfMonth = [NSDate dateWithTimeIntervalSince1970:firstDay.timeIntervalSince1970 - 24 * 60 * 60 * firstDay.weekday];
    //累计填充42天
    NSMutableArray<NSDate*> *tempArray = [@[] mutableCopy];
    [tempArray addObject:firstDayOfMonth];
    for (int index = 0; index < 41; index ++) {
        firstDayOfMonth = [firstDayOfMonth dateByAddingTimeInterval:24 * 60 * 60];
        [tempArray addObject:firstDayOfMonth];
    }
    [_monthSendDates removeAllObjects];
    [_monthSendDates addObjectsFromArray:tempArray];
    //刷新一下表格视图
    for (int index = 0; index < _monthSendDates.count; index ++) {
        DazzleCalendarDayView *dayView = _dayViews[index];
        dayView.dayDate = _monthSendDates[index];
        dayView.calendarType = DazzleCalendarMonth;
        dayView.monthWeekDate = _monthSendDate;
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
