//
//  BorrowConfirmViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/21.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowConfirmViewController.h"
#import "BorrowInfoView.h"
#import "BorrowLoanView.h"
#import "BorrowIdentifyView.h"
#import "BorrowIntroductionView.h"
#import "BorrowHomeRequestModel.h"
#import "TokenModel.h"
#import "PopListView.h"
#import "RechargePopView.h"
#import "BorrowBottomView.h"
#import "ResultPopView.h"
@interface BorrowConfirmViewController ()

#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;
//
@property (nonatomic, strong) UIScrollView * scrollView;
//
@property (nonatomic, strong) UIView * scrollContentView;
//
@property (nonatomic, strong) PopListView * popListView;
//
@property (nonatomic, strong) BorrowBottomView * bottomView;
//
@property (nonatomic, strong) NSMutableArray * contentViewArr;
//
@property (nonatomic, strong) NSArray * dataArr;

@property (nonatomic, strong) BorrowHomeRequestModel * requestModel;

//
@property (nonatomic, strong) TokenModel * borrowModel;
//
@property (nonatomic, strong) TokenModel * mrgeModel;

@property (nonatomic, strong) PopValidCode * validCode;
//
@property (nonatomic, strong) NSString * code;
//
@property (nonatomic, strong) NSString * orderID;
@end

@implementation BorrowConfirmViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(RACTuple *)tuple {
    RACTupleUnpack(BorrowHomeViewModel * homeModel,NSDictionary * dic,BorrowHomeRequestModel * request,TokenModel * borrowModel , TokenModel * mrgeModel) = tuple;
    self.homeModel = homeModel;
    self.infoModel = [BorrowInfoModel modelWithJSON:dic];
    self.requestModel = request;
    self.borrowModel = borrowModel;
    self.mrgeModel = mrgeModel;
    NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:self.homeModel.borrowCellArr];
    [arr exchangeObjectAtIndex:2 withObjectAtIndex:4];
    [arr removeObjectAtIndex:3];
    self.homeModel.borrowDetailCellArr = arr;
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
    self.view.backgroundColor = KKHexColor(ffffff);
    self.kkDistanceToLeftEdge = 0.01f;
    self.title = @"借币详情";
    _contentViewArr = [[NSMutableArray alloc]init];
    [self addViews];
    [self autoDismissKeyboard];
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;//默认是UIRectEdgeAll
    [self reloadData];
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
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.scrollView.contentSize.height < SCREEN_HEIGHT) {
        self.scrollView.contentSize = ({
            CGSize size = self.scrollView.contentSize;
            size.height = SCREEN_HEIGHT;
            size;
        });
    }
}
#pragma mark - View
///=============================================================================
/// @name addViews
///=============================================================================
- (void)addViews {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.bottomView];
    [self.scrollView addSubview:self.scrollContentView];
    [self addContainSubviews];
    [self updateLayout];
}

- (void)addContainSubviews {
    @weakify(self);

    [[self viewClasses]enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class cls = NSClassFromString(obj);
        if ([cls conformsToProtocol:@protocol(KKViewDelegate)]) {
            @strongify(self);
            UIView *view = [(id<KKViewDelegate>)cls viewWithModel:nil action:^(RACTuple *tuple) {
                @strongify(self);
                [self tapAction:tuple];
            }];
            if (view) {
                view.userInteractionEnabled = YES;
                [self.scrollContentView addSubview:view];
                [self.contentViewArr addObject:view];
            }
        }
    }];
}

- (NSArray<NSString *> *)viewClasses {
    return @[@"BorrowInfoView", @"BorrowLoanView", @"BorrowIdentifyView", @"BorrowIntroductionView"];
}

- (CGFloat)height:(NSInteger)index {
    NSArray *arr =@[@0, @267, @50, @50];
    return [arr[index] floatValue];
}
#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(63);
    }];
    [_scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.edges.equalTo(self.scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.contentViewArr kkEachWithPreAndIndex:^(UIView*  _Nonnull obj, UIView*  _Nonnull preObj, NSUInteger idx) {
        @weakify(self);
        [obj mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(preObj?preObj.mas_bottom:self.scrollContentView.mas_top).offset(15);
            make.left.equalTo(self.scrollContentView.mas_left).offset(15);
            make.right.equalTo(self.scrollContentView.mas_right).offset(-15);
            if ([self height:idx]) {
                make.height.equalTo(@([self height:idx]));
            }
            if (idx==(self.contentViewArr.count-1)) {
                make.bottom.equalTo(self.scrollContentView.mas_bottom);
                make.left.equalTo(self.scrollContentView.mas_left).offset(15);
                make.right.equalTo(self.scrollContentView.mas_right).offset(-15);
            }else
            {
                make.left.equalTo(self.scrollContentView.mas_left).offset(15);
                make.right.equalTo(self.scrollContentView.mas_right).offset(-15);
            }
        }];
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UIView *)scrollContentView
{
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc]init];
        _scrollContentView.backgroundColor = KKHexColor(F5F6F7);
        _scrollContentView.userInteractionEnabled = YES;
    }
    return _scrollContentView;
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = KKHexColor(F5F6F7);
    }
    return _scrollView;
}
-(BorrowBottomView *)bottomView
{
    if (!_bottomView) {
        @weakify(self);
        _bottomView = [BorrowBottomView viewWithModel:nil action:^(RACTuple*  _Nullable x) {
            @strongify(self);
            if ([x.second isEqualToString:@"submit"])
            {
                if (self.infoModel.userIdentified.integerValue == 0) {
                    [self.view kk_makeToast:@"请上传个人信息后再进行借币"];
                    return;
                }
                if (self.requestModel.count.doubleValue > self.borrowModel.maxAvaliableBorrowCount.doubleValue) {
                    [self.view kk_makeToast:@"借币数量超过最大可借额度"];
                    return;
                }
                if (self.requestModel.count.doubleValue < self.borrowModel.minAvaliableBorrowCount.doubleValue) {
                    [self.view kk_makeToast:@"借币数量不得小于最小可借额度"];
                    return;
                }
                [self requestSubmit];
            }
        }];
    }
    return _bottomView;
}
#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickSubmitButton
{
    
}
-(void)tapAction:(RACTuple *)tuple
{
    if ([tuple.first isEqualToString:@"push"]) {
        if ([tuple.third isEqualToString:@"borrow"]) {
            @weakify(self);
            [[KKRouter pushUri:@"TokenListViewController" params:RACTuplePack(@(0),self.requestModel.mrgeType)  navi:self.navigationController] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                @strongify(self);
                self.borrowModel = t.result;
                BorrowHomePageTableViewModel * viewmodel = self.homeModel.borrowDetailCellArr[0];
                viewmodel.content = self.borrowModel.symbol;
                self.requestModel.borrowType = self.borrowModel.tokenID;
                [self requestConfirm];
                return nil;
            }];
        }else if ([tuple.third isEqualToString:@"merge"])
        {
            @weakify(self);
            [[KKRouter pushUri:@"TokenListViewController" params:RACTuplePack(@(1),self.requestModel.borrowType)  navi:self.navigationController] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                @strongify(self);
                self.mrgeModel = t.result;
                self.requestModel.mrgeType = self.mrgeModel.tokenID;
                [self requestConfirm];
                return nil;
            }];
        }else if ([tuple.second isEqualToString:@"identity"])
        {
            [[KKRouter pushUri:@"IndentifyViewController"]continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                [self requestConfirm];
                return nil;
            }];
        }else
        {
            [KKRouter pushUri:tuple.second];
        }
    }else if ([tuple.first isEqualToString:@"tap"])
    {
        NSMutableArray * arr = [NSMutableArray array];
        [self.homeModel.intervalArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PopListViewModel * model = [[PopListViewModel alloc]init];
            model.title = obj[@"interval"];
            [arr addObject:model];
        }];
        if (!_popListView) {
            @weakify(self);
            _popListView = [PopListView showWithTitle:@"选择借币期限" content:arr superView:nil action:^(RACTuple *  _Nullable x) {
                @strongify(self);
                RACTupleUnpack(PopListViewModel * model , NSNumber * selectedIndex) = x;
                BorrowHomePageTableViewModel * viewmodel = self.homeModel.borrowDetailCellArr[2];
                viewmodel.content = [NSString stringWithFormat:@"%@天",model.title];
                self.requestModel.interval = self.homeModel.intervalArr[selectedIndex.integerValue][@"id"];
                [self requestConfirm];
            }];
        }
        [_popListView show];
    }else if ([tuple.first isEqualToString:@"input"])
    {
        self.requestModel.count = tuple.second;
        BorrowHomePageTableViewModel * viewmodel = self.homeModel.borrowDetailCellArr[1];
        viewmodel.content = tuple.second;
        [self requestConfirm];
    }else if ([tuple.first isEqualToString:@"slider"])
    {
        float num = [tuple.second floatValue];
        float max = [self.homeModel.rateArr.lastObject[@"rate"] doubleValue];
        float min = [self.homeModel.rateArr.firstObject[@"rate"] doubleValue];

        if (num >= max) {
            num = max;
        }
        if (num <= min) {
            num = min;
        }
        BorrowHomePageTableViewModel * viewmodel = self.homeModel.borrowDetailCellArr[3];
        viewmodel.content = [NSString stringWithFormat:@"%.2f%%",num];
        self.requestModel.rate = [NSString stringWithFormat:@"%.2f",num];
        [self requestConfirm];
    }else if ([tuple.first isEqualToString:@"request"])
    {
        if ([tuple.second isEqualToString:@"recharge"]) {
            [[RechargePopView showWithSurperView:self.navigationController.view withModel:RACTuplePack(self.infoModel.mrgeInfo.mrgeType,self.infoModel.mrgeInfo.address) withAction:^(RACTuple*  _Nullable x) {
                if ([x.first isEqualToString:@"0"]) {
                    [self.view kk_makeToast:@"复制成功"];
                }
            }]show];
        }
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


-(void)reloadData
{
    self.dataArr = @[RACTuplePack(self.homeModel,self.infoModel.repayinfo,self.infoModel.lendInfo),self.infoModel.mrgeInfo,self.infoModel.userIdentified,[NSNull null]];
    [_contentViewArr enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(id<KKViewDelegate>)obj viewAction](self.dataArr[idx]);
    }];
    [_bottomView viewAction](@([self checkRquestModel]));
}
-(BOOL)checkRquestModel
{
    if (self.requestModel.borrowType.length && self.requestModel.mrgeType.length && self.requestModel.interval.length && self.requestModel.rate && self.requestModel.count.length) {
        return YES;
    }else
    {
        return NO;
    }
}
-(void)requestConfirm
{
    @weakify(self);
    NSDictionary * dic = @{
                           @"borrowTokenID":self.requestModel.borrowType,
                           @"count":self.requestModel.count,
                           @"rate":self.requestModel.rate,
                           @"mrgeTokenID":self.requestModel.mrgeType,
                           @"interval":self.requestModel.interval,
                           };
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            self.infoModel = [BorrowInfoModel modelWithJSON:result.data];
            [self reloadData];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)requestSubmit
{

    @weakify(self);
    NSDictionary * dic = @{
                           @"borrowTokenID":self.requestModel.borrowType,
                           @"count":self.requestModel.count,
                           @"rate":self.requestModel.rate,
                           @"mrgeTokenID":self.requestModel.mrgeType,
                           @"interval":self.requestModel.interval,
                           @"mrgeCount":self.infoModel.mrgeInfo.needMrgeCount,
                           };
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            self.orderID = result.data[@"orderID"];
            if (!self.validCode) {
                self.validCode = [PopValidCode showWithTitle:@"确认借币" superView:nil action:^(RACTuple*  _Nullable x) {
                    if ([x.first isEqualToString:@"code"]) {
                        [self requestSubmit];
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
                    [[RechargePopView showWithSurperView:self.navigationController.view withModel:RACTuplePack(self.infoModel.mrgeInfo.mrgeType,self.infoModel.mrgeInfo.address) withAction:^(RACTuple*  _Nullable x) {
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
            [KKRouter pushUri:@"BorrowSuccessViewController" params:result.data];

        }else
        {
            [self.validCode showErrorMessage:result.message];
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}

@end
