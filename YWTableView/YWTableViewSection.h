//
//  YWTableViewSection.h
//  YWTableViewExamples
//
//  Created by yaowei on 2019/1/8.
//  Copyright © 2019 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTableViewSection : NSObject

- (CGFloat)sectionHeight;
- (void)setNumberOfRows:(NSInteger)rows withHeights:(CGFloat *)newRowHeights;


@property (nonatomic, readonly) NSInteger numberOfRows;
@property (nonatomic, readonly) CGFloat *rowHeights;

@property (nonatomic, assign) CGFloat rowsHeight;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat leftWidth;
@property (nonatomic, assign) CGFloat rightWidth;



@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@end

NS_ASSUME_NONNULL_END
