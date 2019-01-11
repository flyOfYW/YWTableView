//
//  YWExample01.m
//  YWTableViewExamples
//
//  Created by yaowei on 2019/1/11.
//  Copyright © 2019 yaowei. All rights reserved.
//

#import "YWExample01.h"
#import "YWTableView.h"

@interface YWExample01 ()
<YWTableViewDelegate,YWTableViewDataSource>
@property (nonatomic, strong) YWTableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation YWExample01

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _data = @[].mutableCopy;
    [_data addObject:@{@"category":@[@"oc",@"swift"],@"categoryName":@"iOS编程语言"}];
    [_data addObject:@{@"category":@[@"Java",@"php",@"python",@".net",@"C++",@"C",@"C#"],@"categoryName":@"后台编程语言"}];
    [_data addObject:@{@"category":@[@"Java",@"Kotlin"],@"categoryName":@"Android编程语言"}];
    [_data addObject:@{@"category":@[@"销售一部",@"销售二部",@"销售三部",@"销售四部",@"销售五部",@"销售六部"],@"categoryName":@"xx公司"}];

    
    _tableView = [[YWTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:YWTableViewStyleDefalut];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.leftWidth = 100;
    [self.view addSubview:_tableView];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];

}

- (NSInteger)yw_numberOfSectionsInTableView:(YWTableView *)tableView{
    return _data.count;
}

- (NSInteger)yw_tableView:(YWTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < _data.count) {
        NSDictionary *dict = _data[section];
        return [dict[@"category"] count];
    }
    return 0;
}
- (YWTableViewCell *)yw_tableView:(YWTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YWTableViewCell alloc] initWithStyle:YWTableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    if (indexPath.section < _data.count) {
        NSDictionary *dict = _data[indexPath.section];
        NSArray *list = dict[@"category"];
        if (indexPath.row < list.count) {
            cell.textLabel.text = list[indexPath.row];
        }
    }
    return cell;
}
- (YWTableViewLeftCell *)yw_tableView:(YWTableView *)tableView leftCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTableViewLeftCell *cell = [tableView dequeueReusableCellWithIdentifierOnLeft:@"left"];
    if (!cell) {
        cell = [[YWTableViewLeftCell alloc] initWithReuseIdentifier:@"left"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), CGRectGetHeight(cell.contentView.frame))];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.tag = 102;
        label.numberOfLines = 0;
        label.contentMode = UIViewContentModeCenter;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        
    }
    if (indexPath.section < _data.count) {
        UILabel *label = [cell.contentView viewWithTag:102];
        NSDictionary *dict = _data[indexPath.section];
        label.text = dict[@"categoryName"];
    }
    return cell;
}
- (UIView *)yw_tableView:(YWTableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)yw_tableView:(YWTableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
@end
