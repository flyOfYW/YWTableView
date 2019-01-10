//
//  ViewController.m
//  YWTableViewExamples
//
//  Created by yaowei on 2019/1/10.
//  Copyright © 2019 yaowei. All rights reserved.
//

#import "ViewController.h"
#import "YWTableView.h"

@interface ViewController ()
<YWTableViewDelegate,YWTableViewDataSource>
{
    NSInteger row;
    NSInteger left;
}
@property (nonatomic, strong) YWTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    _tableView = [[YWTableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64) style:YWTableViewStyleDefalut];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.leftWidth = 60;
    [self.view addSubview:_tableView];
    
}
- (NSInteger)yw_numberOfSectionsInTableView:(YWTableView *)tableView{
    return 30;
}
- (NSInteger)yw_tableView:(YWTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (YWTableViewCell *)yw_tableView:(YWTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YWTableViewCell alloc] initWithStyle:YWTableViewCellStyleDefault reuseIdentifier:@"cell"];
        NSLog(@"row:%zi",row);
        row += 1;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zi",indexPath.row];
    return cell;
}
- (YWTableViewLeftCell *)yw_tableView:(YWTableView *)tableView leftCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTableViewLeftCell *cell = [tableView dequeueReusableCellWithIdentifierOnLeft:@"left"];
    if (!cell) {
        cell = [[YWTableViewLeftCell alloc] initWithReuseIdentifier:@"left"];
        UILabel *lebl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 60)];
        lebl.font = [UIFont systemFontOfSize:12];
        lebl.tag = 100;
        lebl.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:lebl];
        NSLog(@"left:%zi",left);
        left += 1;
    }
    UILabel *lebl = [cell.contentView viewWithTag:100];
    lebl.text = @"d归类";
    return cell;
}
@end
