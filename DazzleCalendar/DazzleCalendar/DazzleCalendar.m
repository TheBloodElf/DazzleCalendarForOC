//
//  DazzleCalendar.m
//  RealmDemo
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 com.luohaifang. All rights reserved.
//

#import "DazzleCalendar.h"

@interface DazzleCalendar ()<UIScrollViewDelegate,SubDazzleCalendarDelegate> {
    NSCalendar *_nSCalender;//弄成单例，内存占用太多
    
    //上一个月
    SubDazzleCalendarView *_leftMonthCalendarView;
    //当前月
    SubDazzleCalendarView *_centerMonthCalendarView;
    //下一个月
    SubDazzleCalendarView *_rightMonthCalendarView;
    

    //上一个周
    SubDazzleCalendarView *_leftWeekCalendarView;
    //当前周
    SubDazzleCalendarView *_centerWeekCalendarView;
    //下一个周
    SubDazzleCalendarView *_rightWeekCalendarView;
    
    UIScrollView *_currScrollView;
    
}
//用户当前选择的时间，也就是中间日历显示的时间
//比较专业的说法是：当前月、周种子时间
@property (nonatomic, strong) NSDate *monthWeekDate;

@end

@implementation DazzleCalendar
//初始化日历，周视图还是月视图
- (instancetype)initWithFrame:(CGRect)frame calendarType:(DazzleCalendarType)calendarType {
    self = [super initWithFrame:frame];
    if (self) {
        _calendarType = calendarType;
        self.backgroundColor = [UIColor clearColor];
        _nSCalender = [NSCalendar currentCalendar];

        //上面的周几视图 高度为42.5
        CGFloat itemWidth = frame.size.width / 7;
        CGFloat itemHeight = 42.5;
        //创建月
        _monthScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, itemHeight, frame.size.width, 255)];
        _monthScrollView.contentSize = CGSizeMake(3 * _monthScrollView.frame.size.width, _monthScrollView.frame.size.height);
        _monthScrollView.pagingEnabled = YES;
        _monthScrollView.delegate = self;
        _monthScrollView.showsHorizontalScrollIndicator = NO;
        _monthScrollView.showsVerticalScrollIndicator = NO;
        //上一个月
        _leftMonthCalendarView = [[SubDazzleCalendarView alloc] initWithFrame:CGRectMake(0, 0, _monthScrollView.frame.size.width, _monthScrollView.frame.size.height) calendarType:DazzleCalendarMonth];
        _leftMonthCalendarView.delegate = self;
        [_monthScrollView addSubview:_leftMonthCalendarView];
        //当前月
        _centerMonthCalendarView = [[SubDazzleCalendarView alloc] initWithFrame:CGRectMake(_monthScrollView.frame.size.width, 0, _monthScrollView.frame.size.width, _monthScrollView.frame.size.height) calendarType:DazzleCalendarMonth];
        _centerMonthCalendarView.delegate = self;
        [_monthScrollView addSubview:_centerMonthCalendarView];
        //下一个月
        _rightMonthCalendarView = [[SubDazzleCalendarView alloc] initWithFrame:CGRectMake(2 * _monthScrollView.frame.size.width, 0, _monthScrollView.frame.size.width, _monthScrollView.frame.size.height) calendarType:DazzleCalendarMonth];
        _rightMonthCalendarView.delegate = self;
        [_monthScrollView addSubview:_rightMonthCalendarView];
        [self addSubview:_monthScrollView];
        //创建周
        _weekScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, itemHeight, frame.size.width, 42.5)];
        _weekScrollView.contentSize = CGSizeMake(3 * _weekScrollView.frame.size.width, _weekScrollView.frame.size.height);
        _weekScrollView.pagingEnabled = YES;
        _weekScrollView.delegate = self;
        _weekScrollView.showsHorizontalScrollIndicator = NO;
        _weekScrollView.showsVerticalScrollIndicator = NO;
        //上一个周
        _leftWeekCalendarView = [[SubDazzleCalendarView alloc] initWithFrame:CGRectMake(0, 0, _weekScrollView.frame.size.width, _weekScrollView.frame.size.height) calendarType:DazzleCalendarWeek];
        _leftWeekCalendarView.delegate = self;
        [_weekScrollView addSubview:_leftWeekCalendarView];
        //当前周
        _centerWeekCalendarView = [[SubDazzleCalendarView alloc] initWithFrame:CGRectMake(_weekScrollView.frame.size.width, 0, _weekScrollView.frame.size.width, _weekScrollView.frame.size.height) calendarType:DazzleCalendarWeek];
        _centerWeekCalendarView.delegate = self;
        [_weekScrollView addSubview:_centerWeekCalendarView];
        //下一个周
        _rightWeekCalendarView = [[SubDazzleCalendarView alloc] initWithFrame:CGRectMake(2 * _weekScrollView.frame.size.width, 0, _weekScrollView.frame.size.width, _weekScrollView.frame.size.height) calendarType:DazzleCalendarWeek];
        _rightWeekCalendarView.delegate = self;
        [_weekScrollView addSubview:_rightWeekCalendarView];
        [self addSubview:_weekScrollView];
        //月视图隐藏周
        if(_calendarType == DazzleCalendarMonth) {
            _weekScrollView.hidden = YES;
            _monthScrollView.hidden = NO;
            _monthScrollView.frame = CGRectMake(0, itemHeight, frame.size.width, 255);
        } else {//周视图隐藏月
            _weekScrollView.hidden = NO;
            _monthScrollView.hidden = YES;
            _monthScrollView.frame = CGRectMake(0, itemHeight - 255, frame.size.width, 255);
        }
        //创建周几视图
        NSArray *weekString = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int index = 0; index < weekString.count; index ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(index * itemWidth, 0, itemWidth, itemHeight)];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor colorFromHexCode:@"#777587"];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.text = weekString[index];
            [self addSubview:label];
        }
    }
    return self;
}
//显示当前月的时间
- (void)showDate:(NSDate*)date {
    _monthWeekDate = date;
    [self setNeedUpdateUI:date];
}
//根据给定的时间重新设置界面
- (void)setNeedUpdateUI:(NSDate*)showDate {
    //月视图
    {
        [_centerMonthCalendarView showDate:showDate];
        [_monthScrollView setContentOffset:CGPointMake(_monthScrollView.frame.size.width, 0) animated:NO];
//        _monthScrollView.contentOffset = CGPointMake(_monthScrollView.frame.size.width, 0);
        //获取上一个月的今天
        NSDateComponents *leftCmp = [_nSCalender components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:showDate];
        [leftCmp setMonth:[leftCmp month] - 1];
        NSDate *leftDate = [_nSCalender dateFromComponents:leftCmp];
        [_leftMonthCalendarView showDate:leftDate];
        
        //获取下一个月的今天
        NSDateComponents *rightCmp = [_nSCalender components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:showDate];
        [rightCmp setMonth:[rightCmp month] + 1];
        NSDate *rightDate = [_nSCalender dateFromComponents:rightCmp];
        [_rightMonthCalendarView showDate:rightDate];
    }
    //周视图
    {
        [_centerWeekCalendarView showDate:showDate];
        [_weekScrollView setContentOffset:CGPointMake(_weekScrollView.frame.size.width, 0) animated:NO];
//        _weekScrollView.contentOffset = CGPointMake(_weekScrollView.frame.size.width, 0);
        //获取上一个周的今天
        NSDate *leftDate = [_monthWeekDate dateByAddingTimeInterval: - 7 * 24 * 60 * 60];
        [_leftWeekCalendarView showDate:leftDate];
        
        //获取下一个周的今天
        NSDate *rightDate = [_monthWeekDate dateByAddingTimeInterval:7 * 24 * 60 * 60];
        [_rightWeekCalendarView showDate:rightDate];
    }
    //通知代理，已经加载了当前周、月视图
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadDate:)]) {
        [self.delegate didLoadDate:showDate];
    }
}
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _currScrollView = scrollView;
    //滚到上一个月、周 显示一半
    if(_currScrollView.contentOffset.x <= 0) {
        //跨、周月了，我们需要得到上一个月、周的今天
        NSDate *showDate;
        //跨月了
        if(_calendarType == DazzleCalendarMonth)
            showDate = _leftMonthCalendarView.monthWeekDate;
        else //跨周了
            showDate = _leftWeekCalendarView.monthWeekDate;
        if(self.delegate && [self.delegate respondsToSelector:@selector(didScrollDate:)]) {
            [self.delegate didScrollDate:showDate];
        }
    }
    //滚动下一个月、周 显示一半
    if(_currScrollView.contentOffset.x >= 2 * _currScrollView.frame.size.width) {
        //跨月、周了，我们需要得到下一个月、周的今天
        NSDate *showDate;
        //跨月了
        if(_calendarType == DazzleCalendarMonth)
            showDate = _rightMonthCalendarView.monthWeekDate;
        else //跨周了
            showDate = _rightWeekCalendarView.monthWeekDate;
        if(self.delegate && [self.delegate respondsToSelector:@selector(didScrollDate:)]) {
            [self.delegate didScrollDate:showDate];
        }
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation) object:nil];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation) withObject:nil afterDelay:0.1];
}
//滚动停止 包括有动画、没有动画  判断滚动偏移
- (void)scrollViewDidEndScrollingAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation:) object:nil];
}
#pragma mark -- SubDazzleCalendarDelegate
- (void)didSelectDate:(NSDate*)selectDate {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectDate:)]) {
        [self.delegate didSelectDate:selectDate];
    }
}
- (void)didShowDayView:(DazzleCalendarDayView *)dazzleCalendarDayView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didShowDayView:)]) {
        [self.delegate didShowDayView:dazzleCalendarDayView];
    }
}
@end
