//
//  LoanPayView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/10.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanPayView.h"
#import "LoanConfirmModel.h"
@interface LoanPayView ()
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIImageView * titleIcon;
//
@property (nonatomic, strong) UILabel * countTitleLabel;
//
@property (nonatomic, strong) UILabel * countLabel;
//
@property (nonatomic, strong) UIView * hline;
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
@property (nonatomic, strong) UILabel * feeLabel;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) LoanConfirmModel * model;

@end

@implementation LoanPayView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    return ^(LoanConfirmModel *tuple) {
        self.model = tuple;
        [self.tokenAccountIcon sd_setImageWithURL:[NSURL URLWithString:self.model.walletInfo.iconURI]];
        NSString * str = [NSString stringWithFormat:@"%@%@",self.model.paymentInfo.paymentCount,self.model.paymentInfo.tokenType];
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attStr addAttributes:@{NSFontAttributeName:KKThirdFont(20),
                                NSForegroundColorAttributeName:KKHexColor(0C1E48)
                                } range:NSMakeRange(0, self.model.paymentInfo.paymentCount.length)];
        [attStr addAttributes:@{NSFontAttributeName:KKCNFont(15),
                                NSForegroundColorAttributeName:KKHexColor(0C1E48)
                                } range:NSMakeRange(self.model.paymentInfo.paymentCount.length, self.model.paymentInfo.tokenType.length)];
        self.countLabel.attributedText = attStr;
        self.tokenAccountTitleLabel.text = [NSString stringWithFormat:@"%@账户钱包",self.model.walletInfo.tokenType];
        NSString * str1 = [NSString stringWithFormat:@"余额：%@",self.model.walletInfo.tokenBalance];
        NSMutableAttributedString * attStr1 = [[NSMutableAttributedString alloc]initWithString:str1];
        [attStr1 addAttributes:@{NSFontAttributeName:KKCNFont(12),
                                 NSForegroundColorAttributeName:KKHexColor(0C1E48)
                                 } range:NSMakeRange(0, 3)];
        [attStr1 addAttributes:@{NSFontAttributeName:KKThirdFont(14),
                                 NSForegroundColorAttributeName:KKHexColor(FF7120)
                                 } range:NSMakeRange(3, str1.length-3)];
        self.enableTokenLabel.attributedText = attStr1;
        self.tipsLabel.text = self.model.tips;
        self.feeLabel.text = [NSString stringWithFormat:@"含手续费%@%@",self.model.paymentInfo.fee,self.model.paymentInfo.tokenType];
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
        [self addViews];
        self.backgroundColor = KKHexColor(ffffff);
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.titleIcon];
    [self.titleView addSubview:self.titleLabel];
    [self addSubview:self.countTitleLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.feeLabel];
    [self addSubview:self.hline];
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
    [_countTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.titleView.mas_bottom).offset(25);
    }];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.countTitleLabel);
        make.left.equalTo(self.countTitleLabel.mas_right).offset(32);
    }];
    [_feeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.countLabel.mas_bottom).offset(5);
        make.left.equalTo(self.countLabel.mas_left);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self.countTitleLabel).offset(23);
        make.height.mas_equalTo(0.5);
    }];
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.hline.mas_bottom).offset(12);
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
        make.bottom.equalTo(self.backView.mas_bottom).offset(-17);
    }];
    [_rechargeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.backView).offset(-12);
        make.bottom.equalTo(self.backView).offset(-18);
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
        _titleLabel.text = @"支付信息";
    }
    return _titleLabel;
}
-(UILabel *)feeLabel
{
    if (!_feeLabel) {
        _feeLabel = [[UILabel alloc]init];
        _feeLabel.font = KKCNFont(10);
        _feeLabel.textColor = KKHexColor(9FA4B8);
    }
    return _feeLabel;
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

-(UILabel *)countTitleLabel
{
    if (!_countTitleLabel) {
        _countTitleLabel = [[UILabel alloc]init];
        _countTitleLabel.font = KKCNBFont(15);
        _countTitleLabel.textColor = KKHexColor(5D616B);
        _countTitleLabel.text = @"您需支付";
    }
    return _countTitleLabel;
}
-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.textColor = KKHexColor(0C1E48);
    }
    return _countLabel;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _hline;
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





@end
