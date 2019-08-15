//
//  WithdrawViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "WithdrawViewController.h"
#import "WithdrawVHeaderView.h"
#import "WithdrawContentView.h"
#import "WithdrawModel.h"
#import "TokenModel.h"
#import "PopValidCode.h"
#import "ResultPopView.h"
@interface WithdrawViewController ()

//
@property (nonatomic, strong) WithdrawContentView * contentView;
//
@property (nonatomic, strong) WithdrawVHeaderView * headerView;
//
@property (nonatomic, strong) UIButton * actionBtn;
//
@property (nonatomic, strong) UILabel * tipsLabel;
//
@property (nonatomic, strong) UILabel * noteLabel;
//
@property (nonatomic, strong) WithdrawModel * model;
//
@property (nonatomic, strong) TokenModel * tokenModel;
//
@property (nonatomic, assign) BOOL addInput;
//
@property (nonatomic, assign) BOOL  countInput;

//
@property (nonatomic, strong) PopValidCode * validCode;
//
@property (nonatomic, strong) NSString * count;
//
@property (nonatomic, strong) NSString * code;
//
@property (nonatomic, strong) NSString * address;
//
@property (nonatomic, strong) NSString * withdrawOrderID;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation WithdrawViewController

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
    self.kkHairlineHidden = NO;
    self.kkBarColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor = KKHexColor(F5F6F7);
    [self autoDismissKeyboard];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    _count = @"";
    _address = @"";
    [self addViews];
    [self requestData];

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
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.actionBtn];
    [self.view addSubview:self.noteLabel];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.headerView.mas_bottom).offset(12);
        make.left.right.equalTo(self.view);
    }];
    [_tipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.centerX.equalTo(self.view);
    }];
    [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(32);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    [_noteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.actionBtn.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(WithdrawVHeaderView *)headerView
{
    if (!_headerView) {
        @weakify(self);
        _headerView = [WithdrawVHeaderView viewWithModel:nil action:^(id  _Nullable x) {
            [[KKRouter pushUri:@"TokenListViewController" params:RACTuplePack(@(2),self.model.tokenID)  navi:self.navigationController] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                @strongify(self);
                self.tokenModel = t.result;
                [self requestData];
                return nil;
            }];
        }];
    }
    return _headerView;
}
-(WithdrawContentView *)contentView
{
    if (!_contentView) {
        @weakify(self);
        _contentView = [WithdrawContentView viewWithModel:nil action:^(RACTuple*  _Nullable x) {
            @strongify(self);
            if ([x.first isEqualToString:@"scan"]) {
                [[KKRouter pushUri:@"ScanViewController" params:nil navi:self.navigationController] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                    @strongify(self);
                    self.address = t.result;
                    [self.contentView viewAction](RACTuplePack(self.model,self.address) );
                    self.addInput = YES;
                    self.actionBtn.enabled = self.addInput && self.countInput;
                    return nil;
                }];
            }else if ([x.first isEqualToString:@"address"])
            {
                self.address = x.second;
                self.addInput = [x.second length] > 0;
                self.actionBtn.enabled = self.addInput && self.countInput;
            }else if ([x.first isEqualToString:@"count"])
            {
                self.countInput = [x.second length] > 0;
                self.actionBtn.enabled = self.addInput && self.countInput;
                self.count = x.second;
                [self requestData];
            }else if ([x.first isEqualToString:@"request"])
            {
                //request
                [self requestData];
            }
        }];
    }
    return _contentView;
}
-(UILabel *)noteLabel
{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc]init];
        _noteLabel.text = @"提现前务必确认地址及币种信息无误，一旦转出，无法撤回";
        _noteLabel.textColor = KKHexColor(C7CED9);
        _noteLabel.font = KKCNFont(11);
        _noteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noteLabel;
}
-(UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc]init];
        _actionBtn.kkButtonType = KKButtonTypePriSolid;
        [_actionBtn setTitle:@"确认提现" forState:UIControlStateNormal];
        _actionBtn.titleLabel.font = KKCNFont(15);
        _actionBtn.enabled = NO;
        [_actionBtn addTarget:self action:@selector(clickActionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}
-(UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.textColor = KKHexColor(9197A7);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = KKCNFont(11);
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
    }
    return _tipsLabel;
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
    [self reuqestConfirm];
}


#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================




#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================

-(void)test{
    self.model = [WithdrawModel modelWithJSON:@{
                                                @"tokenID": @"BTC0001",
                                                @"tokenSymbol": @"BTC",
                                                @"tokenName": @"Bitcoin",
                                                @"iconURI": @"/BTC/0xc5gf.png",
                                                @"fee": @"0.1",
                                                @"maxAvailableWithdrawCount": @"20.50",
                                                @"maxWithdrawCount": @"50000.00000123",
                                                @"minWithdrawCount": @"0",
                                                @"quoteType": @"USD",
                                                @"quotesCount": @"100.22"
                                                }
                  ];
    [self reloadData];
}
-(void)reloadData
{
    [self.headerView viewAction](self.model);
    [self.contentView viewAction](RACTuplePack(self.model,self.address));
    self.tipsLabel.text = [NSString stringWithFormat:@"提示:站内最小提现金额%@%@,每笔提现收取手续费%@%@",self.model.minWithdrawCount,self.model.tokenSymbol,self.model.fee,self.model.tokenSymbol];
}

-(void)requestData
{
    NSDictionary * dic;
    NSString * tokenID;
    if (self.tokenModel) {
        tokenID = self.tokenModel.tokenID;
    }else
    {
        if (self.model) {
            tokenID = self.model.tokenID;
        }else
        {
            tokenID = @"";
        }
    }
    dic = @{@"tokenID":tokenID, @"inputCount":_count};
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            self.model = [WithdrawModel modelWithJSON:result.data];
            [self reloadData];
        }else
        {
            
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)reuqestConfirm
{
    NSDictionary * dic;
    
    NSString * tokenID;
    if (self.tokenModel) {
        tokenID = self.tokenModel.tokenID;
    }else
    {
        if (self.model) {
            tokenID = self.model.tokenID;
        }else
        {
            tokenID = @"";
        }
    }
    dic = @{@"tokenID":tokenID , @"withdrawAddress":self.address ,@"withdrawCount":_count};
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            self.withdrawOrderID = result.data[@"withdrawOrderID"];
            if (!self.validCode) {
                self.validCode = [PopValidCode showWithTitle:@"确认提现" superView:nil action:^(RACTuple*  _Nullable x) {
                    if ([x.first isEqualToString:@"code"]) {
                        [self reuqestConfirm];
                    }else if([x.first isEqualToString:@"check"])
                    {
                        self.code = x.second;
                        [self requestCheckCode];
                    }
                }];
                [self.validCode show];
            }else
            {
                [self.validCode startTimer];
            }
           
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
    NSString * tokenID;
    if (self.tokenModel) {
        tokenID = self.tokenModel.tokenID;
    }else
    {
        if (self.model) {
            tokenID = self.model.tokenID;
        }else
        {
            tokenID = @"";
        }
    }
    dic = @{@"tokenID":tokenID,@"code":self.code,@"withdrawOrderID":self.withdrawOrderID,@"withdrawAddress":self.address ,@"withdrawCount":_count};
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            [self.validCode dismiss];
            [KKRouter pushUri:@"WithdrawSuccessViewController" params:RACTuplePack(self.count, self.model.tokenSymbol , self.address)];
            //提现失败
        }else if (result.code ==1705)
        {
            [self.validCode dismiss];
            ResultPopView * pop = [ResultPopView showWithSurperView:self.tabBarController.view withAction:^(id  _Nullable x) {
                
            }];
            pop.type = ResultTypeWithDraw;
            pop.btnArr = @[@"重新提现"];
            pop.status = result.data[@"description"];
            pop.content = result.data[@"tokenBalanceInfo"];
            [pop show];
        }else
        {
            [self.validCode showErrorMessage:result.message];
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
@end
