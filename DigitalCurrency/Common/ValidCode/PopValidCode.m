//
//  PopValidCode.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "PopValidCode.h"
#import <MZTimerLabel/MZTimerLabel.h>

@interface PopValidCode ()
//
@property (nonatomic, strong) UIView * bgView;
//
@property (nonatomic, strong) UIView * superVeiw;
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIButton * closeBtn;
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UIView * textFieldBackView;
//
@property (nonatomic, strong) UITextField * textField;
//
@property (nonatomic, strong) MZTimerLabel * countLabel;
//
@property (nonatomic, strong) UIButton * clickedBtn;
//
@property (nonatomic, strong) UILabel * resultLabel;
//
@property (nonatomic, strong) UIActivityIndicatorView * activ;
//
@property (nonatomic, assign) BOOL isShow;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation PopValidCode

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
    CGRect tmpFrame = CGRectMake(0, 0, SCREEN_WIDTH, 217);
    if (self = [super initWithFrame:tmpFrame]) {
        self.actionHandle = action;
        self.model = model;
        [self addViews];
        self.backgroundColor = KKHexColor(ffffff);
        self.isShow = NO;
    }
    return self;
}
+ (instancetype)showWithTitle:(NSString *)title superView:(UIView * _Nullable )superView action:(KKActionHandle)handle;
{
    PopValidCode * view = [[PopValidCode  alloc]initWithFrame:CGRectZero model:nil action:handle];
    view.superVeiw = superView?:[UIApplication sharedApplication].keyWindow;
    view.center = CGPointMake(view.superVeiw.width/2, view.superVeiw.height);
    view.titleLabel.text = title.length ? title : @"确认支付";
    return view;
}
- (void)show;
{
    // 添加对键盘的监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.superVeiw addSubview:self.bgView];
    [self.superVeiw addSubview:self];
    
    [self.textField becomeFirstResponder];
    self.isShow = YES;
    [self startTimer];
    
}
- (void)dismiss;
{
    self.clickedBtn.enabled = YES;
    [self.activ stopAnimating];
    self.isShow = NO;
    [self.textField resignFirstResponder];
}

-(void)startTimer
{
    if (!self.isShow) {
        [self show];
        return;
    }
    self.countLabel.timeFormat = @"ss's'后重发";
    self.countLabel.textColor = KKHexColor(ffffff);
    [self.countLabel setCountDownTime:60];
    [self.countLabel start];
    self.countLabel.backgroundColor = KKHexColor(CAD5EB);
}
- (void)addViews {
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.titleLabel];
    [self.titleView addSubview:self.closeBtn];
    [self.titleView addSubview:self.hline];
    [self.titleView addSubview:self.activ];
    [self addSubview:self.textFieldBackView];
    [self.textFieldBackView addSubview:self.textField];
    [self addSubview:self.countLabel];
    [self addSubview:self.resultLabel];
    [self addSubview:self.clickedBtn];
}
- (void)showErrorMessage:(NSString*)message;
{
    self.clickedBtn.enabled = YES;
    [self.activ stopAnimating];
    self.resultLabel.text = message;
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
        make.height.mas_equalTo(44);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.centerY.equalTo(self.titleView);
    }];
    [_closeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.right.equalTo(self.titleView);
        make.height.width.mas_equalTo(44);
    }];
    [_activ mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.titleView);
        make.left.equalTo(self.titleView).offset(15);
        make.height.width.mas_equalTo(40);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.left.right.equalTo(self.titleView);
        make.height.mas_equalTo(0.5);
    }];
    [_textFieldBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.titleView.mas_bottom).offset(17);
        make.height.mas_equalTo(55);
    }];
     [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.bottom.top.equalTo(self.textFieldBackView);
         make.left.equalTo(self.textFieldBackView).offset(12);
     }];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).offset(-15);
        make.left.equalTo(self.textFieldBackView.mas_right);
        make.top.bottom.equalTo(self.textFieldBackView);
        make.width.mas_equalTo(106);
    }];
    [_clickedBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.textFieldBackView.mas_bottom).offset(12);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(44);
    }];
    [_resultLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.clickedBtn.mas_bottom).offset(12);
        make.centerX.equalTo(self);
    }];
     
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.textFieldBackView.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                           cornerRadii:CGSizeMake(5.0f, 5.0f)];
    CAShapeLayer * borderLayer = [[CAShapeLayer alloc]init];
    borderLayer.frame = self.textFieldBackView.bounds;
    borderLayer.lineWidth = 0.5f;
    borderLayer.strokeColor = KKHexColor(e0e0e0).CGColor;
    borderLayer.fillColor = KKHexColor(f5f5f7).CGColor;
    borderLayer.path = maskPath.CGPath;
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.textFieldBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    [self.textFieldBackView.layer insertSublayer:borderLayer atIndex:0];
    self.textFieldBackView.layer.mask = maskLayer;
    
    UIBezierPath *maskPath1;
    maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.countLabel.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(5.0f, 5.0f)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = self.countLabel.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.countLabel.layer.mask = maskLayer1;
}
#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = KKHexColor(465062);
        _titleLabel.font = KKCNFont(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _hline;
}
-(UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:KKImage(@"closeBtn") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickedClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
-(UIView *)textFieldBackView
{
    if (!_textFieldBackView) {
        _textFieldBackView = [[UIView alloc]init];
        _textFieldBackView.layer.masksToBounds = YES;
    }
    return _textFieldBackView;
}
-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textColor = KKHexColor(435061);
        _textField.font = KKCNFont(15);
        _textField.keyboardType = UIKeyboardTypePhonePad;
        NSMutableAttributedString * att = KKMultiAttriString(@"短信验证码").kkFont(KKCNFont(14)).kkColor(KKHexColor(C7C7CD));
        _textField.attributedPlaceholder = att;
        @weakify(self);
        [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.clickedBtn.enabled =  x.length >= 6;
        }];
    }
    return _textField;
}
-(UIActivityIndicatorView *)activ
{
    if (!_activ) {
        _activ = [[UIActivityIndicatorView alloc]init];
        _activ.hidesWhenStopped = YES;
        _activ.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _activ;
}
-(MZTimerLabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[MZTimerLabel alloc]init];
        _countLabel.timerType = MZTimerLabelTypeTimer;
        _countLabel.font = KKCNFont(14);
        _countLabel.textColor = KKHexColor(ffffff);
        _countLabel.backgroundColor = KKHexColor(5170EB);
        _countLabel.text = @"发送验证码";
        _countLabel.textAlignment = NSTextAlignmentCenter;
        @weakify(self);
        [_countLabel setEndedBlock:^(NSTimeInterval x) {
            @strongify(self);
            self.countLabel.backgroundColor = KKHexColor(5170EB);
            [self.countLabel reset];
            self.countLabel.textColor = KKHexColor(ffffff);
            self.countLabel.text = @"重发";
        }];
        [_countLabel kkAddTapAction:^(id  _Nullable x) {
            @strongify(self);
            if (!self.countLabel.counting) {
                //发送验证码
                if (self.actionHandle) {
                    self.actionHandle(RACTuplePack(@"code"));
                }
            }
        }];
        
    }
    return _countLabel;
}
-(UIButton *)clickedBtn
{
    if (!_clickedBtn) {
        _clickedBtn = [[UIButton alloc]init];
        _clickedBtn.kkButtonType = KKButtonTypePriSolid;
        [_clickedBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        _clickedBtn.titleLabel.font = KKCNFont(15);
        [_clickedBtn addTarget:self action:@selector(clickActionButton) forControlEvents:UIControlEventTouchUpInside];
        _clickedBtn.enabled = NO;
    }
    return _clickedBtn;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColorHex(070A14);
        _bgView.alpha = 0.01f;
        _bgView.frame = _superVeiw.bounds;
        [_bgView kkAddTapAction:^(RACTuple *x){
            [self dismiss];
        }];
    }
    return _bgView;
}
-(UILabel *)resultLabel
{
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.textColor = KKHexColor(E84A55);
        _resultLabel.font = KKCNFont(14);
        _resultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _resultLabel;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clickedClose
{
    [self dismiss];
}
-(void)clickActionButton
{
    self.resultLabel.text = @"";
    self.clickedBtn.enabled = NO;
    [self.activ startAnimating];
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"check",self.textField.text));
    }
}

- (void)keyBoardWillShow:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    [UIView animateWithDuration:animationTime animations:^{
        self.frame = CGRectSetY(self.frame, SCREEN_HEIGHT-self.height-keyBoardHeight);
        self.bgView.alpha = .3f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyBoardWillHide:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    [UIView animateWithDuration:animationTime animations:^{
        self.frame = CGRectSetY(self.frame, SCREEN_HEIGHT);
        self.bgView.alpha = .0f;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }];
}
@end
