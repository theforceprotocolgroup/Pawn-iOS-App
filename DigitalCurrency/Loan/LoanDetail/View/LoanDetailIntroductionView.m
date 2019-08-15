//
//  LoanDetailIntroductionView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/2.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanDetailIntroductionView.h"
#import "LoanDetailInfoViewModel.h"
@interface LoanDetailIntroductionView ()
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
//
@property (nonatomic, strong) YYLabel * protolLabel;
//
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation LoanDetailIntroductionView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    return ^(RACTuple *tuple) {
        RACTupleUnpack(NSArray * contentArr , NSArray * protocolArr) = tuple;
        [self.contentArr removeAllObjects];
        [self.contentArr addObjectsFromArray:contentArr];
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
        _contentArr = [[NSMutableArray alloc]init];
        _contentItemArr = [[NSMutableArray alloc]init];
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.titleIcon];
    [self.titleView addSubview:self.titleLabel];
    [self addSubview:self.contentView];
    [self addSubview:self.protolLabel];
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
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(90);
    }];
    [_titleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.top.equalTo(self.titleView);
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
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom).offset(20);
    }];
    [_protolLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self);
        make.bottom.equalTo(self).offset(-7);
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
        title.font = [UIFont systemFontOfSize:13];
        title.textColor = KKHexColor(9197A7);
        title.text = [NSString stringWithFormat:@"%@",obj.title];
        [itemView addSubview:title];
        
        UILabel * content = [[UILabel alloc]init];
        content.font = [UIFont systemFontOfSize:13];
        content.textColor = KKHexColor(465062);
        content.text = [NSString stringWithFormat:@"%@",obj.content];
        [itemView addSubview:content];
        
        [title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemView.mas_top);
            make.centerY.equalTo(itemView);
            make.bottom.equalTo(itemView);
        }];
        [content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(title);
            make.left.equalTo(title.mas_right).offset(14);
        }];
        [self.contentItemArr addObject:itemView];
    }];
    [self.contentItemArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:19 leadSpacing:0 tailSpacing:0];
    [self.contentItemArr mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(15);
    }];
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
        _titleLabel.text = @"出借说明";
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

-(YYLabel *)protolLabel
{
    if (!_protolLabel) {
        _protolLabel= [[YYLabel alloc]init];
        _protolLabel.font = KKCNFont(11);
    }
    return _protolLabel;
}

#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
