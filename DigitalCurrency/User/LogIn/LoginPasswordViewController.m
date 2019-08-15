//
//  LoginPasswordViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/15.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "LoginPasswordViewController.h"
#import <MZTimerLabel/MZTimerLabel.h>

@interface LoginPasswordViewController ()<UITextFieldDelegate>
//
@property (nonatomic, strong) UIControl * acountControl;
//
@property (nonatomic, strong) UIControl * codeControl;
//
@property (nonatomic, strong) UIImageView * logoImageView;
//
@property (nonatomic, strong) UIView * acountView;
//
@property (nonatomic, strong) UIView * codeView;
//
@property (nonatomic, strong) UIView * acountLineView;
//
@property (nonatomic, strong) UIView * codeLineView;
//
@property (nonatomic, strong) UITextField * acountTextField;
//
@property (nonatomic, strong) UITextField * codeTextField;
//
@property (nonatomic, strong) UIButton * acountClearBtn;
//
@property (nonatomic, strong) UIButton * codeClearBtn;
//
@property (nonatomic, strong) UIButton * hidenCodeBtn;
//
@property (nonatomic, strong) UIButton * actionBtn;
//
@property (nonatomic, strong) UIButton * passwordBtn;
//
@property (nonatomic, strong) UIButton * registBtn;
//
@property (nonatomic, assign) BOOL phoneInput;
//
@property (nonatomic, assign) BOOL codeInput;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation LoginPasswordViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(id)tuple {
    
}

#pragma mark - RouterTask
///=============================================================================
/// @name RouterTask
///=============================================================================

- (nullable BFTask *)delegateTask {
    return self.tcs.task;
}

- (BFTaskCompletionSource *)tcs {
    if (!_tcs) {
        _tcs = [BFTaskCompletionSource taskCompletionSource];
    }
    return _tcs;
}

#pragma mark - LifeCycle
///=============================================================================
/// @name LifeCycle
///=============================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.kkHairlineHidden = YES;
    self.kkBarColor = [UIColor clearColor];
    self.kkLeftBarItemHidden= NO;
    self.view.backgroundColor = KKHexColor(ffffff);
    [self addViews];
    [self autoDismissKeyboard];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - View
///=============================================================================
/// @name addViews
///=============================================================================
- (void)addViews {
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.acountControl];
    [self.view addSubview:self.codeControl];
    [self.view addSubview:self.acountView];
    [self.view addSubview:self.codeView];
    [self.acountView addSubview:self.acountLineView];
    [self.codeView addSubview:self.codeLineView];
    [self.acountView addSubview:self.acountTextField];
    [self.codeView addSubview:self.codeTextField];
    [self.acountView addSubview:self.acountClearBtn];
    [self.codeView addSubview:self.codeClearBtn];
    [self.codeView addSubview:self.hidenCodeBtn];
    
    [self.view addSubview:self.actionBtn];
    [self.view addSubview:self.passwordBtn];
    [self.view addSubview:self.registBtn];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.view);
        make.height.width.equalTo(@(60));
        make.top.equalTo(self.view).offset(91);
    }];
    [_acountView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(60);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [_acountTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.acountView);
        make.right.equalTo(self.acountClearBtn.mas_left);
        make.top.equalTo(self.acountView).offset(5);
        make.bottom.equalTo(self.acountView).offset(-5);
        
    }];
    [_acountLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.bottom.equalTo(self.acountView);
        make.height.equalTo(@(1));
    }];
    [_acountClearBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.acountView);
        make.height.width.equalTo(@(25));
        make.bottom.equalTo(self.acountView).offset(-3);
    }];
    
    [_codeView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.acountView.mas_bottom).offset(45);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [_codeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.codeView);
        make.right.equalTo(self.hidenCodeBtn.mas_left);
        make.top.equalTo(self.codeView).offset(5);
        make.bottom.equalTo(self.codeView).offset(-5);
    }];
    [_codeLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.bottom.equalTo(self.codeView);
        make.height.equalTo(@(1));
    }];
    [_codeClearBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.codeView).offset(-3);
        make.right.equalTo(self.codeView);
        make.height.width.equalTo(@(25));
    }];
    [_hidenCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.codeClearBtn);
        make.right.equalTo(self.codeClearBtn.mas_left).offset(-20);
        make.height.width.equalTo(@(25));
    }];
    
    [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.codeView.mas_bottom).offset(45);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@(44));
    }];
    
    [_passwordBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.actionBtn.mas_bottom).offset(22);
        make.left.equalTo(self.actionBtn);
    }];
    [_registBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.actionBtn.mas_bottom).offset(22);
        make.right.equalTo(self.actionBtn);
    }];
    [_acountControl mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.acountView);
        make.left.equalTo(self.acountView);
        make.right.equalTo(self.acountClearBtn.mas_left);
        make.height.mas_equalTo(65);
    }];
    [_codeControl mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.codeView);
        make.left.equalTo(self.codeView);
        make.right.equalTo(self.codeClearBtn.mas_left);
        make.height.mas_equalTo(65);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIControl *)acountControl
{
    if (!_acountControl) {
        _acountControl = [[UIControl alloc]init];
        [_acountControl addTarget:self action:@selector(clickAcountControl) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acountControl;
}
-(UIControl *)codeControl
{
    if (!_codeControl) {
        _codeControl = [[UIControl alloc]init];
        [_codeControl addTarget:self action:@selector(clickCodeControl) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeControl;
}

-(UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]initWithImage:KKImage(@"logo")];
    }
    return _logoImageView;
}
-(UIView *)acountView
{
    if (!_acountView) {
        _acountView = [[UIView alloc]init];
        _acountView.backgroundColor = [UIColor clearColor];
    }
    return _acountView;
}
-(UIView *)codeView
{
    if (!_codeView) {
        _codeView = [[UIView alloc]init];
        _codeView.backgroundColor = [UIColor clearColor];
    }
    return _codeView;
}
-(UITextField *)acountTextField
{
    if (!_acountTextField) {
        _acountTextField = [[UITextField alloc]init];
        _acountTextField.font = KKCNFont(15);
        _acountTextField.textColor = KKHexColor(465062);
        _acountTextField.delegate = self;
        _acountTextField.keyboardType = UIKeyboardTypePhonePad;
        NSMutableAttributedString * att = KKMultiAttriString(@"请输入手机号").kkFont(KKCNFont(15)).kkColor(KKHexColor(C7CED9));
        _acountTextField.attributedPlaceholder = att;
        @weakify(self);
        [_acountTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.acountClearBtn.hidden = !x.length;
            self.phoneInput = x.length>=11 ? YES:NO;
            self.actionBtn.enabled = self.phoneInput && self.codeInput;
        }];
    }
    return _acountTextField;
}
-(UITextField *)codeTextField
{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc]init];
        _codeTextField.font = KKCNFont(15);
        _codeTextField.textColor = KKHexColor(465062);
        _codeTextField.delegate = self;
        _codeTextField.secureTextEntry = YES;
        NSMutableAttributedString * att = KKMultiAttriString(@"请输入登录密码").kkFont(KKCNFont(15)).kkColor(KKHexColor(C7CED9));
        _codeTextField.attributedPlaceholder = att;
        @weakify(self);
        [_codeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.codeClearBtn.hidden = self.hidenCodeBtn.hidden = !x.length;
            self.codeInput = x.length>=8 ? YES:NO;
            self.actionBtn.enabled = self.phoneInput && self.codeInput;
        }];
    }
    return _codeTextField;
}
-(UIView *)acountLineView
{
    if (!_acountLineView) {
        _acountLineView = [[UIView alloc]init];
        _acountLineView.backgroundColor = KKHexColor(E0E0E0);
    }
    return _acountLineView;
}
-(UIView *)codeLineView
{
    if (!_codeLineView) {
        _codeLineView = [[UIView alloc]init];
        _codeLineView.backgroundColor = KKHexColor(E0E0E0);
    }
    return _codeLineView;
}
-(UIButton *)acountClearBtn
{
    if (!_acountClearBtn) {
        _acountClearBtn = [[UIButton alloc]init];
        [_acountClearBtn setImage:KKImage(@"clearBtn") forState:UIControlStateNormal];
        _acountClearBtn.hidden = YES;
        [_acountClearBtn addTarget:self action:@selector(clickAccountClearButton) forControlEvents:UIControlEventTouchUpInside];
        [_acountClearBtn kkExtendHitTestSizeByWidth:50 height:50];
    }
    return _acountClearBtn;
}
-(UIButton *)codeClearBtn
{
    if (!_codeClearBtn) {
        _codeClearBtn = [[UIButton alloc]init];
        [_codeClearBtn setImage:KKImage(@"clearBtn") forState:UIControlStateNormal];
        _codeClearBtn.hidden = YES;
        [_codeClearBtn addTarget:self action:@selector(clickCodeClearButton) forControlEvents:UIControlEventTouchUpInside];
        [_codeClearBtn kkExtendHitTestSizeByWidth:50 height:50];
    }
    return _codeClearBtn;
}
-(UIButton *)hidenCodeBtn
{
    if (!_hidenCodeBtn) {
        _hidenCodeBtn = [[UIButton alloc]init];
        [_hidenCodeBtn setImage:KKImage(@"unVisiable") forState:UIControlStateNormal];
        [_hidenCodeBtn setImage:KKImage(@"visiable") forState:UIControlStateSelected];
        [_hidenCodeBtn addTarget:self action:@selector(clickCodeHidenButton) forControlEvents:UIControlEventTouchUpInside];
        [_hidenCodeBtn kkExtendHitTestSizeByWidth:20 height:20];
    }
    return _hidenCodeBtn;
}
-(UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc]init];
        _actionBtn.kkButtonType = KKButtonTypePriSolid;
        [_actionBtn setTitle:@"登录" forState:UIControlStateNormal];
        _actionBtn.titleLabel.font = KKCNFont(15);
        [_actionBtn addTarget:self action:@selector(clickActionButton) forControlEvents:UIControlEventTouchUpInside];
        _actionBtn.enabled = NO;
    }
    return _actionBtn;
}
-(UIButton *)passwordBtn
{
    if (!_passwordBtn) {
        _passwordBtn = [[UIButton alloc]init];
        [_passwordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_passwordBtn setTitleColor:KKHexColor(C7C7CD) forState:UIControlStateNormal];
        _passwordBtn.titleLabel.font = KKCNFont(13);
        [_passwordBtn addTarget:self action:@selector(clickPasswordButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordBtn;
}
-(UIButton *)registBtn
{
    if (!_registBtn) {
        _registBtn = [[UIButton alloc]init];
        [_registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        [_registBtn setTitleColor:KKHexColor(5170EB) forState:UIControlStateNormal];
        _registBtn.titleLabel.font = KKCNFont(14);
        [_registBtn addTarget:self action:@selector(clickRegistButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}


#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _acountTextField) {
        self.acountClearBtn.hidden = YES;
    }else
    {
        self.codeClearBtn.hidden = YES;
        self.hidenCodeBtn.hidden = YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _acountTextField) {
        self.acountClearBtn.hidden = NO;
    }else
    {
        self.codeClearBtn.hidden = NO;
        self.hidenCodeBtn.hidden = NO;
    }
}


#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickAcountControl
{
    [self.acountTextField becomeFirstResponder];
}
-(void)clickCodeControl
{
    [self.codeTextField becomeFirstResponder];
}
-(void)clickAccountClearButton
{
    self.acountTextField.text = @"";
    self.acountClearBtn.hidden = YES;
    self.phoneInput = NO;
    self.actionBtn.enabled = NO;
}
-(void)clickCodeClearButton
{
    self.codeTextField.text = @"";
    self.codeClearBtn.hidden = YES;
    self.hidenCodeBtn.hidden = YES;
    self.codeInput = NO;
    self.actionBtn.enabled = NO;
}
-(void)clickActionButton
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(@{@"phoneNumber":self.acountTextField.text,@"password":self.codeTextField.text.kkMd5}).view(self.view).needCustomFormat(YES).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            NSDictionary * dic = @{@"userId":result.data[@"uid"] ? result.data[@"uid"] : @"",
                                   @"md_access_token": result.data[@"token"] ?result.data[@"token"] :@"",
                                   @"mobile":self.acountTextField.text,
                                   };
            [UserManager saveUserInfo:dic];
            [self.tcs trySetResult:@(YES)];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)clickPasswordButton
{
    [KKRouter pushUri:@"RegistViewController" params:[NSNumber numberWithBool:YES]];
}
-(void)clickRegistButton
{
    [KKRouter pushUri:@"RegistViewController" params:[NSNumber numberWithBool:NO]];
}
-(void)clickCodeHidenButton
{
    self.hidenCodeBtn.selected = !self.hidenCodeBtn.selected;
    if (self.hidenCodeBtn.selected) { // 按下去了就是明文
        NSString *tempPwdStr = self.codeTextField.text;
        self.codeTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.codeTextField.secureTextEntry = NO;
        self.codeTextField.text = tempPwdStr;
    } else { // 暗文
        NSString *tempPwdStr = self.codeTextField.text;
        self.codeTextField.text = @"";
        self.codeTextField.secureTextEntry = YES;
        self.codeTextField.text = tempPwdStr;
    }
    
}

#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================




#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================





@end
