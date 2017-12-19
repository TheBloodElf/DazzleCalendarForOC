//
//  SubDazzleCalendarView.m
//  RealmDemo
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 com.luohaifang. All rights reserved.
//

#import "SubDazzleCalendarView.h"
#import "DazzleCalendarDayView.h"

@interface SubDazzleCalendarView ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    UILabel *_label;
    NSCalendar *_nSCalender;//弄成单例，内存占用太多
    //所有需要显示的天 6周 * 一周7天 = 42天
    NSMutableArray<NSDate*> *_allShowDates;
    UICollectionView *_uICollectionView;
}

@end

@implementation SubDazzleCalendarView

//初始化日历，周视图还是月视图
- (instancetype)initWithFrame:(CGRect)frame calendarType:(DazzleCalendarType)calendarType {
    self = [super initWithFrame:frame];
    if (self) {
        _calendarType = calendarType;
        self.backgroundColor = [UIColor whiteColor];
        _nSCalender = [NSCalendar currentCalendar];
        _allShowDates = [@[] mutableCopy];
        
        UICollectionViewFlowLayout *uICollectionViewFlowLayout = [UICollectionViewFlowLayout new];
        //月视图
        if(_calendarType == DazzleCalendarMonth)
            uICollectionViewFlowLayout.itemSize = CGSizeMake(frame.size.width / 7 , frame.size.height / 6);
        //周视图
         if(_calendarType == DazzleCalendarWeek)
             uICollectionViewFlowLayout.itemSize = CGSizeMake(frame.size.width / 7 , frame.size.height);
        uICollectionViewFlowLayout.minimumLineSpacing = 0;
        uICollectionViewFlowLayout.minimumInteritemSpacing = 0;
        uICollectionViewFlowLayout.sectionInset = UIEdgeInsetsZero;
        _uICollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:uICollectionViewFlowLayout];
        _uICollectionView.backgroundColor = [UIColor whiteColor];
        _uICollectionView.scrollEnabled = NO;
        _uICollectionView.bounces = NO;
        _uICollectionView.showsHorizontalScrollIndicator = NO;
        _uICollectionView.showsVerticalScrollIndicator = NO;
        _uICollectionView.delegate = self;
        _uICollectionView.dataSource = self;
        [_uICollectionView registerClass:[DazzleCalendarDayView class] forCellWithReuseIdentifier:@"DazzleCalendarDayView"];
        [self addSubview:_uICollectionView];
    }
    return self;
}
- (void)showDate:(NSDate*)date {
    _monthWeekDate = date;
    [self addAllShowDate];
    [_uICollectionView reloadData];
}
- (void)addAllShowDate {
    //如果是月视图
    if(_calendarType == DazzleCalendarMonth) {
        //获取这个月的第一天
        NSDateComponents *leftCmp = [_nSCalender components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:_monthWeekDate];
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
        [_allShowDates removeAllObjects];
        [_allShowDates addObjectsFromArray:tempArray];
    }
    //如果是周视图
    if(_calendarType == DazzleCalendarWeek) {
        //获取这个周的第一天，是星期六
        NSDate *firstDayOfWeek;
        if(_monthWeekDate.weekday == 7)
            firstDayOfWeek = _monthWeekDate;
        else
            firstDayOfWeek = [NSDate dateWithTimeIntervalSince1970:_monthWeekDate.timeIntervalSince1970 - 24 * 60 * 60 * _monthWeekDate.weekday];
        //累计填充7天
        NSMutableArray<NSDate*> *tempArray = [@[] mutableCopy];
        [tempArray addObject:firstDayOfWeek];
        for (int index = 0; index < 6; index ++) {
            firstDayOfWeek = [firstDayOfWeek dateByAddingTimeInterval:24 * 60 * 60];
            [tempArray addObject:firstDayOfWeek];
        }
        [_allShowDates removeAllObjects];
        [_allShowDates addObjectsFromArray:tempArray];
    }
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allShowDates.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DazzleCalendarDayView *dayView = [collectionView dequeueReusableCellWithReuseIdentifier:@"DazzleCalendarDayView" forIndexPath:indexPath];
    NSDate *currDate = _allShowDates[indexPath.row];
    dayView.monthWeekDate = _monthWeekDate;
    dayView.dayDate = currDate;
    dayView.calendarType = _calendarType;
    if(self.delegate && [self.delegate respondsToSelector:@selector(didShowDayView:)]) {
        [self.delegate didShowDayView:dayView];
    }
    return dayView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSDate *currDate = _allShowDates[indexPath.row];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectDate:)]) {
        [self.delegate didSelectDate:currDate];
    }
}

@end
