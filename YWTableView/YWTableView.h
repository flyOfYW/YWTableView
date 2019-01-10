//
//  YWTableView.h
//  YWTableViewExamples
//
//  Created by yaowei on 2019/1/10.
//  Copyright © 2019 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTableViewCell.h"
#import "YWTableViewLeftCell.h"
#import "YWTableViewRightCell.h"

NS_ASSUME_NONNULL_BEGIN

@class YWTableView;


@protocol YWTableViewDelegate <UIScrollViewDelegate>
@optional
- (void)yw_tableView:(YWTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)yw_tableView:(YWTableView *)tableView didSelectLeftViewAtIndexPath:(NSIndexPath *)indexPath;
- (void)yw_tableView:(YWTableView *)tableView didSelectRightViewAtIndexPath:(NSIndexPath *)indexPath;



- (CGFloat)yw_tableView:(YWTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)yw_tableView:(YWTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)yw_tableView:(YWTableView *)tableView heightForFooterInSection:(NSInteger)section;

- (CGFloat)yw_tableView:(YWTableView *)tableView widthForLeftInSection:(NSInteger)section;
- (CGFloat)yw_tableView:(YWTableView *)tableView widthForRightInSection:(NSInteger)section;


- (UIView *)yw_tableView:(YWTableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)yw_tableView:(YWTableView *)tableView viewForFooterInSection:(NSInteger)section;


@end

@protocol YWTableViewDataSource <NSObject>
@required
- (NSInteger)yw_tableView:(YWTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (YWTableViewCell *)yw_tableView:(YWTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (YWTableViewLeftCell *)yw_tableView:(YWTableView *)tableView leftCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (YWTableViewRightCell *)yw_tableView:(YWTableView *)tableView rightCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)yw_numberOfSectionsInTableView:(YWTableView *)tableView;

@end


typedef NS_ENUM(NSInteger, YWTableViewStyle) {
    YWTableViewStyleDefalut
};

@interface YWTableView : UIScrollView

@property (nonatomic, readonly) YWTableViewStyle style;
@property (nonatomic, weak) id<YWTableViewDelegate> delegate;
@property (nonatomic, weak) id<YWTableViewDataSource> dataSource;

@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) CGFloat leftWidth;
@property (nonatomic) CGFloat rightWidth;

@property (nonatomic) YWTableViewCellSeparatorStyle separatorStyle;
@property (nonatomic, strong) UIColor *separatorColor;

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIView *backgroundView;


@property (nonatomic) CGFloat sectionHeaderHeight;
@property (nonatomic) CGFloat sectionFooterHeight;


- (instancetype)initWithFrame:(CGRect)frame style:(YWTableViewStyle)style;
- (YWTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (YWTableViewLeftCell *)dequeueReusableCellWithIdentifierOnLeft:(NSString *)identifier;
- (YWTableViewRightCell *)dequeueReusableCellWithIdentifierOnRight:(NSString *)identifier;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
