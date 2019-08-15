//
//  SetPasswordViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/15.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "ProtocolModel.h"
@interface SetPasswordViewController ()<UITextFieldDelegate>
//
@property (nonatomic, strong) UIControl * codeControl;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIView * codeView;
//
@property (nonatomic, strong) UIView * codeLineView;
//
@property (nonatomic, strong) UITextField * codeTextField;
//
@property (nonatomic, strong) UIButton * hidenCodeBtn;
//
@property (nonatomic, strong) UIButton * codeClearBtn;
//
@property (nonatomic, strong) UIButton * actionBtn;
//
@property (nonatomic, strong) UILabel * protocolLabel;
//
@property (nonatomic, strong) UIButton * protocolBtn;
//
@property (nonatomic, strong) UIView * protocolView;
//
@property (nonatomic, strong) NSArray * protocolArr;
//
@property (nonatomic, assign) BOOL codeInput;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation SetPasswordViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(RACTuple *)tuple {
    self.isReset = [(NSNumber *)tuple.first boolValue];
    self.phone = tuple.second;
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
    _protocolArr = [[NSMutableArray alloc]init];
    [self requestProtocol];
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
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.codeControl];

    [self.view addSubview:self.codeView];
    [self.codeView addSubview:self.codeLineView];
    [self.codeView addSubview:self.codeTextField];
    [self.codeView addSubview:self.codeClearBtn];
    [self.codeView addSubview:self.hidenCodeBtn];
    
    [self.view addSubview:self.actionBtn];
    if (!self.isReset) {
        [self.view addSubview:self.protocolView];
        [self.protocolView addSubview:self.protocolLabel];
        [self.protocolView addSubview:self.protocolBtn];
    }
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).offset(126);
        make.left.equalTo(self.view).offset(30);
    }];
    [_codeView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(60);
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
        make.right.equalTo(self.codeView);
        make.height.width.equalTo(@(25));
        make.bottom.equalTo(self.codeView).offset(-3);
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
    [_protocolView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.view.mas_bottom).offset(-39);
        make.centerX.equalTo(self.view);
    }];
    [_protocolLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.protocolView);
        make.left.equalTo(self.protocolView);
    }];
    [_protocolBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.protocolView);
        make.left.equalTo(self.protocolLabel.mas_right).offset(5);
        make.right.equalTo(self.protocolView.mas_right);
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
-(UIControl *)codeControl
{
    if (!_codeControl) {
        _codeControl = [[UIControl alloc]init];
        [_codeControl addTarget:self action:@selector(clickCodeControl) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeControl;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNBFont(25);
        _titleLabel.textColor = KKHexColor(465062);
        _titleLabel.text = self.isReset ? @"重置密码" : @"设置密码";
    }
    return _titleLabel;
}
-(UIView *)codeView
{
    if (!_codeView) {
        _codeView = [[UIView alloc]init];
        _codeView.backgroundColor = [UIColor clearColor];
    }
    return _codeView;
}
-(UITextField *)codeTextField
{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc]init];
        _codeTextField.font = KKCNFont(15);
        _codeTextField.textColor = KKHexColor(465062);
        _codeTextField.secureTextEntry = YES;
        _codeTextField.delegate = self;
        NSMutableAttributedString * att = KKMultiAttriString(@"密码,至少6位包含大小写字母、数字与特殊字符组合").kkFont(KKCNFont(15)).kkColor(KKHexColor(C7CED9));
        _codeTextField.attributedPlaceholder = att;
        @weakify(self);
        [_codeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.codeClearBtn.hidden = !x.length;
            self.codeInput = x.length >= 6 ? YES:NO;
            self.actionBtn.enabled = self.codeInput;
        }];
    }
    return _codeTextField;
}
-(UIView *)codeLineView
{
    if (!_codeLineView) {
        _codeLineView = [[UIView alloc]init];
        _codeLineView.backgroundColor = KKHexColor(E0E0E0);
    }
    return _codeLineView;
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
        _hidenCodeBtn.hidden = YES;
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
        [_actionBtn setTitle:self.isReset ? @"提交" : @"注册" forState:UIControlStateNormal];
        _actionBtn.titleLabel.font = KKCNFont(15);
        [_actionBtn addTarget:self action:@selector(clickActionButton) forControlEvents:UIControlEventTouchUpInside];
        _actionBtn.enabled = NO;
    }
    return _actionBtn;
}
-(UIView *)protocolView
{
    if (!_protocolView) {
        _protocolView = [[UIView alloc]init];
        _protocolView.backgroundColor = [UIColor whiteColor];
    }
    return _protocolView;
}
-(UILabel *)protocolLabel
{
    if (!_protocolLabel) {
        _protocolLabel = [[UILabel alloc]init];
        _protocolLabel.font = KKCNFont(11);
        _protocolLabel.textColor = KKHexColor(C7CED9);
        _protocolLabel.text = @"注册即表示已经阅读并同意";
    }
    return _protocolLabel;
}
-(UIButton *)protocolBtn
{
    if (!_protocolBtn) {
        _protocolBtn = [[UIButton alloc]init];
        [_protocolBtn setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
        [_protocolBtn setTitleColor:KKHexColor(5170EB) forState:UIControlStateNormal];
        _protocolBtn.titleLabel.font = KKCNFont(11);
        [_protocolBtn addTarget:self action:@selector(clickProtocolButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolBtn;
}

#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.codeClearBtn.hidden = YES;
    self.hidenCodeBtn.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.codeClearBtn.hidden = NO;
    self.hidenCodeBtn.hidden = NO;

}


#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickCodeControl
{
    [self.codeTextField becomeFirstResponder];
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
    if ([self passwordValided:self.codeTextField.text]) {
        [self requestSetPassword];
    }else
    {
        [self.view kk_makeToast:@"至少6位,必须包含大小写字母、数字和特殊字符"];
    }
   
}
-(void)clickProtocolButton
{
    NSMutableArray * temArr = [NSMutableArray array];
    [self.protocolArr enumerateObjectsUsingBlock:^(ProtocolModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KKAlertAction *action = [KKAlertAction action].title(obj.protocolName).handler(^ (UIAlertAction * x){
            [KKRouter pushUri:obj.protocolHref];
        });
        [temArr addObject:action];
    }];
    [temArr addObject:[KKAlertAction cancelAction]];
    [KKAlertActionView alert].style(UIAlertControllerStyleActionSheet).addActions(temArr).show(self);
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

-(BOOL)passwordValided:(NSString *)pwd
{
    NSString *regex = @"^.*(?=.{6,16})(?=.*\\d)(?=.*[A-Z]+)(?=.*[a-z]+).*$";
    NSPredicate *pwdregex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pwdregex evaluateWithObject:pwd];
}

-(void)requestSetPassword
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(self.isReset ? @"user/reset/setPassword": @"user/register").paramaters(@{@"phoneNumber":self.phone,@"password":self.codeTextField.text.kkMd5}).view(self.view).needCustomFormat(YES).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            if (!self.isReset) {
                NSDictionary * dic = @{@"userId":result.data[@"uid"] ? result.data[@"uid"] : @"",
                                       @"md_access_token": result.data[@"token"] ?result.data[@"token"] :@"",
                                       @"mobile":self.phone,
                                       };
                [UserManager saveUserInfo:dic];
                [self.tcs trySetResult:@(YES)];
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)requestProtocol
{
    @weakify(self);
    [[KKRequest jsonRequest].paramaters(nil).urlString(@"").needCustomFormat(YES).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            self.protocolArr = [result arrWithClass:@"ProtocolModel"];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}

@end
