//
//  RegistViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/15.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "RegistViewController.h"
#import <MZTimerLabel/MZTimerLabel.h>
#import "ProtocolModel.h"

@interface RegistViewController ()<UITextFieldDelegate>
//
@property (nonatomic, strong) UIControl * acountControl;
//
@property (nonatomic, strong) UIControl * codeControl;
//
@property (nonatomic, strong) UILabel * titleLabel;
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
@property (nonatomic, strong) MZTimerLabel * timerLabel;
//
@property (nonatomic, strong) UIButton * actionBtn;
//
@property (nonatomic, strong) UILabel * protocolLabel;
//
@property (nonatomic, strong) UIButton * protocolBtn;
//
@property (nonatomic, strong) UIView * protocolView;
//
@property (nonatomic, strong) NSString * md5Code;
//
@property (nonatomic, strong) NSArray * protocolArr;
//
@property (nonatomic, assign) BOOL phoneInput;
//
@property (nonatomic, assign) BOOL codeInput;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation RegistViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(id)tuple {
    self.isReset = [(NSNumber *)tuple boolValue];
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
- (BOOL)navigationShouldPopOnBackButton {
    [self.view endEditing:YES];
    if (self.navigationController.viewControllers[0] == self) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    return YES;
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
    [self.codeView addSubview:self.timerLabel];
    
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
    [_acountView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(60);
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
        make.right.equalTo(self.codeClearBtn.mas_left);
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
        make.right.equalTo(self.timerLabel.mas_left);
        make.height.width.equalTo(@(25));
    }];
    [_timerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.codeTextField);
        make.right.equalTo(self.codeView);
        make.width.equalTo(@(80));
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
        make.top.bottom.equalTo(self.protocolView);
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
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNBFont(25);
        _titleLabel.textColor = KKHexColor(465062);
        _titleLabel.text = self.isReset ? @"验证账号" : @"注册";
    }
    return _titleLabel;
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
            self.phoneInput = x.length >= 11 ? YES:NO;
            self.timerLabel.textColor = self.phoneInput ? KKHexColor(5170EB) : KKHexColor(A6A6AB);
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
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableAttributedString * att = KKMultiAttriString(@"请输入验证码").kkFont(KKCNFont(15)).kkColor(KKHexColor(C7CED9));
        _codeTextField.attributedPlaceholder = att;
        @weakify(self);
        [_codeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.codeClearBtn.hidden = !x.length;
            self.codeInput = x.length>0 ? YES:NO;
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
-(MZTimerLabel *)timerLabel
{
    if (!_timerLabel) {
        _timerLabel = [[MZTimerLabel alloc]init];
        _timerLabel.timerType = MZTimerLabelTypeTimer;
        _timerLabel.font = KKCNFont(14);
        _timerLabel.textColor = KKHexColor(A6A6AB);
        _timerLabel.text = @"发送验证码";
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        @weakify(self);
        [_timerLabel setEndedBlock:^(NSTimeInterval x) {
            @strongify(self);
            [self.timerLabel reset];
            self.timerLabel.textColor = KKHexColor(5170EB);
            self.timerLabel.text = @"重发";
        }];
        [_timerLabel kkAddTapAction:^(id  _Nullable x) {
            @strongify(self);
            if (self.phoneInput && !self.timerLabel.counting) {
                [self.view endEditing:YES];
                //发送验证码
                [self reuqestCode];
            }
        }];
        
    }
    return _timerLabel;
}
-(UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc]init];
        _actionBtn.kkButtonType = KKButtonTypePriSolid;
        [_actionBtn setTitle:@"下一步" forState:UIControlStateNormal];
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
        _protocolView.userInteractionEnabled = YES;
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
        [_protocolBtn kkExtendHitTestSizeByWidth:100 height:100];
        [_protocolBtn addTarget:self action:@selector(clickProtocolButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolBtn;
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
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _acountTextField) {
        self.acountClearBtn.hidden = NO;
    }else
    {
        self.codeClearBtn.hidden = NO;
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
    self.codeInput = NO;
    self.actionBtn.enabled = NO;
}
-(void)clickActionButton
{
//    if ([self.md5Code isEqualToString:self.codeTextField.text.kkMd5]) {
        [self requestCheckCode];
//    }else
//    {
//        [self.view kk_makeToast:@"请输入正确的验证码"];
//    }
}
-(void)clickProtocolButton
{
    NSMutableArray * temArr = [NSMutableArray array];
    [self.protocolArr enumerateObjectsUsingBlock:^(ProtocolModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KKAlertAction *action = [KKAlertAction action].title(obj.protocolName).handler(^ (UIAlertAction* x){
            [KKRouter pushUri:obj.protocolHref];
        });
        [temArr addObject:action];
    }];
    [temArr addObject:[KKAlertAction cancelAction]];
    [KKAlertActionView alert].style(UIAlertControllerStyleActionSheet).addActions(temArr).show(self);
}


#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================




#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================

-(void)reuqestCode
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(self.isReset ? @"user/reset/getCode": @"user/getRegisterCode").paramaters(@{@"phoneNumber":self.acountTextField.text}).view(self.view).needCustomFormat(YES).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            self.md5Code = result.data[@"encryptedCode"];
            self.timerLabel.timeFormat = @"重发(ss's')";
            self.timerLabel.textColor = KKHexColor(A6A6AB);
            [self.timerLabel setCountDownTime:60];
            [self.timerLabel start];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];

}
-(void)requestCheckCode
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(self.isReset ? @"user/reset/validateCode":@"user/validateCode").paramaters(@{@"phoneNumber":self.acountTextField.text,@"code":self.codeTextField.text}).view(self.view).needCustomFormat(YES).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            [[KKRouter pushUri:@"SetPasswordViewController" params:RACTuplePack([NSNumber numberWithBool:self.isReset],self.acountTextField.text)]continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                [self.tcs trySetResult:@(YES)];
                return nil;
            }];
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
