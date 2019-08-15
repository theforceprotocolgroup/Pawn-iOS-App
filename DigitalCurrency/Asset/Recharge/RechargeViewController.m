//
//  RechargeViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeHeaderView.h"
#import "RechargeAddressView.h"
#import "RechargeModel.h"
#import "TokenModel.h"
@interface RechargeViewController ()
//
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;
//
@property (nonatomic, strong) RechargeHeaderView * headerView;
//
@property (nonatomic, strong) RechargeAddressView * addressView;
//
@property (nonatomic, strong) UIButton * actionBtn;
//
@property (nonatomic, strong) RechargeModel * model;
//
@property (nonatomic, strong) TokenModel * tokenModel;
@end

@implementation RechargeViewController

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
    // Do any additional setup after loading the view.
    [self addViews];
    [self requestData];
//    [self test];
    self.title = @"充值";
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
    [self.view addSubview:self.addressView];
    [self.view addSubview:self.actionBtn];
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
    [_addressView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.headerView.mas_bottom).offset(12);
        make.left.right.equalTo(self.view);
    }];
    [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.addressView.mas_bottom).offset(32);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(RechargeHeaderView *)headerView
{
    if (!_headerView) {
        @weakify(self);
        _headerView = [RechargeHeaderView viewWithModel:nil action:^(id  _Nullable x) {
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

-(RechargeAddressView *)addressView
{
    if (!_addressView) {
        _addressView = [RechargeAddressView viewWithModel:nil action:^(id  _Nullable x) {
            
        }];
    }
    return _addressView;
}
-(UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc]init];
        _actionBtn.kkButtonType = KKButtonTypePriSolid;
        [_actionBtn setTitle:@"复制地址" forState:UIControlStateNormal];
        _actionBtn.titleLabel.font = KKCNFont(15);
        [_actionBtn addTarget:self action:@selector(clickActionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
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
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.tokenAddress;
    [self.view kk_makeToast:@"复制成功"];
}



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
    NSDictionary * dic;
    if (self.tokenModel) {
        dic = @{@"tokenID":self.tokenModel.tokenID};
    }
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code==1000) {
            self.model = [RechargeModel modelWithJSON:result.data];
            [self reloadData];
        }else
        {
            
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}

-(void)reloadData
{
    [self.headerView viewAction](self.model);
    [self.addressView viewAction](self.model.tokenAddress);
}

-(void)test{
    self.model = [RechargeModel modelWithJSON:@{
                                                @"tokenID": @"EOS1765",
                                                @"tokenSymbol": @"EOS",
                                                @"tokenName": @"EOS",
                                                @"iconURI": @"/EOS/0xc5gf.png",
                                                @"tokenBalance": @"100.00",
                                                @"tokenAddress": @"www.baidu.com"
                                                }];
    [self reloadData];
}
@end
