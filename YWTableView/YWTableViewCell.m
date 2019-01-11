//
//  YWTableViewCell.m
//  YWTableViewExamples
//
//  Created by yaowei on 2019/1/8.
//  Copyright © 2019 yaowei. All rights reserved.
//

#import "YWTableViewCell.h"

@interface YWTableViewCell ()
@property (nonatomic, readwrite,   copy) NSString *reuseIdentifier;
@property (nonatomic, readwrite, strong) UIView *contentView;
@property (nonatomic, readwrite, strong) UIView *lineView;
@property (nonatomic, readwrite, strong) UILabel *textLabel;
@property (nonatomic, readwrite, strong) UIImageView *imageView;
@property (nonatomic) YWTableViewCellStyle style;

@end


@implementation YWTableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if ((self=[super initWithFrame:frame])) {
        _style = YWTableViewCellStyleDefault;
    }
    return self;
}
- (instancetype)initWithStyle:(YWTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self=[self initWithFrame:CGRectMake(0,0,320,40)])) {
        _style = style;
        _reuseIdentifier = [reuseIdentifier copy];
        _selectionStyle = YWTableViewCellSeparatorStyleSingleLine;
    }
    return self;
}
- (void)prepareForReuse{

}
- (void)setLineView:(YWTableViewCellSeparatorStyle)selectionStyle theColor:(UIColor *)theColor{
    _selectionStyle = selectionStyle;
    self.lineView.backgroundColor = theColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    const CGRect bounds = self.bounds;
    
    CGRect contentFrame = CGRectMake(0,0,bounds.size.width,bounds.size.height);
    
    self.contentView.frame = contentFrame;
    [self bringSubviewToFront:_contentView];
    
    self.lineView.frame = CGRectMake(0,bounds.size.height-1,bounds.size.width,1);
    [self bringSubviewToFront:_lineView];
    
    if (_style == YWTableViewCellStyleDefault) {
        CGRect textRect;
        textRect.origin = CGPointMake(10,0);
        textRect.size = CGSizeMake(MAX(0,contentFrame.size.width - 10),contentFrame.size.height);
        self.textLabel.frame = textRect;
        
    }else if (_style == YWTableViewCellStyleValue1){
        const CGFloat padding = 10;
        const BOOL showImage = (_imageView.image != nil);
        const CGFloat imageWidth = (showImage? 30:0);
        self.imageView.frame = CGRectMake(padding,padding,imageWidth,contentFrame.size.height-padding);
        
        CGRect textRect;
        textRect.origin = CGPointMake(padding+imageWidth+padding,0);
        textRect.size = CGSizeMake(MAX(0,contentFrame.size.width-textRect.origin.x-padding),contentFrame.size.height);
        self.textLabel.frame = textRect;
    }else if (_style == YWTableViewCellStyleValue2){
        const CGFloat padding = 10;

        const BOOL showImage = (_imageView.image != nil);
        const CGFloat imageWidth = (showImage? 30:0);
        self.imageView.frame = CGRectMake(contentFrame.size.width - padding,padding,imageWidth,contentFrame.size.height-padding);
        
        CGRect textRect;
        textRect.origin = CGPointMake(padding,0);
        textRect.size = CGSizeMake(MAX(0,contentFrame.size.width - padding - padding - padding),contentFrame.size.height);
        self.textLabel.frame = textRect;
    }
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
        [self layoutIfNeeded];
    }
    return _contentView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:.88f green:.88f blue:.88f alpha:1];
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.highlightedTextColor = [UIColor whiteColor];
        [self.contentView addSubview:_textLabel];
    }
    return _textLabel;
}

@end
