//
//  DazzleCalendar.m
//  RealmDemo
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 com.luohaifang. All rights reserved.
//

#import "DazzleCalendar.h"
#import "MonthCollectionCell.h"
#import "WeekCollectionCell.h"

@interface DazzleCalendar ()<UICollectionViewDelegate,UICollectionViewDataSource,MonthCollectionDelegate,WeekCollectionDelegate> {
    NSCalendar *_nSCalender;//弄成单例，内存占用太多
    
    
    int _sendDateCount;//种子时间个数
    NSMutableArray<NSDate*> *_monthSendDates;//月视图种子时间
    NSMutableArray<NSDate*> *_weekSendDates;//周视图种子时间
}

@end

@implementation DazzleCalendar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sendDateCount = 100;
        _monthSendDates = [@[] mutableCopy];
        _weekSendDates = [@[] mutableCopy];
        _nSCalender = [NSCalendar currentCalendar];
    }
    return self;
}
- (void)configMonthCalendar {
    //种子时间
    [_monthSendDates removeAllObjects];
    NSDateComponents *leftCmp = nil;
    NSDate *currDate = [NSDate new];
    NSDate *tempDate = nil;
    for (int index = 0; index < 2 * _sendDateCount + 1; index ++ ) {
        leftCmp = [_nSCalender components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:currDate];
        leftCmp.month += (index - _sendDateCount);
        leftCmp.day = 1;
        tempDate = [NSDate new];
        tempDate = [_nSCalender dateFromComponents:leftCmp];
        [_monthSendDates addObject:tempDate];
    }
    //集合视图
    UICollectionViewFlowLayout *monthLayout = [UICollectionViewFlowLayout new];
    monthLayout.itemSize = CGSizeMake(self.frame.size.width, 42 * 6);
    monthLayout.minimumLineSpacing = 0;
    monthLayout.minimumInteritemSpacing = 0;
    monthLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _monthCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 42 * 6) collectionViewLayout:monthLayout];
    _monthCollectionView.backgroundColor = [UIColor whiteColor];
    _monthCollectionView.pagingEnabled = YES;
    _monthCollectionView.delegate = self;
    _monthCollectionView.dataSource = self;
    _monthCollectionView.showsHorizontalScrollIndicator = NO;
    [_monthCollectionView registerClass:[MonthCollectionCell class] forCellWithReuseIdentifier:@"MonthCollectionCell"];
    [self addSubview:_monthCollectionView];
    [_monthCollectionView setContentOffset:CGPointMake(self.frame.size.width * _sendDateCount, 0)];
}
//设置月日历各自的种子时间，重新配置一下界面，让日历滚动当当前时间
- (void)setMonthSendDate:(NSDate*)sendDate {
    [_monthSendDates removeAllObjects];
    NSDateComponents *leftCmp = nil;
    NSDate *currDate = sendDate;
    NSDate *tempDate = nil;
    for (int index = 0; index < 2 * _sendDateCount + 1; index ++ ) {
        leftCmp = [_nSCalender components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:currDate];
        leftCmp.month += (index - _sendDateCount);
        tempDate = [NSDate new];
        tempDate = [_nSCalender dateFromComponents:leftCmp];
        [_monthSendDates addObject:tempDate];
    }
    //滚动到中间
    [_monthCollectionView setContentOffset:CGPointMake(self.frame.size.width * _sendDateCount, 0)];
    //刷新一下界面
    [_monthCollectionView reloadData];
}
- (void)configWeekCalendar {
    [_weekSendDates removeAllObjects];
    NSDate *currDate = [NSDate new];
    NSDate *tempDate = nil;
    for (int index = 0; index < 2 * _sendDateCount + 1; index ++ ) {
        tempDate = [currDate dateByAddingTimeInterval:(index - _sendDateCount) * 7 * 24 * 60 * 60];
        [_weekSendDates addObject:tempDate];
    }
    //集合视图
    UICollectionViewFlowLayout *weekLayout = [UICollectionViewFlowLayout new];
    weekLayout.itemSize = CGSizeMake(self.frame.size.width, 42);
    weekLayout.minimumLineSpacing = 0;
    weekLayout.minimumInteritemSpacing = 0;
    weekLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _weekCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 42) collectionViewLayout:weekLayout];
    _weekCollectionView.backgroundColor = [UIColor whiteColor];
    _weekCollectionView.pagingEnabled = YES;
    _weekCollectionView.delegate = self;
    _weekCollectionView.dataSource = self;
    _weekCollectionView.showsHorizontalScrollIndicator = NO;
    [_weekCollectionView registerClass:[WeekCollectionCell class] forCellWithReuseIdentifier:@"WeekCollectionCell"];
    [self addSubview:_weekCollectionView];
    [_weekCollectionView setContentOffset:CGPointMake(self.frame.size.width * _sendDateCount, 0)];
}
- (void)setWeekSendDate:(NSDate*)sendDate {
    [_weekSendDates removeAllObjects];
    NSDate *currDate = sendDate;
    NSDate *tempDate = nil;
    for (int index = 0; index < 2 * _sendDateCount + 1; index ++ ) {
        tempDate = [currDate dateByAddingTimeInterval:(index - _sendDateCount) * 7 * 24 * 60 * 60];
        [_weekSendDates addObject:tempDate];
    }
    //滚动到中间
    [_weekCollectionView setContentOffset:CGPointMake(self.frame.size.width * _sendDateCount, 0)];
    //刷新一下界面
    [_weekCollectionView reloadData];
}
#pragma mark --
#pragma mark -- UICollectionViewDataSource
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation) object:nil];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation) withObject:nil afterDelay:0.1];
}
//滚动停止 包括有动画、没有动画
- (void)scrollViewDidEndScrollingAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation:) object:nil];
    //月视图
    if(_calendarType == DazzleCalendarMonth) {
        //当前到哪一页了
        int pageIndex = _monthCollectionView.contentOffset.x / _monthCollectionView.frame.size.width;
        if(self.delegate && [self.delegate respondsToSelector:@selector(didShowSendDate:)]) {
            [self.delegate didShowSendDate:_monthSendDates[pageIndex]];
        }
        //如果滚动到边缘了，这时候就应该重新设置时间了
        if(pageIndex == 0)
            [self setMonthSendDate:_monthSendDates[0]];
        if(pageIndex == _sendDateCount * 2)
            [self setMonthSendDate:_monthSendDates[_sendDateCount * 2]];
    }
    //周视图
    if(_calendarType == DazzleCalendarWeek) {
        //当前到哪一页了
        int pageIndex = _weekCollectionView.contentOffset.x / _weekCollectionView.frame.size.width;
        if(self.delegate && [self.delegate respondsToSelector:@selector(didShowSendDate:)]) {
            [self.delegate didShowSendDate:_weekSendDates[pageIndex]];
        }
        //如果滚动到边缘了，这时候就应该重新设置时间了
        if(pageIndex == 0)
            [self setWeekSendDate:_weekSendDates[0]];
        if(pageIndex == _sendDateCount * 2)
            [self setWeekSendDate:_weekSendDates[_sendDateCount * 2]];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2 * _sendDateCount + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if(collectionView == _monthCollectionView) {
        MonthCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MonthCollectionCell" forIndexPath:indexPath];
        collectionCell.monthSendDate = _monthSendDates[indexPath.row];
        collectionCell.delegate = self;
        [collectionCell reloadCurrMonth];
        cell = collectionCell;
    }
    if(collectionView == _weekCollectionView) {
        WeekCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeekCollectionCell" forIndexPath:indexPath];
        collectionCell.weekSendDate = _weekSendDates[indexPath.row];
        collectionCell.delegate = self;
        [collectionCell reloadCurrWeek];
        cell = collectionCell;
    }
    return cell;
}
#pragma mark --
#pragma mark -- MonthCollectionDelegate,WeekCollectionDelegate
//用户选中了某一天
- (void)didSelectDayView:(DazzleCalendarDayView*)dayView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectDayView:)]) {
        [self.delegate didSelectDayView:dayView];
    }
}
//日历某一天视图展示，用户可以自己对天视图进行修改
- (void)didShowDayView:(DazzleCalendarDayView*)dayView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didShowDayView:)]) {
        [self.delegate didShowDayView:dayView];
    }
}
@end

