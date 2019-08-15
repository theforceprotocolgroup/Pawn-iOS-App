//
//  MineHomePageHeaderView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/28.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "MineHomePageHeaderView.h"

@interface MineHomePageHeaderView ()
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UIButton * loginBtn;
//
@property (nonatomic, strong) UIButton * registBtn;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation MineHomePageHeaderView

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
    [self addSubview:self.icon];
    [self addSubview:self.loginBtn];
    [self addSubview:self.registBtn];
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
    [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(12);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(97);
        make.width.mas_equalTo(169);
    }];
    [_loginBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.icon);
        make.top.equalTo(self.icon.mas_bottom).offset(22);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(78);
    }];
    [_registBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.icon);
        make.top.equalTo(self.icon.mas_bottom).offset(22);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(78);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithImage:KKImage(@"mine_no_login")];
    }
    return _icon;
}

-(UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc]init];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 15.f;
        [_loginBtn setBackgroundColor:KKHexColor(4470E4)];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = KKCNFont(14);
        [_loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}
-(UIButton *)registBtn
{
    if (!_registBtn) {
        _registBtn = [[UIButton alloc]init];
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registBtn.layer.masksToBounds = YES;
        _registBtn.layer.cornerRadius = 15.f;
        _registBtn.layer.borderColor = KKHexColor(4470E4).CGColor;
        _registBtn.layer.borderWidth = 1.0f;
        [_registBtn setBackgroundColor:KKHexColor(ffffff)];
        [_registBtn setTitleColor:KKHexColor(4470E4) forState:UIControlStateNormal];
        _registBtn.titleLabel.font = KKCNFont(14);
        [_registBtn addTarget:self action:@selector(clickRegistBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clickLoginBtn
{
    if (self.actionHandle) {
        self.actionHandle(@"login");
    }
}
-(void)clickRegistBtn
{
    if (self.actionHandle) {
        self.actionHandle(@"regist");
    }
}


@end
