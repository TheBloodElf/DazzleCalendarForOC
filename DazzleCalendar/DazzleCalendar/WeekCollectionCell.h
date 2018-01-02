//
//  WeekCollectionCell.h
//  RealmDemo
//
//  Created by Mac on 2018/1/2.
//  Copyright © 2018年 com.luohaifang. All rights reserved.
//

#import "DazzleCalendarDayView.h"

//日历子项 用于显示一个月的时间
@protocol WeekCollectionDelegate <NSObject>

//用户选中了某一天
- (void)didSelectDayView:(DazzleCalendarDayView*)dayView;
//日历某一天视图展示，用户可以自己对天视图进行修改
- (void)didShowDayView:(DazzleCalendarDayView*)dayView;

@end

@interface WeekCollectionCell : UICollectionViewCell

//当前月种子时间
@property (nonatomic, strong) NSDate *weekSendDate;
@property (nonatomic, weak) id<WeekCollectionDelegate> delegate;
//刷新一下当前界面
- (void)reloadCurrWeek;

@end
