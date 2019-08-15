//
//  BorrowLoanView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/21.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowLoanView.h"
#import "BorrowLoanViewModel.h"
@interface BorrowLoanView ()
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIImageView * titleIcon;
//
@property (nonatomic, strong) UIImageView * loanTitleIcon;
//
@property (nonatomic, strong) UILabel * loanTitleLabel;
//
@property (nonatomic, strong) UIImageView * tokenIcon;
//
@property (nonatomic, strong) UILabel * tokenLabel;
//
@property (nonatomic, strong) UIImageView * accessIcon;
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UILabel * needLoanLabel;
//
@property (nonatomic, strong) UIView * backView;
//
@property (nonatomic, strong) UIImageView * tokenAccountIcon;
//
@property (nonatomic, strong) UILabel * tokenAccountTitleLabel;
//
@property (nonatomic, strong) UILabel * enableTokenLabel;
//
@property (nonatomic, strong) UIButton * rechargeBtn;
//
@property (nonatomic, strong) UILabel * tipsLabel;
//
@property (nonatomic, strong) UIControl * tokenChangeControl;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) BorrowLoanViewModel * model;

@end

@implementation BorrowLoanView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    return ^(BorrowLoanViewModel *tuple) {
        self.model = tuple;
        [self.tokenIcon sd_setImageWithURL:[NSURL URLWithString:self.model.iconURI]];
        self.tokenLabel.text = self.model.mrgeType;
        NSString * str = [NSString stringWithFormat:@"需要质押数额：%@",self.model.needMrgeCount];
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attStr addAttributes:@{NSFontAttributeName:KKCNFont(11),
                                NSForegroundColorAttributeName:KKHexColor(435061)
                                } range:NSMakeRange(0, 7)];
        [attStr addAttributes:@{NSFontAttributeName:KKThirdFont(13),
                                NSForegroundColorAttributeName:KKHexColor(FF7120)
                                } range:NSMakeRange(7, str.length-7)];
        self.needLoanLabel.attributedText = attStr;
        self.tokenAccountIcon.image = self.tokenIcon.image;
        self.tokenAccountTitleLabel.text = [NSString stringWithFormat:@"%@账户钱包",self.model.mrgeType];
        NSString * str1 = [NSString stringWithFormat:@"余额：%@",self.model.balance];
        NSMutableAttributedString * attStr1 = [[NSMutableAttributedString alloc]initWithString:str1];
        [attStr1 addAttributes:@{NSFontAttributeName:KKCNFont(12),
                                NSForegroundColorAttributeName:KKHexColor(0C1E48)
                                } range:NSMakeRange(0, 3)];
        [attStr1 addAttributes:@{NSFontAttributeName:KKThirdFont(17),
                                NSForegroundColorAttributeName:KKHexColor(0C1E48)
                                } range:NSMakeRange(3, str1.length-3)];
        self.enableTokenLabel.attributedText = attStr1;
        self.tipsLabel.text = self.model.tips;
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
        self.layer.cornerRadius = 5;
        [self addViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.titleIcon];
    [self.titleView addSubview:self.titleLabel];
    [self addSubview:self.loanTitleIcon];
    [self addSubview:self.loanTitleLabel];
    [self addSubview:self.tokenChangeControl];
    [self addSubview:self.tokenIcon];
    [self addSubview:self.tokenLabel];
    [self addSubview:self.accessIcon];
    [self addSubview:self.hline];
    [self addSubview:self.needLoanLabel];
    [self addSubview:self.backView];
    [self.backView addSubview:self.tokenAccountIcon];
    [self.backView addSubview:self.tokenAccountTitleLabel];
    [self.backView addSubview:self.enableTokenLabel];
    [self.backView addSubview:self.rechargeBtn];
    [self addSubview:self.tipsLabel];
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
        make.height.mas_equalTo(30);
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
        make.centerY.equalTo(self.titleIcon);
        make.left.equalTo(self.titleIcon.mas_right).offset(8);
    }];
    [_loanTitleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleView.mas_bottom).offset(20);
        make.left.equalTo(self).offset(15);
        make.height.width.mas_equalTo(17);
    }];
    [_loanTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.loanTitleIcon);
        make.left.equalTo(self.loanTitleIcon.mas_right).offset(12);
    }];
    [_tokenChangeControl mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.loanTitleLabel.mas_right);
        make.right.equalTo(self);
        make.top.equalTo(self.loanTitleLabel);
        make.bottom.equalTo(self.hline);
    }];
    [_tokenIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.loanTitleIcon);
        make.left.equalTo(self.loanTitleLabel.mas_right).offset(33);
        make.height.width.mas_equalTo(20);
    }];
    [_tokenLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.loanTitleIcon);
        make.left.equalTo(self.tokenIcon.mas_right).offset(10);
    }];
    [_accessIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.loanTitleIcon);
        make.right.equalTo(self.mas_right).offset(-3);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(44);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.loanTitleIcon.mas_bottom).offset(22);
        make.height.mas_equalTo(0.5);
    }];
    [_needLoanLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.hline);
        make.top.equalTo(self.hline.mas_bottom).offset(8);
    }];
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.needLoanLabel.mas_bottom).offset(28);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(73);
    }];
    [_tokenAccountIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.backView).offset(13);
        make.left.equalTo(self.backView).offset(8);
        make.height.width.mas_equalTo(20);
    }];
    [_tokenAccountTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.tokenAccountIcon);
        make.left.equalTo(self.tokenAccountIcon.mas_right).offset(10);
    }];
    [_enableTokenLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.backView).offset(11);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-13);
    }];
    [_rechargeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.backView).offset(-12);
        make.bottom.equalTo(self.enableTokenLabel).offset(-2);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
    }];
    [_tipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
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
        _titleLabel.text = @"质押信息";
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

-(UIImageView *)loanTitleIcon
{
    if (!_loanTitleIcon) {
        _loanTitleIcon = [[UIImageView alloc]initWithImage:KKImage(@"borrow_home_4")];
    }
    return _loanTitleIcon;
}
-(UILabel *)loanTitleLabel
{
    if (!_loanTitleLabel) {
        _loanTitleLabel = [[UILabel alloc]init];
        _loanTitleLabel.font = KKCNBFont(15);
        _loanTitleLabel.textColor = KKHexColor(9197A7);
        _loanTitleLabel.text = @"质押币种";
    }
    return _loanTitleLabel;
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
        _tokenLabel.textColor = KKHexColor(0C1E48);
        _tokenLabel.font = KKCNBFont(15);
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
        _hline.backgroundColor = KKHexColor(E0E0E0);
    }
    return _hline;
}
-(UILabel *)needLoanLabel
{
    if (!_needLoanLabel) {
        _needLoanLabel = [[UILabel alloc]init];
    }
    return _needLoanLabel;
}
-(UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = KKHexColor(F7F9FD);
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5.0f;
    }
    return _backView;
}
-(UIImageView *)tokenAccountIcon
{
    if (!_tokenAccountIcon) {
        _tokenAccountIcon = [[UIImageView alloc]init];
    }
    return _tokenAccountIcon;
}
-(UILabel *)tokenAccountTitleLabel
{
    if (!_tokenAccountTitleLabel) {
        _tokenAccountTitleLabel = [[UILabel alloc]init];
        _tokenAccountTitleLabel.textColor = KKHexColor(0C1E48);
        _tokenAccountTitleLabel.font = KKCNFont(12);
    }
    return _tokenAccountTitleLabel;
}
-(UILabel *)enableTokenLabel
{
    if (!_enableTokenLabel) {
        _enableTokenLabel = [[UILabel alloc]init];
    }
    return _enableTokenLabel;
}
-(UIButton *)rechargeBtn
{
    if (!_rechargeBtn) {
        _rechargeBtn = [[UIButton alloc]init];
        [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rechargeBtn setBackgroundColor:KKHexColor(93D5FF)];
        _rechargeBtn.titleLabel.font = KKCNFont(13);
        _rechargeBtn.layer.cornerRadius = 13;
        _rechargeBtn.layer.shadowColor = [UIColor colorWithRed:51/255.0 green:168/255.0 blue:243/255.0 alpha:0.11].CGColor;
        _rechargeBtn.layer.shadowOffset = CGSizeMake(0,3);
        _rechargeBtn.layer.shadowOpacity = 1;
        _rechargeBtn.layer.shadowRadius = 4;
        _rechargeBtn.layer.borderWidth = 0.5;
        _rechargeBtn.layer.borderColor = [UIColor colorWithRed:122/255.0 green:204/255.0 blue:255/255.0 alpha:1.0].CGColor;
        [_rechargeBtn addTarget:self action:@selector(clickedRechageBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}
-(UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.font = KKCNFont(11);
        _tipsLabel.textColor = KKHexColor(9197A7);
    }
    return _tipsLabel;
}
-(UIControl *)tokenChangeControl
{
    if (!_tokenChangeControl) {
        _tokenChangeControl = [[UIControl alloc]init];
        _tokenChangeControl.backgroundColor = [UIColor clearColor];
        [_tokenChangeControl addTarget:self action:@selector(changeToken) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tokenChangeControl;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickedRechageBtn
{
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"request",@"recharge"));
    }
}

-(void)changeToken
{
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"push",@"TokenListViewController",@"merge"));
    }
}


@end
