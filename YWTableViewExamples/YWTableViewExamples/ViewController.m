//
//  ViewController.m
//  YWTableViewExamples
//
//  Created by yaowei on 2019/1/10.
//  Copyright © 2019 yaowei. All rights reserved.
//

#import "ViewController.h"
#import "YWTableView.h"
#import "YWExample01.h"
#import "YWExample02.h"
#import "YWExample03.h"

@interface ViewController ()
<YWTableViewDelegate,YWTableViewDataSource>
{
    NSArray *_list;
}
@property (nonatomic, strong) YWTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    _list = @[@"左边大类，右边明细分类",@"右边大类，左边明细分类",@"两边View将cell包裹"];
    
    _tableView = [[YWTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64) style:YWTableViewStyleDefalut];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
- (NSInteger)yw_tableView:(YWTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}
- (YWTableViewCell *)yw_tableView:(YWTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YWTableViewCell alloc] initWithStyle:YWTableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row < _list.count) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_list[indexPath.row]];
    }
    return cell;
}
- (void)yw_tableView:(YWTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _list.count) {
        switch (indexPath.row) {
            case 0:{
                YWExample01 *vc = [YWExample01 new];
                [self.navigationController pushViewController:vc animated:YES];
                }
                break;
            case 1:{
                YWExample02 *vc = [YWExample02 new];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{
                YWExample03 *vc = [YWExample03 new];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}
@end
