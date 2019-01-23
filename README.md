# YWTableView
继承于UIScrollView自定义个特殊的tableView

### 集成方法
   1. 将YWAlertView文件拖入项目，引入头文件 
   > #import "YWTableView.h"
   2. 使用cocopod
   ```ruby
      pod 'YWTableView'
   ```
   * 注意点：YWTableView只是提供个参考思路，根据需求可参考代码自行可实现个tableView
     
 ### 效果
   ![image](https://github.com/flyOfYW/YWTableView/blob/master/image/IMG_0379.PNG width=100px,height=100px)
### 用法
   > ##### * 跟UITableView用法一样，方法也类似,
     
```  
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
```





 
