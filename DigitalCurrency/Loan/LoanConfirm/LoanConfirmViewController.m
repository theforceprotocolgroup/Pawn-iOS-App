//
//  LoanConfirmViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/10.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanConfirmViewController.h"
#import "LoanInfoView.h"
#import "LoanPayView.h"
#import "LoanBottomView.h"
#import "LoanIdentifyView.h"
#import "LoanConfirmModel.h"
#import "RechargePopView.h"
#import "ProtocolModel.h"
#import "ResultPopView.h"
@interface LoanConfirmViewController ()
//
@property (nonatomic, strong) LoanPayView * payView;
//
@property (nonatomic, strong) LoanInfoView * infoView;
//
@property (nonatomic, strong) LoanBottomView * bottomView;
//
@property (nonatomic, strong) LoanIdentifyView * identifyView;
//
@property (nonatomic, strong) LoanConfirmModel * model;
//
@property (nonatomic, strong) NSString * orderID;

@property (nonatomic, strong) PopValidCode * validCode;
//
@property (nonatomic, strong) NSString * code;
////
//@property (nonatomic, strong) NSArray * protocolArr;
////
//@property (nonatomic, strong) UILabel * protocolLabel;
////
//@property (nonatomic, strong) UIButton * protocolBtn;
////
//@property (nonatomic, strong) UIView * protocolView;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation LoanConfirmViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(RACTuple *)tuple {
    self.orderID = tuple.first;
//    self.protocolArr = tuple.second;
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
    self.kkBarColor = [UIColor whiteColor];
    self.kkLeftBarItemHidden= NO;
    self.view.backgroundColor = KKHexColor(f5f6f7);
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;//默认是UIRectEdgeAll
    self.title = @"出借支付";
    // Do any additional setup after loading the view.
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
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.payView];
    [self.view addSubview:self.identifyView];
    [self.view addSubview:self.bottomView];
//    [self.view addSubview:self.protocolView];
//    [self.protocolView addSubview:self.protocolLabel];
//    [self.protocolView addSubview:self.protocolBtn];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_infoView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(103);
    }];
    [_payView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.infoView.mas_bottom);
        make.height.mas_equalTo(218);
    }];
    [_identifyView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.payView.mas_bottom).offset(10);
        make.height.mas_equalTo(51);
    }];
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(63);
    }];
//    [_protocolView mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.bottom.equalTo(self.bottomView.mas_top).offset(-5);
//        make.centerX.equalTo(self.view);
//    }];
//    [_protocolLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.centerY.equalTo(self.protocolView);
//        make.left.equalTo(self.protocolView);
//        make.top.bottom.equalTo(self.protocolView);
//    }];
//    [_protocolBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.centerY.equalTo(self.protocolView);
//        make.left.equalTo(self.protocolLabel.mas_right).offset(5);
//        make.right.equalTo(self.protocolView.mas_right);
//    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(LoanInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [LoanInfoView viewWithModel:nil action:^(id  _Nullable x) {
            
        }];
    }
    return _infoView;
}
-(LoanPayView *)payView
{
    if (!_payView) {
        _payView = [LoanPayView viewWithModel:nil action:^(RACTuple *  _Nullable x) {
            if ([x.first isEqualToString:@"request"]||[x.second isEqualToString:@"recharge"]) {
//                [self requestRecharged];
                [[RechargePopView showWithSurperView:self.navigationController.view withModel:RACTuplePack(self.model.walletInfo.tokenType,self.model.walletInfo.tokenAddress) withAction:^(RACTuple*  _Nullable x) {
                    if ([x.first isEqualToString:@"0"]) {
                        [self.view kk_makeToast:@"复制成功"];
                    }
                }]show];
            }
        }];
    }
    return _payView;
}
-(LoanIdentifyView *)identifyView
{
    if (!_identifyView) {
        _identifyView = [LoanIdentifyView viewWithModel:nil action:^(RACTuple *  _Nullable x) {
            if ([x.first isEqualToString:@"push"]) {
                @weakify(self);
                [[KKRouter pushUri:x.second]continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                    @strongify(self);
                    [self requestData];
                    return nil;
                }];
            }
        }];
    }
    return _identifyView;
}
-(LoanBottomView *)bottomView
{
    if (!_bottomView) {
        @weakify(self);
        _bottomView = [LoanBottomView viewWithModel:nil action:^(id  _Nullable x) {
            @strongify(self);
            if (self.model.userIdentified.integerValue == 0) {
                [self.view kk_makeToast:@"请上传个人信息后再进行出借"];
                return;
            }
            [self requestConfirm];
        }];
    }
    return _bottomView;
}
//-(UIView *)protocolView
//{
//    if (!_protocolView) {
//        _protocolView = [[UIView alloc]init];
//        _protocolView.userInteractionEnabled = YES;
//        _protocolView.backgroundColor = [UIColor clearColor];
//    }
//    return _protocolView;
//}
//-(UILabel *)protocolLabel
//{
//    if (!_protocolLabel) {
//        _protocolLabel = [[UILabel alloc]init];
//        _protocolLabel.font = KKCNFont(11);
//        _protocolLabel.textColor = KKHexColor(C7CED9);
//        _protocolLabel.text = @"点击确认支付即表示已阅读并同意";
//    }
//    return _protocolLabel;
//}
//-(UIButton *)protocolBtn
//{
//    if (!_protocolBtn) {
//        _protocolBtn = [[UIButton alloc]init];
//        [_protocolBtn setTitle:@"《出借协议》" forState:UIControlStateNormal];
//        [_protocolBtn setTitleColor:KKHexColor(5170EB) forState:UIControlStateNormal];
//        _protocolBtn.titleLabel.font = KKCNFont(11);
//        [_protocolBtn kkExtendHitTestSizeByWidth:100 height:100];
//        [_protocolBtn addTarget:self action:@selector(clickProtocolButton) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _protocolBtn;
//}
#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
//-(void)clickProtocolButton
//{
//    NSMutableArray * temArr = [NSMutableArray array];
//    [self.protocolArr enumerateObjectsUsingBlock:^(ProtocolModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        KKAlertAction *action = [KKAlertAction action].title(obj.protocolName).handler(^ (UIAlertAction* x){
//            [KKRouter pushUri:obj.protocolHref];
//        });
//        [temArr addObject:action];
//    }];
//    [temArr addObject:[KKAlertAction cancelAction]];
//    [KKAlertActionView alert].style(UIAlertControllerStyleActionSheet).addActions(temArr).show(self);
//}




#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================




#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================
-(void)requestData
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(@{@"orderID":self.orderID}).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            self.model = [LoanConfirmModel modelWithJSON:result.data];
            [self reloadData];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)test{
    self.model = [LoanConfirmModel modelWithJSON:@{
        @"userIdentified": @"1",
        @"orderInfo": @{
            @"borrowCount": @"26.07",
            @"borrowType": @"BTC",
            @"iconUrl": @"/btc/sd2w4.ico",
            @"interval": @"7",
            @"dailyRate": @"1",
            @"expected": @"3.2541"
        },
        @"paymentInfo":@ {
            @"tokenType": @"BTC",
            @"iconUrl": @"BTC",
            @"paymentCount": @"3.2541",
            @"tokenBalance": @"35.55",
            @"tips": @"出借后30天内资金无法提现"
        }
    }
                  ];
    [self reloadData];
}
-(void)reloadData
{
    [_infoView viewAction](self.model.orderInfo);
    [_payView viewAction](self.model);
    [_identifyView viewAction](self.model.userIdentified);
    [_bottomView viewAction](@(YES));
}

-(void)requestConfirm
{
    @weakify(self);
    NSDictionary * dic = @{
                           @"orderID":self.orderID,
                           };
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            if (!self.validCode) {
                self.validCode = [PopValidCode showWithTitle:@"确认出借" superView:nil action:^(RACTuple*  _Nullable x) {
                    if ([x.first isEqualToString:@"code"]) {
                        [self requestConfirm];
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
        }else if (result.code == 1601)
        {
            ResultPopView * popView = [ResultPopView showWithSurperView:self.tabBarController.view withAction:^(RACTuple *  _Nullable x) {
                if ([x.first isEqualToString:@"0"]) {
                    [[RechargePopView showWithSurperView:self.navigationController.view withModel:RACTuplePack(self.model.walletInfo.tokenType,self.model.walletInfo.tokenAddress) withAction:^(RACTuple*  _Nullable x) {
                        if ([x.first isEqualToString:@"0"]) {
                            [self.view kk_makeToast:@"复制成功"];
                        }
                    }]show];
                }
            }];
            popView.type = ResultTypeNoEnough;
            popView.status = @"余额不足";
            popView.content = result.data[@"tokenBalanceInfo"];
            popView.btnArr = @[@"重新申请",@"去充值"];
            [popView show];
        }
        else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)requestCheckCode
{
    NSDictionary * dic;
    dic = @{@"orderID":self.orderID,@"code":self.code};
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            [self.validCode dismiss];
            [KKRouter pushUri:@"LoanSuccessViewController" params:result.data];
        }
        else
        {
            [self.validCode showErrorMessage:result.message];
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)requestRecharged
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(@{@"tokenID":self.model.paymentInfo.tokenType}).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            [[RechargePopView showWithSurperView:self.navigationController.view withModel:RACTuplePack(result.data[@"symbol"],result.data[@"address"]) withAction:^(id  _Nullable x) {
                
            }]show];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
@end
