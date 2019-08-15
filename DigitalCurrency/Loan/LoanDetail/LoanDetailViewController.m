//
//  LoanDetailViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/2.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanDetailViewController.h"
#import "LoanDetailInfoView.h"
#import "LoanDetailIntervalView.h"
#import "LoanDetailIntroductionView.h"
#import "LoanDetailBottomView.h"
#import "LoanDetailInfoModel.h"
#import "ProtocolModel.h"
@interface LoanDetailViewController ()
//
@property (nonatomic, strong) LoanDetailInfoView * infoView;
//
@property (nonatomic, strong) LoanDetailIntervalView * intervalView;
//
@property (nonatomic, strong) LoanDetailIntroductionView * introductionView;
//
@property (nonatomic, strong) LoanDetailBottomView * bottomView;
//
@property (nonatomic, strong) LoanDetailInfoModel * model;
//
@property (nonatomic, strong) NSArray * protocolArr;
//
@property (nonatomic, strong) UILabel * protocolLabel;
//
@property (nonatomic, strong) UIButton * protocolBtn;
//
@property (nonatomic, strong) UIView * protocolView;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation LoanDetailViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(NSString*)tuple {
    self.orderID = tuple;
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
    self.kkLeftBarItemColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;//默认是UIRectEdgeAll
    self.view.backgroundColor = KKHexColor(ffffff);
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
    [self.view addSubview:self.introductionView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.intervalView];
    [self.view addSubview:self.protocolView];
    [self.protocolView addSubview:self.protocolLabel];
    [self.protocolView addSubview:self.protocolBtn];
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
        make.height.mas_equalTo(iPhone5 ? (273+Height_StatusBar)*SCREEN_WIDTH/375 - 20: (273+Height_StatusBar)*SCREEN_WIDTH/375);
    }];
    [_introductionView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.infoView.mas_bottom);
        make.right.left.equalTo(self.view);
    }];
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.bottom.right.left.equalTo(self.view);
        make.height.mas_equalTo(63);
        make.top.equalTo(self.introductionView.mas_bottom);
    }];
    [_intervalView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.infoView.mas_bottom).offset(-52);
        make.height.mas_equalTo(120);
    }];
    [_protocolView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-5);
        make.centerX.equalTo(self.view);
    }];
    [_protocolLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.protocolView);
        make.left.equalTo(self.protocolView);
        make.top.bottom.equalTo(self.protocolView);
    }];
    [_protocolBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.protocolView);
        make.left.equalTo(self.protocolLabel.mas_right).offset(5);
        make.right.equalTo(self.protocolView.mas_right);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(LoanDetailInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [LoanDetailInfoView viewWithModel:nil action:^(id  _Nullable x) {
        }];
    }
    return _infoView;
}
-(LoanDetailIntroductionView *)introductionView
{
    if (!_introductionView) {
        @weakify(self);
        _introductionView = [LoanDetailIntroductionView viewWithModel:nil action:^(RACTuple*  _Nullable x) {
            @strongify(self);
            [self tapAction:x];
        }];
    }
    return _introductionView;
}
-(LoanDetailBottomView *)bottomView
{
    if (!_bottomView) {
        @weakify(self);
        _bottomView = [LoanDetailBottomView viewWithModel:nil action:^(RACTuple*  _Nullable x) {
            @strongify(self);
            [self tapAction:x];
        }];
    }
    return _bottomView;
}
-(LoanDetailIntervalView *)intervalView
{
    if (!_intervalView) {
        _intervalView = [LoanDetailIntervalView viewWithModel:nil action:^(id  _Nullable x) {
            
        }];
    }
    return _intervalView;
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
        _protocolLabel.text = @"点击立即出借即表示已阅读并同意";
    }
    return _protocolLabel;
}
-(UIButton *)protocolBtn
{
    if (!_protocolBtn) {
        _protocolBtn = [[UIButton alloc]init];
        [_protocolBtn setTitle:@"《出借协议》" forState:UIControlStateNormal];
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




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)tapAction:(RACTuple*)x
{
    if ([x.first isEqualToString:@"push"]) {
        if (![UserManager manager].token.length) {
            [KKRouter pushUri:LoginVCString];
            return;
        }
        [KKRouter pushUri:@"LoanConfirmViewController" params: RACTuplePack(self.orderID) ];
    }
}
-(void)clickProtocolButton
{
    NSMutableArray * temArr = [NSMutableArray array];
    [self.model.borrowProtocol enumerateObjectsUsingBlock:^(ProtocolModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

-(void)reloadData
{
    [self.infoView viewAction](self.model.orderInfo);
    [self.introductionView viewAction](RACTuplePack(self.model.repayInfo,self.model.borrowProtocol));
    [self.intervalView viewAction](self.model.orderCycle);
}
-(void)requestData
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code == 1000) {
            self.model = [LoanDetailInfoModel modelWithJSON:result.data];
            [self reloadData];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)test
{
//    self.model = [LoanDetailInfoModel modelWithJSON:result.data];
//    self.intervalArr = [[NSMutableArray alloc]init];
//    self.introductionArr = [[NSMutableArray alloc]init];
//    self.protolArr = [[NSMutableArray alloc]init];
//    self.orderInfoModel = [LoanInfoOrderInfoModel modelWithJSON:@{
//        @"borrowCount":@"199.25140000",
//        @"borrowType":@"EOS",
//        @"iconUrl":@"/icon/Eos1546.icon",
//        @"interval":@"30",
//        @"daliyRate":@"0.1",
//        @"expected":@"0.30000000"
//    }];
//    NSArray * temp1 = @[
//                         @{
//                             @"title":@"起购日",
//                             @"content":@"11.03"
//                         },
//                         @{
//                             @"title":@"起息日",
//                             @"content":@"11.04"
//                         },
//                         @{
//                             @"title":@"起购日",
//                             @"content":@"11.05"
//                         },
//                         @{
//                             @"title":@"起购日",
//                             @"content":@"11.06"
//                         },
//                         ];
//    NSArray* temp2 = @[
//                            @{
//                                @"title":@"还款数额",
//                                @"content":@"3000.00000000"
//                            },
//                            @{
//                                @"title":@"利息于服务费",
//                                @"content":@"0.10000000"
//                            },
//                            @{
//                                @"title":@"折合人民币",
//                                @"content":@"300.000"
//                            },
//                            @{
//                                @"title":@"回款时间",
//                                @"content":@"T+1日到账"
//                            }
//                            ];
//    NSArray * temp3 = @[
//                      @{
//                          @"protocolID": @"protocol001",
//                          @"protocolType": @"1",
//                          @"protocolName": @"借贷协议",
//                          @"protocolUrl": @"/borrow/0xosw"
//                      }
//                      ];
//
//    [temp1 enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        LoanDetailInfoViewModel * model = [LoanDetailInfoViewModel modelWithJSON:obj];
//        [self.intervalArr addObject:model];
//    }];
//    [temp2 enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        LoanDetailInfoViewModel * model = [LoanDetailInfoViewModel modelWithJSON:obj];
//        [self.introductionArr addObject:model];
//    }];
//    [temp3 enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        ProtocolModel * model = [ProtocolModel modelWithJSON:obj];
//        [self.protolArr addObject:model];
//    }];
}


@end
