//
//  RechargeHeaderView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "RechargeHeaderView.h"
#import "RechargeModel.h"
@interface RechargeHeaderView ()
//
@property (nonatomic, strong) UILabel * tokenTitleLabel;
//
@property (nonatomic, strong) UIImageView * tokenIcon;
//
@property (nonatomic, strong) UILabel * tokenLabel;
//
@property (nonatomic, strong) UIImageView * accessIcon;
//
@property (nonatomic, strong) UILabel * countTitleLabel;
//
@property (nonatomic, strong) UILabel * countLabel;
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UIControl * tokenControl;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation RechargeHeaderView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    return ^(RechargeModel *tuple) {
        [self.tokenIcon sd_setImageWithURL:[NSURL URLWithString:tuple.iconURI]];
        self.tokenLabel.text = tuple.tokenSymbol;
        NSString * str = [NSString stringWithFormat:@"%@%@",tuple.tokenBalance,tuple.tokenSymbol];
        NSMutableAttributedString * attstr = [NSMutableAttributedString string:str];
        [attstr addAttribute:NSFontAttributeName value:KKCNBFont(16) range:NSMakeRange(0, tuple.tokenBalance.length)];
        [attstr addAttribute:NSFontAttributeName value:KKCNFont(12) range:NSMakeRange(tuple.tokenBalance.length, tuple.tokenSymbol.length)];
        [attstr addAttribute:NSForegroundColorAttributeName value:KKHexColor(041E45) range:NSMakeRange(0, str.length)];
        self.countLabel.attributedText = attstr;
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
        self.backgroundColor = KKHexColor(ffffff);
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.tokenTitleLabel];
    [self addSubview:self.tokenIcon];
    [self addSubview:self.tokenLabel];
    [self addSubview:self.accessIcon];
    [self addSubview:self.countTitleLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.hline];
    [self addSubview:self.tokenControl];

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
    [_tokenTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self).multipliedBy(0.5);
    }];
    [_tokenIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.tokenTitleLabel.mas_right).offset(15);
        make.centerY.equalTo(self.tokenTitleLabel);
        make.height.width.mas_equalTo(20);
    }];
    [_tokenLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.tokenIcon.mas_right).offset(10);
        make.centerY.equalTo(self.tokenTitleLabel);
    }];
    [_accessIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.self.mas_right).offset(-6);
        make.centerY.equalTo(self.tokenTitleLabel);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    [_countTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self).multipliedBy(1.5);
        make.left.equalTo(self).offset(15);
    }];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.countTitleLabel);
        make.left.equalTo(self.countTitleLabel.mas_right).offset(15);
    }];
    [_tokenControl mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.right.equalTo(self);
        make.bottom.equalTo(self.hline.mas_top);
        make.left.equalTo(self.tokenTitleLabel.mas_right);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UILabel *)tokenTitleLabel
{
    if (!_tokenTitleLabel) {
        _tokenTitleLabel = [[UILabel alloc]init];
        _tokenTitleLabel.font = KKCNBFont(15);
        _tokenTitleLabel.textColor = KKHexColor(8F97A6);
        _tokenTitleLabel.text = @"选择币种";
    }
    return _tokenTitleLabel;
}
-(UIImageView *)tokenIcon
{
    if (!_tokenIcon) {
        _tokenIcon = [[UIImageView alloc]init];
    }
    return _tokenIcon;
}
-(UILabel *)tokenLabel
{
    if (!_tokenLabel) {
        _tokenLabel = [[UILabel alloc]init];
        _tokenLabel.font = KKCNFont(15);
        _tokenLabel.textColor = KKHexColor(031E45);
    }
    return _tokenLabel;
}
-(UIImageView *)accessIcon
{
    if (!_accessIcon) {
        _accessIcon = [[UIImageView alloc]initWithImage:KKImage(@"leftArrow")];
    }
    return _accessIcon;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _hline;
}
-(UILabel *)countTitleLabel
{
    if (!_countTitleLabel) {
        _countTitleLabel = [[UILabel alloc]init];
        _countTitleLabel.font = KKCNBFont(15);
        _countTitleLabel.textColor = KKHexColor(8F97A6);
        _countTitleLabel.text = @"币种余额";
    }
    return _countTitleLabel;
}
-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.font = KKCNFont(15);
        _countLabel.textColor = KKHexColor(031E45);
    }
    return _countLabel;
}
-(UIControl *)tokenControl
{
    if (!_tokenControl) {
        _tokenControl = [[UIControl alloc]init];
        _tokenControl.backgroundColor = [UIColor clearColor];
        [_tokenControl addTarget:self action:@selector(clickedToken) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tokenControl;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clickedToken
{
    if (self.actionHandle) {
        self.actionHandle(@"tap");
    }
}



@end
