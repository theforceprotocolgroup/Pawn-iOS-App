//
//  ChangedPhoneViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/8.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "ChangedPhoneViewController.h"
#import <MZTimerLabel/MZTimerLabel.h>

@interface ChangedPhoneViewController ()
//
@property (nonatomic, strong) UIView * contentView;
//
@property (nonatomic, strong) UILabel * acountTitle;
//
@property (nonatomic, strong) UITextField * acountTextField;
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UILabel * codeLebal;
//
@property (nonatomic, strong) UITextField * codeTextField;
//
@property (nonatomic, strong) MZTimerLabel * countLabel;
//
@property (nonatomic, strong) UIButton * nextBtn;

//
@property (nonatomic, assign) BOOL phoneInput;
//
@property (nonatomic, assign) BOOL codeInput;
//
@property (nonatomic, strong) NSString * Md5Code;

#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation ChangedPhoneViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(NSNumber*)tuple {
    self.isNewBind = tuple.boolValue;
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
    self.kkBarColor = [UIColor whiteColor];
    self.kkLeftBarItemHidden= NO;
    self.view.backgroundColor = KKHexColor(F5F6F7);
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;//默认是UIRectEdgeAll
    // Do any additional setup after loading the view.
    self.title = @"验证账号";
    [self addViews];
    if (!_isNewBind) {
        self.acountTextField.text = [UserManager manager].username;
        self.acountTextField.enabled = YES;
        self.phoneInput = YES;
        self.countLabel.textColor  = KKHexColor(5170EB);
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - View
///=============================================================================
/// @name addViews
///=============================================================================
- (void)addViews {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.acountTitle];
    [self.contentView addSubview:self.acountTextField];
    [self.contentView addSubview:self.hline];
    [self.contentView addSubview:self.codeLebal];
    [self.contentView addSubview:self.codeTextField];
    [self.contentView addSubview:self.countLabel];
    [self.view addSubview:self.nextBtn];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    [_acountTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView).multipliedBy(0.5);
        make.left.equalTo(self.contentView).offset(15);
    }];
    [_acountTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.acountTitle);
        make.left.equalTo(self.acountTitle.mas_right).offset(16).priorityHigh();
    }];
    [self.codeLebal setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_codeLebal mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView).multipliedBy(1.5);
        make.left.equalTo(self.contentView).offset(15);
    }];
    [_codeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.codeLebal);
        make.left.equalTo(self.codeLebal.mas_right).offset(16);
        make.right.equalTo(self.countLabel.mas_left);
    }];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.codeLebal);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@(80));
    }];
    [_nextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.mas_bottom).offset(32);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@(44));
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
-(UILabel *)acountTitle
{
    if (!_acountTitle) {
        _acountTitle = [[UILabel alloc]init];
        _acountTitle.text = @"账号";
        _acountTitle.textColor = KKHexColor(041E45);
        _acountTitle.font = KKCNFont(15);
    }
    return _acountTitle;
}
-(UILabel *)codeLebal
{
    if (!_codeLebal) {
        _codeLebal = [[UILabel alloc]init];
        _codeLebal.text = @"验证码";
        _codeLebal.textColor = KKHexColor(041E45);
        _codeLebal.font = KKCNFont(15);
    }
    return _codeLebal;
}
-(UITextField *)acountTextField
{
    if (!_acountTextField) {
        _acountTextField = [[UITextField alloc]init];
        _acountTextField.font = KKCNFont(15);
        _acountTextField.textColor = KKHexColor(465062);
        NSMutableAttributedString * att = KKMultiAttriString(@"请输入手机号").kkFont(KKCNFont(15)).kkColor(KKHexColor(C7CED9));
        _acountTextField.attributedPlaceholder = att;
        @weakify(self);
        [_acountTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.phoneInput = x.length >= 11 ? YES:NO;
            self.countLabel.textColor = self.phoneInput ? KKHexColor(5170EB) : KKHexColor(A6A6AB);
            self.nextBtn.enabled = self.phoneInput && self.codeInput;
            
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
        NSMutableAttributedString * att = KKMultiAttriString(@"请输入验证码").kkFont(KKCNFont(15)).kkColor(KKHexColor(C7CED9));
        _codeTextField.attributedPlaceholder = att;
        @weakify(self);
        [_codeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.codeInput = x.length>0 ? YES:NO;
            self.nextBtn.enabled = self.phoneInput && self.codeInput;
        }];
    }
    return _codeTextField;
}
-(MZTimerLabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[MZTimerLabel alloc]init];
        _countLabel.timerType = MZTimerLabelTypeTimer;
        _countLabel.font = KKCNFont(14);
        _countLabel.textColor = KKHexColor(A6A6AB);
        _countLabel.text = @"发送验证码";
        _countLabel.textAlignment = NSTextAlignmentCenter;
        @weakify(self);
        [_countLabel setEndedBlock:^(NSTimeInterval x) {
            @strongify(self);
            [self.countLabel reset];
            self.countLabel.textColor = KKHexColor(5170EB);
            self.countLabel.text = @"重发";
        }];
        [_countLabel kkAddTapAction:^(id  _Nullable x) {
            @strongify(self);
            if (self.phoneInput && !self.countLabel.counting) {
                [self.view endEditing:YES];
                //发送验证码
                [self reuqestCode];
            }
        }];
        
    }
    return _countLabel;
}
-(UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        _nextBtn.kkButtonType = KKButtonTypePriSolid;
        NSString * str = self.isNewBind ? @"确认更换" : @"下一步";
        [_nextBtn setTitle:str forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = KKCNFont(15);
        [_nextBtn addTarget:self action:@selector(clickActionButton) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.enabled = NO;
    }
    return _nextBtn;
}
#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickActionButton
{
    [self requestCheckCode];
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
    NSDictionary * dic;
    if (self.isNewBind) {
        dic = @{@"newPhoneNumber":self.acountTextField.text};
    }else
    {
        dic = @{@"phoneNumber":self.acountTextField.text};
    }
    [[KKRequest jsonRequest].urlString(self.isNewBind ? @"user/getCodeForNewPhone" : @"user/getChangePhoneNumberCode").paramaters(dic).view(self.view).needCustomFormat(YES).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            self.countLabel.timeFormat = @"重发(ss's')";
            self.countLabel.textColor = KKHexColor(A6A6AB);
            [self.countLabel setCountDownTime:60];
            [self.countLabel start];
            self.Md5Code = result.data[@"encryptedCode"];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}

-(void)requestCheckCode
{
    NSDictionary * dic;
    if (self.isNewBind) {
        dic = @{@"newPhoneNumber":self.acountTextField.text,@"code":self.codeTextField.text};
    }else
    {
        dic = @{@"phoneNumber":self.acountTextField.text,@"code":self.codeTextField.text};
    }
    @weakify(self);
    [[KKRequest jsonRequest].urlString(self.isNewBind ? @"user/confirmChangePhone" : @"user/nextChangePhone").paramaters(dic).view(self.view).needCustomFormat(YES).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            if (self.isNewBind) {
                [UserManager clearLoginInfo];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else
            {
                [KKRouter pushUri:@"ChangedPhoneViewController" params:@(YES)];
            }
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}




@end
