//
//  LoanDetailIntervalView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/2.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanDetailIntervalView.h"
#import "LoanDetailInfoViewModel.h"


@interface LoanDetailIntervalView ()
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIImageView * titleIcon;
//
@property (nonatomic, strong) UIView * contentView;

//
@property (nonatomic, strong) NSMutableArray * contentArr;
//
@property (nonatomic, strong) NSMutableArray * contentItemArr;

#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation LoanDetailIntervalView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    @weakify(self);
    return ^(NSArray *tuple) {
        @strongify(self);
        [self.contentArr removeAllObjects];
        [self.contentArr addObjectsFromArray:tuple];
        [self setNeedsUpdateConstraints];
    };
}

#pragma mark - View
///=============================================================================
/// @name View
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame model:(id)model action:(KKActionHandle)action {
    if (self = [super initWithFrame:frame]) {
        self.actionHandle = action;
        self.model = model;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        self.backgroundColor = KKHexColor(ffffff);
        _contentArr = [[NSMutableArray alloc]init];
        _contentItemArr = [[NSMutableArray alloc]init];
        [self addViews];
    }
    return self;
}
-(void)layoutSubviews
{
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = self.frame;
    subLayer.frame = fixframe;
    subLayer.cornerRadius = 5.0f;
    subLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor =  [UIColor colorWithRed:81/255.0 green:112/255.0 blue:235/255.0 alpha:0.07].CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,5);//shadowOffset阴影偏移, width:向右偏移3，height:向下偏移3，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 1;//阴影透明度
    subLayer.shadowRadius = 11;//阴影半径，默认3
    [self.superview.layer insertSublayer:subLayer below:self.layer];
}
- (void)addViews {
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.titleIcon];
    [self.titleView addSubview:self.titleLabel];
    [self addSubview:self.contentView];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================

- (void)updateConstraints {
    [self updateLayout];
    [super updateConstraints];
}

- (void)updateLayout {
    @weakify(self);
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-90);
    }];
    [_titleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.titleView);
        make.left.equalTo(self.titleView).offset(15);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.self.titleIcon);
        make.left.equalTo(self.titleIcon.mas_right).offset(8);
    }];
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self).offset(-16);
    }];
    if (_contentArr.count) {
        [self setUpItem];
    }
}
-(void)setUpItem
{
    __weak typeof(self) weakSelf = self;
    [_contentItemArr enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_contentItemArr removeAllObjects];
    [_contentArr enumerateObjectsUsingBlock:^(LoanDetailInfoViewModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * itemView = [[UIView alloc]init];
        itemView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:itemView];
        UILabel * title = [[UILabel alloc]init];
        title.font = [UIFont systemFontOfSize:11];
        title.textColor = KKHexColor(5D667A);
        title.textAlignment = NSTextAlignmentCenter;
        title.text = [NSString stringWithFormat:@"%@",obj.title];
        [itemView addSubview:title];
        
        UILabel * content = [[UILabel alloc]init];
        content.font = [UIFont systemFontOfSize:12];
        content.textColor = KKHexColor(0C1E48);
        content.textAlignment = NSTextAlignmentCenter;
        content.text = [NSString stringWithFormat:@"%@",obj.content];
        [itemView addSubview:content];
        
        UIImageView * image = [[UIImageView alloc]initWithImage:KKImage(@"loan_doc")];
        [itemView addSubview:image];
        
        UIView * rightLineView = [[UIView alloc]init];
        rightLineView.backgroundColor = KKHexColor(FFC880);
        [itemView addSubview:rightLineView];
        
        __block CGFloat imageLeft = 0;
        __block CGFloat itemwidth = 0;
        imageLeft = idx == 0 ? 24 : 0;
        if (idx == 0) {
            itemwidth = 24 + 14 + [self lineWidth];
        }else if (idx == self.contentArr.count-1)
        {
            itemwidth = 24 +14;
            rightLineView.hidden = YES;
        }else
        {
            itemwidth = 14 + [self lineWidth];
        }
        
        [image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(itemView);
            make.top.equalTo(title.mas_bottom).offset(8);
            make.bottom.equalTo(content.mas_top).offset(-8);
            make.height.width.mas_equalTo(14).priorityHigh();
            make.left.equalTo(itemView).offset(imageLeft).priorityHigh();
        }];
        [title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemView.mas_top);
            make.centerX.equalTo(image);
        }];
        [content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(itemView.mas_bottom);
            make.centerX.equalTo(image);
        }];

        [rightLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(image);
            make.height.mas_equalTo(2);
            make.left.equalTo(image.mas_right);
            make.right.equalTo(itemView);
        }];
        [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(self.contentView);
            make.width.mas_equalTo(itemwidth);
        }];
        [self.contentItemArr addObject:itemView];
    }];
    [self.contentItemArr kkEachWithPreAndIndex:^(UIView*  _Nonnull obj, UIView*  _Nonnull preObj, NSUInteger idx) {
        [obj mas_updateConstraints:^(MASConstraintMaker *make) {
            if (preObj) {
                make.left.equalTo(preObj.mas_right);
            }else
            {
                make.left.mas_equalTo(0);
            }
        }];
    }];
}
-(CGFloat)lineWidth
{
    return (SCREEN_WIDTH - 80 - 14 * _contentArr.count)/(_contentArr.count-1);
}
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNBFont(15);
        _titleLabel.textColor = KKHexColor(0C1E48);
        _titleLabel.text = @"出借周期";
    }
    return _titleLabel;
}

-(UIImageView *)titleIcon
{
    if (!_titleIcon) {
        _titleIcon = [[UIImageView alloc]initWithImage:KKImage(@"titleIcon")];
    }
    return _titleIcon;
}
-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}


#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
