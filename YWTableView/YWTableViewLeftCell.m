//
//  YWTableViewLeftCell.m
//  YWTableViewExamples
//
//  Created by yaowei on 2019/1/10.
//  Copyright © 2019 yaowei. All rights reserved.
//

#import "YWTableViewLeftCell.h"

@interface YWTableViewLeftCell ()
@property (nonatomic, readwrite,   copy) NSString *reuseIdentifier;
@property (nonatomic, readwrite, strong) UIView *contentView;

@end


@implementation YWTableViewLeftCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ((self = [super initWithFrame:frame])) {
    }
    return self;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [self initWithFrame:CGRectMake(0,0,40,40)])) {
        _reuseIdentifier = [reuseIdentifier copy];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    const CGRect bounds = self.bounds;
    CGRect contentFrame = CGRectMake(0,0,bounds.size.width,bounds.size.height);
    self.contentView.frame = contentFrame;
    [self bringSubviewToFront:_contentView];
}
- (void)prepareForReuse{
    
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
    }
    return _contentView;
}
@end
