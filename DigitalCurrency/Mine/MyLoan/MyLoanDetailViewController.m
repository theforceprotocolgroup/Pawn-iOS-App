//
//  MyLoanDetailViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/6.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyLoanDetailViewController.h"
#import "MyLoanDetailView.h"
#import "MyLoanDetailModel.h"
@interface MyLoanDetailViewController ()

//
@property (nonatomic, strong) MyLoanDetailView * detailView;
//
@property (nonatomic, strong) MyLoanDetailModel * model;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation MyLoanDetailViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(id)tuple {
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
    self.kkLeftBarItemHidden= NO;
    self.kkBarColor= [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = KKHexColor(F5F6F7);
    self.title = @"出借订单详情";
    [self addViews];
    [self requestData];
//    [self test];
    // Do any additional setup after loading the view.
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
    [self.view addSubview:self.detailView];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_detailView mas_updateConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.top.left.right.equalTo(self.view);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(MyLoanDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [MyLoanDetailView viewWithModel:nil action:^(id  _Nullable x) {
            
        }];
    }
    return _detailView;
}


#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================




#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================




#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================

-(void)test{
    MyLoanDetailModel * model = [MyLoanDetailModel modelWithJSON:@{
        @"orderID":@"LOAN3255974",//出借单号
        @"status":@"2", //1:持有中2:已回款,
        @"investedDate":@"2018-11-11 09:00:00",//出借时间
        @"repaymentDate":@"2018-11-18 08:00:00", //回款时间
        @"investedCount":@"100.00000000",//出借金额
        @"investedCoinType":@"BTC", //出借金额单位
        @"daliyRate":@"0.1",//日利率
        @"finalCount":@"100.03000000", //回款金额
        @"interestCount":@"0.03000000",//收益金额
    }];
    [self.detailView viewAction](RACTuplePack(model));
}
-(void)requestData
{
    NSDictionary * dic;
    dic = @{@"orderID":self.orderID};
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            self.model = [MyLoanDetailModel modelWithJSON:result.data];
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
    [self.detailView viewAction](RACTuplePack(_model));
}


@end
