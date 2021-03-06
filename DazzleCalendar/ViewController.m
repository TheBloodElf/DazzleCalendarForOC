//
//  ViewController.m
//  DazzleCalendar
//
//  Created by Mac on 2017/12/19.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "DazzleCalendar.h"

#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<DazzleCalendarDelegate,UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;//表格视图
    DazzleCalendar *_dazzleCalendar;//日历控件
    NSCalendar * _nScalendar;
    NSDate *_userSelectedDate;//用户选择的时间
    
    CGFloat _monthScrollViewLastY;//日历中月视图开始改变的y点
    CGFloat _tableViewLastY;//表格视图开始改变的y点
    CGFloat _lastPointY;//移动了多少距离用来改变frame
    int _selectDateIndex;//当前选中的时间在第几行，用来计算日历中周视图的显示、隐藏
    UIPanGestureRecognizer *_uIPanGestureRecognizer;//控制frame手势
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@年%@月",@(_userSelectedDate.year),@(_userSelectedDate.month)]];
    //现在的时间
    _userSelectedDate = [NSDate new];
    _nScalendar = [NSCalendar currentCalendar];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    comps = [calendar components:NSCalendarUnitWeekOfMonth fromDate:_userSelectedDate];
    _selectDateIndex = (int)[comps weekOfMonth];
    //表格视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - 84 - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //创建日历
    _dazzleCalendar = [[DazzleCalendar alloc] initWithFrame:CGRectMake(0, 42, MAIN_SCREEN_WIDTH, 42)];
    _dazzleCalendar.calendarType = DazzleCalendarWeek;
    [_dazzleCalendar configMonthCalendar];
    [_dazzleCalendar configWeekCalendar];
    _dazzleCalendar.monthCollectionView.frame = CGRectMake(0, -252 + 42, MAIN_SCREEN_WIDTH, 252);
    _dazzleCalendar.monthCollectionView.hidden = YES;
    _dazzleCalendar.delegate = self;
    [self.view addSubview:_dazzleCalendar];
    //创建周几视图
    NSArray *weekString = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    float itemWidth = MAIN_SCREEN_WIDTH / 7;
    for (int index = 0; index < weekString.count; index ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(index * itemWidth, 0, itemWidth, 42)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.text = weekString[index];
        [self.view addSubview:label];
    }
    _uIPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    _tableView.scrollEnabled = YES;
    [self.view addGestureRecognizer:_uIPanGestureRecognizer];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)panGesture:(UIPanGestureRecognizer*)uipgr {
    //手势开始，记录位置；让月视图、表格视图做动画
    if(uipgr.state == UIGestureRecognizerStateBegan) {
        _monthScrollViewLastY = _dazzleCalendar.monthCollectionView.frame.origin.y;
        _tableViewLastY = _tableView.frame.origin.y;
        _dazzleCalendar.monthCollectionView.hidden = NO;
    }
    //手势结束，改变位置，如果已经移动到了一半以上，延迟一会儿，让滚动视图动画做完
    if(uipgr.state == UIGestureRecognizerStateEnded) {
        //变成月视图
        if(_lastPointY > 0) {
            //如果周视图已经显示出来，就拿周视图做一个动画效果
            _dazzleCalendar.weekCollectionView.alpha = 1;
            [UIView animateWithDuration:0.15 animations:^{
                _dazzleCalendar.weekCollectionView.alpha = 0;
                _dazzleCalendar.monthCollectionView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 252);
                _tableView.frame = CGRectMake(0, 294, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - 252 - 64);
            } completion:^(BOOL finished) {
                _dazzleCalendar.weekCollectionView.hidden = YES;
                _dazzleCalendar.weekCollectionView.alpha = 1;
                _dazzleCalendar.calendarType = DazzleCalendarMonth;
                _dazzleCalendar.frame = CGRectMake(0, 42, MAIN_SCREEN_WIDTH, 252);
            }];
            _tableView.scrollEnabled = NO;
            [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        } else {//变成周视图
            if(_dazzleCalendar.weekCollectionView.hidden == YES) {
                _dazzleCalendar.weekCollectionView.alpha = 0;
                _dazzleCalendar.weekCollectionView.hidden = NO;
            }
            [UIView animateWithDuration:0.15 animations:^{
                _dazzleCalendar.weekCollectionView.alpha = 1;
                _dazzleCalendar.monthCollectionView.alpha = 0;
                _dazzleCalendar.monthCollectionView.frame = CGRectMake(0, -252 + 42, MAIN_SCREEN_WIDTH, 252);
                _tableView.frame = CGRectMake(0, 84, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - 84 - 64);
            } completion:^(BOOL finished) {
                _dazzleCalendar.monthCollectionView.hidden = YES;
                _dazzleCalendar.monthCollectionView.alpha = 1;
                _dazzleCalendar.calendarType = DazzleCalendarWeek;
                _dazzleCalendar.frame = CGRectMake(0, 42, MAIN_SCREEN_WIDTH, 42);
            }];
            _tableView.scrollEnabled = YES;
            [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
    //手势进行中，
    if(uipgr.state == UIGestureRecognizerStateChanged) {
        _lastPointY = [uipgr translationInView:self.view].y;
        //这里要特别注意了，往下滑动的话 y是从42开始的
        if(_lastPointY > 0) {
            //改变日程月视图的frame
            _dazzleCalendar.monthCollectionView.frame = CGRectMake(0, _monthScrollViewLastY + _lastPointY, _dazzleCalendar.monthCollectionView.frame.size.width, _dazzleCalendar.monthCollectionView.frame.size.height);
            //怎么处理边界问题?滑动到最下面了
            if(_dazzleCalendar.monthCollectionView.frame.origin.y > 0)
                _dazzleCalendar.monthCollectionView.frame = CGRectMake(0, 0, _dazzleCalendar.monthCollectionView.frame.size.width, _dazzleCalendar.monthCollectionView.frame.size.height);
            
            //这里需要让表格视图frame改变
            _tableView.frame = CGRectMake(0, _tableViewLastY + _lastPointY, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - (_tableViewLastY + _lastPointY) - 64);
            //处理边界问题？滑动到最下面了
            if(_tableView.frame.origin.y > 294)
                _tableView.frame = CGRectMake(0, 294, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - 294 - 64);
        } else {
            //改变日程月视图的frame
            _dazzleCalendar.monthCollectionView.frame = CGRectMake(0, _monthScrollViewLastY + _lastPointY, _dazzleCalendar.monthCollectionView.frame.size.width, _dazzleCalendar.monthCollectionView.frame.size.height);
            //怎么处理边界问题? 滑动到最上面了
            if(_dazzleCalendar.monthCollectionView.frame.origin.y < -252 + 42)
                _dazzleCalendar.monthCollectionView.frame = CGRectMake(0, -252 + 42, _dazzleCalendar.monthCollectionView.frame.size.width, _dazzleCalendar.monthCollectionView.frame.size.height);
            
            //这里需要让表格视图frame改变
            _tableView.frame = CGRectMake(0, _tableViewLastY + _lastPointY, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - (_tableViewLastY + _lastPointY) - 64);
            //处理边界问题？滑动到最上面了
            if(_tableView.frame.origin.y < 84)
                _tableView.frame = CGRectMake(0, 84, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - 84 - 64);
        }
        //在合适的时机让周视图显示出来
        [self checkWeekView];
    }
}
//在合适的时机让周视图显示出来
- (void)checkWeekView {
    if(_dazzleCalendar.calendarType == DazzleCalendarMonth) {
        if(_dazzleCalendar.monthCollectionView.frame.origin.y <= (1 - _selectDateIndex) * 42) {
            _dazzleCalendar.weekCollectionView.hidden = NO;
        } else {
            _dazzleCalendar.weekCollectionView.hidden = YES;
        }
    } else {
        if(_dazzleCalendar.monthCollectionView.frame.origin.y >= (6 - _selectDateIndex) * 42) {
            _dazzleCalendar.weekCollectionView.hidden = YES;
        } else {
            _dazzleCalendar.weekCollectionView.hidden = NO;
        }
    }
}
#pragma mark -- DazzleCalendarDelegate
//日历某一天视图展示，颜色文字，是否显示全部由外面控制
- (void)didShowDayView:(DazzleCalendarDayView*)dayView {
    dayView.dateHolidayLabel.hidden = NO;
    dayView.solidBgView.hidden = YES;
    dayView.dateHolidayLabel.textColor = [UIColor blackColor];
    dayView.solidBgView.layer.borderWidth = 0;
    dayView.solidBgView.backgroundColor = [UIColor clearColor];
    //设置文字
    //显示今天几号
    dayView.dateHolidayLabel.text = @(dayView.dayDate.day).stringValue;
    //今天是否是节气
    NSString *specialString = [dayView.dayDate specialString];
    if(![NSString isBlank:specialString])
        dayView.dateHolidayLabel.text = specialString;
    //是不是农历节日
    NSString *lunarHolidayString = [dayView.dayDate lunarHolidayString];
    if(![NSString isBlank:lunarHolidayString])
        dayView.dateHolidayLabel.text = lunarHolidayString;
    //是不是公历节日
    NSString *solarHolidayString = [dayView.dayDate solarHolidayString];
    if(![NSString isBlank:solarHolidayString])
        dayView.dateHolidayLabel.text = solarHolidayString;
    //今天是否是今天
    if(dayView.dayDate.day == [NSDate new].day)
        if(dayView.dayDate.month == [NSDate new].month)
            if(dayView.dayDate.year == [NSDate new].year)
                dayView.dateHolidayLabel.text = @"今天";
    
    //设置颜色
    //月视图需要让不是本月的时间显示灰色
    if(dayView.calendarType == DazzleCalendarMonth) {
        if(dayView.dayDate.month != dayView.monthWeekDate.month)
            dayView.dateHolidayLabel.textColor = [UIColor grayColor];
    }
    //是不是今天
    if(dayView.dayDate.day == [NSDate new].day)
        if(dayView.dayDate.month == [NSDate new].month)
            if(dayView.dayDate.year == [NSDate new].year) {
                dayView.solidBgView.hidden = NO;
                dayView.solidBgView.layer.borderColor = [UIColor redColor].CGColor;
                dayView.solidBgView.layer.borderWidth = 1;
            }
    //是不是用户选中的天
    if(dayView.dayDate.day == _userSelectedDate.day)
        if(dayView.dayDate.month == _userSelectedDate.month)
            if(dayView.dayDate.year == _userSelectedDate.year) {
                dayView.dateHolidayLabel.textColor = [UIColor whiteColor];
                dayView.solidBgView.hidden = NO;
                dayView.solidBgView.backgroundColor = [UIColor redColor];
            }
}
//用户选中了某一天
- (void)didSelectDayView:(DazzleCalendarDayView*)dayView {
    _userSelectedDate = dayView.dayDate.copy;
    if(dayView.monthWeekDate.month != dayView.dayDate.month) {
        [_dazzleCalendar setWeekSendDate:_userSelectedDate];
        [_dazzleCalendar setMonthSendDate:_userSelectedDate];
        self.title = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@年%@月",@(dayView.dayDate.year),@(dayView.dayDate.month)]];
    }else {//点击的当月，加载当天
        if(_dazzleCalendar.calendarType == DazzleCalendarMonth) {
            [_dazzleCalendar.monthCollectionView reloadData];
            [_dazzleCalendar setWeekSendDate:_userSelectedDate];
        }
        if(_dazzleCalendar.calendarType == DazzleCalendarWeek) {
            [_dazzleCalendar.weekCollectionView reloadData];
            [_dazzleCalendar setMonthSendDate:_userSelectedDate];
        }
    }
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    comps = [calendar components:NSCalendarUnitWeekOfMonth fromDate:_userSelectedDate];
    _selectDateIndex = (int)[comps weekOfMonth];
}
//日程显示到了当前种子时间
- (void)didShowSendDate:(NSDate*)sendDate {
    //改变用户选择时间
    if(_dazzleCalendar.calendarType == DazzleCalendarMonth) {
        //这一个月的最大天数 当从31天的月滑动到30天的月时会崩溃
        NSRange range = [_nScalendar rangeOfUnit:NSCalendarUnitDay
                                          inUnit: NSCalendarUnitMonth
                                         forDate:sendDate];
        int daysOfMonth = (int)_userSelectedDate.day;
        if(daysOfMonth > range.length)
            daysOfMonth = (int)range.length;
        _userSelectedDate = [NSDate dateWithFormat:[NSString stringWithFormat:@"%ld-%02ld-%02d 08:30:00",sendDate.year,sendDate.month,daysOfMonth]];
    }
    if(_dazzleCalendar.calendarType == DazzleCalendarWeek) {
        //当前天是一周的第几天 周日为第一天
        int currDayOfWeeK = (int)_userSelectedDate.weekday + 1;
        if(currDayOfWeeK == 8) currDayOfWeeK = 1;
        int sendDayOfWeeK = (int)sendDate.weekday + 1;
        if(sendDayOfWeeK == 8) sendDayOfWeeK = 1;
        _userSelectedDate = sendDate.copy;
        _userSelectedDate = [_userSelectedDate dateByAddingTimeInterval:24 * 60 * 60 * (currDayOfWeeK - sendDayOfWeeK)];
    }
    if(_dazzleCalendar.calendarType == DazzleCalendarMonth) {
        [_dazzleCalendar.monthCollectionView reloadData];
        [_dazzleCalendar setWeekSendDate:_userSelectedDate];
    }
    if(_dazzleCalendar.calendarType == DazzleCalendarWeek) {
        [_dazzleCalendar.weekCollectionView reloadData];
        [_dazzleCalendar setMonthSendDate:_userSelectedDate];
    }
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    comps = [calendar components:NSCalendarUnitWeekOfMonth fromDate:_userSelectedDate];
    _selectDateIndex = (int)[comps weekOfMonth];
    self.title = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@年%@月",@(sendDate.year),@(sendDate.month)]];
}
#pragma mark --
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if(!tableViewCell)
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    tableViewCell.textLabel.text = @(indexPath.row).stringValue;
    return tableViewCell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //如果是周视图 用户往下拉，就变成月
    if(_dazzleCalendar.calendarType == DazzleCalendarWeek) {
        if(scrollView.contentOffset.y < 0) {
            _dazzleCalendar.weekCollectionView.alpha = 1;
            _dazzleCalendar.monthCollectionView.hidden = NO;
            [UIView animateWithDuration:0.15 animations:^{
                _dazzleCalendar.weekCollectionView.alpha = 0;
                _dazzleCalendar.monthCollectionView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 252);
                _tableView.frame = CGRectMake(0, 294, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - 252 - 64);
            } completion:^(BOOL finished) {
                _dazzleCalendar.weekCollectionView.hidden = YES;
                _dazzleCalendar.weekCollectionView.alpha = 1;
                _dazzleCalendar.calendarType = DazzleCalendarMonth;
                _dazzleCalendar.frame = CGRectMake(0, 42, MAIN_SCREEN_WIDTH, 252);
            }];
            //然后给self.view添加手势
            _tableView.scrollEnabled = NO;
            [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
}

@end
