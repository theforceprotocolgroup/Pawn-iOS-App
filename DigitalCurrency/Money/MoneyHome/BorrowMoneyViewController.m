//
//  BorrowMoneyViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/20.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "BorrowMoneyViewController.h"
#import "BorrowMoneyModel.h"
//#import "GuidePage.h"
#define kBannerRatio 90.0f/375.0f
#define kCellRatio 137.0f/345.0f

@interface BorrowMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) UIImageView * bannerView;
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) UIView * navView;
//
@property (nonatomic, strong) UILabel * navTitleLabel;
//
@property (nonatomic, strong) NSMutableArray * dataArr;
//
@property (nonatomic, strong) UIButton * callBtn;
//
//@property (nonatomic, strong) GuidePage * guidePage;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation BorrowMoneyViewController

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
    self.kkBarHidden = YES;
    self.kkLeftBarItemHidden= YES;
    self.kkBarColor = [UIColor whiteColor];
    self.title = @"借款";
    self.view.backgroundColor = KKHexColor(F5F6F7);
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;//默认是UIRectEdgeAll
    [self addViews];
    _dataArr = [[NSMutableArray alloc]init];
    [self configData];
//    if ([GuidePage isFirstLaunch]) {
//        [self.tabBarController.view addSubview:self.guidePage];
//        @weakify(self);
//        [self.guidePage mas_updateConstraints:^(MASConstraintMaker *make) {
//            @strongify(self);
//            make.top.left.right.bottom.equalTo(self.tabBarController.view);
//        }];
//        [GuidePage setLaunched];
//    }
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
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.navTitleLabel];
    [self.view addSubview:self.tableView];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kBannerRatio * SCREEN_WIDTH)];
    [headerView addSubview:self.bannerView];
    [self.bannerView addSubview:self.callBtn];
    [self.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(headerView);
    }];
    @weakify(self);
    [self.callBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.bannerView).offset(-25);
        make.bottom.equalTo(self.bannerView).offset(-25);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(70);
    }];
    [self.tableView setTableHeaderView:headerView];
    [self updateLayout];
    
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_navView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(Height_NavBar);
    }];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-Height_TabBar);
    }];
    [_navTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.navView).offset(15);
        make.centerY.equalTo(self.navView.mas_bottom).offset(-22);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =KKHexColor(F5F6F7);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        adjustsScrollViewInsets(_tableView);
        [_tableView registerClass:NSClassFromString(@"BorrowMoneyTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];
        //        adjustsScrollViewInsets(_tableView);
        
    }
    return _tableView;
}
-(UIImageView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[UIImageView alloc] init];
        _bannerView.image = KKImage(@"borrowmoney_banner");
        _bannerView.userInteractionEnabled = YES;
    }
    return _bannerView;
}
-(UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc]init];
        _navView.backgroundColor = [UIColor whiteColor];
    }
    return _navView;
}
-(UILabel *)navTitleLabel
{
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc]init];
        _navTitleLabel.font = KKCNBFont(22);
        _navTitleLabel.textColor = KKHexColor(0C1E48);
        _navTitleLabel.text = @"借款";
    }
    return _navTitleLabel;
}

-(UIButton *)callBtn
{
    if (!_callBtn) {
        _callBtn = [[UIButton alloc]init];
        [_callBtn setImage:KKImage(@"borrowmoney_call") forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(clickedCallBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
}

#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![cell conformsToProtocol:@protocol(KKViewDelegate)]) return cell;
    
    id data;
    id model = _dataArr[indexPath.row];
    data = RACTuplePack(model,indexPath);
    @weakify(self);
    [(id<KKViewDelegate>)cell viewModel:data action:^(id _Nullable x) {
        @strongify(self);
        if ([self conformsToProtocol:@protocol(KKViewDelegate)] && [self respondsToSelector:@selector(viewAction:)]) {
            return [(id<KKViewDelegate>)self viewAction:x];
        }
    }];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 3 ? (SCREEN_WIDTH -30) * 150.0f/345.0f : (SCREEN_WIDTH -30) * kCellRatio;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BorrowMoneyModel * model = _dataArr[indexPath.row];
    [KKRouter pushUri:@"MoneyListViewController" params:model.title];
}



#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clickedCallBtn
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(nil).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            NSString *phoneString = [NSString stringWithFormat:@"tel://%@", result.data[@"servicePhoneNumber"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}


#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================




#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================
-(void)configData
{
    NSArray * temp = @[
                       @{
                           @"title":@"免息贷",
                           @"subTitle":@"币币贷托管",
                           @"count":@"借款额度  10万以上",
                           @"token":@"质押币种  BTC",
                           @"interval":@"借款周期  30天以上",
                           @"backImg":@"borrowmoney_bg_1",
                           },
                       @{
                           @"title":@"托管贷",
                           @"subTitle":@"InVault企业级持牌钱包托管",
                           @"count":@"借款额度  10万以上",
                           @"token":@"质押币种  BTC、ETH",
                           @"interval":@"借款周期 15天以上",
                           @"backImg":@"borrowmoney_bg_2",
                           },
                       @{
                           @"title":@"大额托管贷",
                           @"subTitle":@"独立地址，三方多签",
                           @"count":@"借款额度  50万以上",
                           @"token":@"质押币种  BTC、ETH",
                           @"interval":@"借款周期  15天以上",
                           @"backImg":@"borrowmoney_bg_3",
                           },
                       @{
                           @"title":@"组合贷",
                           @"subTitle":@"InVault企业级持牌钱包托管",
                           @"count":@"借款额度  5万以上",
                           @"token":@"质押币种  BTC、ETH、\n               EOS、USDT等",
                           @"interval":@"借款周期  15天以上",
                           @"backImg":@"borrowmoney_bg_4",
                           }
                       ];
    [temp enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BorrowMoneyModel * model = [BorrowMoneyModel modelWithJSON:obj];
        [self.dataArr addObject:model];
    }];
    [self.tableView reloadData];
}




@end
