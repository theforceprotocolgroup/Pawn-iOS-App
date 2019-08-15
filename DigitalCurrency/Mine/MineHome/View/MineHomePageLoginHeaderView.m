//
//  MineHomePageLoginHeaderView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/30.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "MineHomePageLoginHeaderView.h"
#import "MineHomeModel.h"

@interface MineHomePageLoginHeaderView ()
//
@property (nonatomic, strong) UIImageView * backView;
//
@property (nonatomic, strong) UILabel * quoetTotleTypeLabel;
//
@property (nonatomic, strong) UILabel * quoetTotleLabel;
//
@property (nonatomic, strong) UILabel * quoetLabel;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) MineHomeModel* model;

@end

@implementation MineHomePageLoginHeaderView

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
    return ^(MineHomeModel *tuple) {
        @strongify(self);
        self.model = tuple;
        self.quoetTotleTypeLabel.text =[ NSString stringWithFormat:@"账户总余额（%@）",self.model.quotesToken ];
        self.quoetTotleLabel.text = self.model.quotesTokenCount;
        self.quoetLabel.text = [NSString stringWithFormat:@"≈%@ %@",self.model.quotesCurrency,self.model.quotesCurrencyCount];
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
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.backView];
    [self addSubview:self.quoetTotleTypeLabel];
    [self addSubview:self.quoetTotleLabel];
    [self addSubview:self.quoetLabel];
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
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self).offset(4);
        make.right.equalTo(self).offset(-4);
        make.bottom.equalTo(self).offset(-14);
        make.top.equalTo(self);
    }];
    [_quoetTotleTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.backView).offset(49);
        make.centerX.equalTo(self.backView);
    }];
    [_quoetTotleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.quoetTotleTypeLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
    }];
    [_quoetLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.quoetTotleLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.backView);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIImageView *)backView
{
    if (!_backView) {
        _backView = [[UIImageView alloc]initWithImage:KKImage(@"mine_login_header")];
    }
    return _backView;
}
-(UILabel *)quoetTotleTypeLabel
{
    if (!_quoetTotleTypeLabel) {
        _quoetTotleTypeLabel = [[UILabel alloc]init];
        _quoetTotleTypeLabel.textColor = KKHexColor(DAE3FE);
        _quoetTotleTypeLabel.font = KKCNFont(12);
        _quoetTotleTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _quoetTotleTypeLabel;
}
-(UILabel *)quoetTotleLabel
{
    if (!_quoetTotleLabel) {
        _quoetTotleLabel = [[UILabel alloc]init];
        _quoetTotleLabel.textColor = KKHexColor(ffffff);
        _quoetTotleLabel.font = KKThirdFont(25);//KKCNFont(25);
        _quoetTotleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _quoetTotleLabel;
}
-(UILabel *)quoetLabel
{
    if (!_quoetLabel) {
        _quoetLabel = [[UILabel alloc]init];
        _quoetLabel.textColor = KKHexColor(ffffff);
        _quoetLabel.font = KKThirdFont(10);
        _quoetLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _quoetLabel;
}


#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
