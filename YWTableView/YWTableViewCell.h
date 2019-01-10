//
//  YWTableViewCell.h
//  YWTableViewExamples
//
//  Created by yaowei on 2019/1/8.
//  Copyright © 2019 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YWTableViewCellStyle) {
    YWTableViewCellStyleDefault,//only textLabel
    YWTableViewCellStyleValue1,//have a imageView on left and textLabel on right
    YWTableViewCellStyleValue2, //have textLabel on left and imageView on right
    YWTableViewCellStyleCustom// custome one cell
};

typedef NS_ENUM(NSInteger, YWTableViewCellSeparatorStyle) {
    YWTableViewCellSeparatorStyleNone,
    YWTableViewCellSeparatorStyleSingleLine
};

@interface YWTableViewCell : UIView
@property (nonatomic, readonly,   copy) NSString *reuseIdentifier;
@property (nonatomic, readonly, strong) UIView *contentView;
@property (nonatomic, readonly, strong) UIView *lineView;
@property (nonatomic, readonly, strong) UILabel *textLabel;
@property (nonatomic, readonly, strong) UIImageView *imageView;

@property (nonatomic) YWTableViewCellSeparatorStyle selectionStyle;


- (instancetype)initWithStyle:(YWTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuse;
- (void)setLineView:(YWTableViewCellSeparatorStyle)selectionStyle theColor:(UIColor *)theColor;
@end

NS_ASSUME_NONNULL_END
