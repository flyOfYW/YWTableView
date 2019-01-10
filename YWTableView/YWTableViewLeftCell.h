//
//  YWTableViewLeftCell.h
//  YWTableViewExamples
//
//  Created by yaowei on 2019/1/10.
//  Copyright © 2019 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTableViewLeftCell : UIView
@property (nonatomic, readonly, strong) UIView *contentView;
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuse;

@end

NS_ASSUME_NONNULL_END
