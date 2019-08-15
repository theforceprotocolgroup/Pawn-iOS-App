//
//  UtSegementItem.m
//  UThing
//
//  Created by Michael on 15/7/13.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "UtSegementItem.h"

@interface UtSegementItem ()
@property (nonatomic , assign)UtSegementItemStyle style;
@property (nonatomic , strong)UILabel * titleLabel;
@property (nonatomic , strong)UIImageView * iconImageView;
@property (nonatomic, strong) UIView *divider;
@end

@implementation UtSegementItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame withStyle:(UtSegementItemStyle)style;
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        [self addSubview:self.titleLabel];
        [self addSubview:self.iconImageView];
        [self addSubview:self.divider];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _divider.frame = CGRectMake(self.bounds.size.width, 0, 1, self.bounds.size.height + 2);
    _iconImageView.frame = CGRectMake(self.width/3,( self.height - self.iconSize.height)/2, self.iconSize.width, self.iconSize.height);
    NSMutableAttributedString *attributeString = KKMultiAttriString(self.titleStr);
    attributeString.lineSpacing = 2;
    _titleLabel.attributedText = attributeString;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (_isSelect) {
        if (_style ==UtSegementItemStyleDefult) {
            _titleLabel.textColor = _selectedColer;
            
        }else
        {
            _iconImageView.image = _selectedImage;
            _titleLabel.textColor = _selectedColer;
        }
    }else
    {
        if (_style == UtSegementItemStyleDefult) {
            _titleLabel.textColor = _unSelectedColer;
        }else
        {
            _iconImageView.image = _unSelectedIamge;
            _titleLabel.textColor = _unSelectedColer;
        }
    }
    if (_style == UtSegementItemStyleDefult) {
        _titleLabel.frame = self.bounds;

    }else
    {
        _titleLabel.frame = CGRectMake(self.iconImageView.frame.origin.x+self.iconImageView.frame.size.width+5, 0, self.width - self.iconImageView.frame.origin.x+self.iconImageView.frame.size.width-5,self.height);

    }
    CGRect rectTemp = _titleLabel.frame;
    rectTemp = CGRectMake(rectTemp.origin.x, rectTemp.origin.y + 3, rectTemp.size.width, rectTemp.size.height);
    _titleLabel.frame = rectTemp;
   

}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        if (_style ==UtSegementItemStyleDefult) {
            _titleLabel = [[UILabel alloc]init];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.numberOfLines = 0;
            _titleLabel.font = [UIFont systemFontOfSize:15];
        }else
        {
            _titleLabel = [[UILabel alloc]init];
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _titleLabel.font = [UIFont systemFontOfSize:15];

        }
    }
    return _titleLabel;
}
- (UIView *)divider {
    if (!_divider) {
        _divider = [[UIView alloc] init];
        _divider.backgroundColor = UIColorHex(ffffff);
    }
    return _divider;
}
-(CGSize)iconSize
{
    if (CGSizeEqualToSize(_iconSize, CGSizeMake(0, 0))||_iconSize.height > self.height||_iconSize.width > self.width) {
        NSAssert(@"warming!!!! Icon Image Bounds Wrong !!!", nil);
    }
    return _iconSize;
}
-(UIImageView *)iconImageView
{
    if (_style == UtSegementItemStyleDefult) {
        return nil;
    }
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
-(void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    [self setNeedsLayout];
}

@end
