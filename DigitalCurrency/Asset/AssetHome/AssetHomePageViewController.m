//
//  AssetHomePageViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/5.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "AssetHomePageViewController.h"
#import "AssetHomePageHeaderView.h"
#import "AssetHomeModel.h"

@interface AssetHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) AssetHomePageHeaderView * headerView;
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) UISwitch * ignoreSwitch;
//
@property (nonatomic, strong) NSMutableArray * dataArr;
//
@property (nonatomic, strong) NSMutableArray * orignArr;
//
@property (nonatomic, strong) NSMutableArray * ignoreArr;
//
@property (nonatomic, strong) KKEmptyDataSet *dataSet;

//
@property (nonatomic, strong) AssetHomeModel * model;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation AssetHomePageViewController

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
    self.kkBarColor = [UIColor clearColor];
    self.kkBarHidden = YES;
    self.kkLeftBarItemHidden= YES;
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.edgesForExtendedLayout = UIRectEdgeAll;//默认是UIRectEdgeAll
    
    self.view.backgroundColor = KKHexColor(ffffff);
    // Do any additional setup after loading the view.
    [self addViews];
    _dataArr = [[NSMutableArray alloc]init];
    _orignArr = [[NSMutableArray alloc]init];
    _ignoreArr = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![UserManager manager].token.length) {
        [[KKRouter pushUri:LoginVCString]continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
            [KKRouter pushUri:BorrowVCString];
            return nil;
        }];
        return;
    }
    [self requestData];
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
    [self.view addSubview:self.tableView];
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
        make.height.mas_equalTo((199+Height_StatusBar)/375.0*SCREEN_WIDTH);
    }];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-Height_TabBar);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(AssetHomePageHeaderView *)headerView
{
    if (!_headerView) {
        @weakify(self);
        _headerView =[AssetHomePageHeaderView viewWithModel:[self headerDataArr] action:^(NSString *  _Nullable x) {
            @strongify(self);
            if ([x isEqualToString:@"TradeRecorderViewController"]) {
                [KKRouter pushUri:@"TradeRecorderViewController" params:RACTuplePack(@"" , self.dataArr ,@(-1))];
            }else
            {
                [KKRouter pushUri:x];
            }
        }];
    }
    return _headerView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =KKHexColor(F5F6F7);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        adjustsScrollViewInsets(_tableView);
        [_tableView registerClass:NSClassFromString(@"AssetHomePageTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];
        self.dataSet = [KKEmptyDataSet set](_tableView);
        self.dataSet.allowScroll = YES;
        self.dataSet.padding = -(199+Height_StatusBar)/375.0*SCREEN_WIDTH/2;
        adjustsScrollViewInsets(_tableView);
        @weakify(self);
        [self.dataSet setActionBlock:^(RACTuple *x){
            @strongify(self);
            [self requestData];
        }];
    }
    return _tableView;
}
-(UISwitch *)ignoreSwitch
{
    if (!_ignoreSwitch) {
        _ignoreSwitch = [[UISwitch alloc]init];
        [_ignoreSwitch setOn:NO];
        _ignoreSwitch.onTintColor = KKHexColor(5170EB);
        _ignoreSwitch.tintColor = KKHexColor(CCCFD1);
        _ignoreSwitch.transform = CGAffineTransformMakeScale(0.75, 0.68);
        [_ignoreSwitch addTarget:self action:@selector(changedTokenSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return _ignoreSwitch;
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
    return 127;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = KKHexColor(F5F6F7);
   
    [view addSubview:self.ignoreSwitch];
    [_ignoreSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(15);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.font = KKCNFont(12);
    label.textColor = KKHexColor(465062);
    label.text = @"隐藏小额币种";
    [view addSubview:label];
    @weakify(self);
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(view);
        make.left.equalTo(self.ignoreSwitch.mas_right).offset(7);
    }];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetHomeTokenModel * model = _dataArr[indexPath.row];
    [KKRouter pushUri:@"TradeRecorderViewController" params:RACTuplePack(model.tokenID , _dataArr ,@(indexPath.row))];
}



#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)changedTokenSwitch
{
    if (self.ignoreSwitch.isOn) {
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:self.ignoreArr];
    }
    else
    {
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:self.orignArr];
    }
    if (self.dataArr.count == 0) {
        self.dataSet.title = @"暂无币种信息";
    }
    [self.tableView reloadData];
}



#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================




#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================

-(NSArray *)headerDataArr
{
    return @[
             @{@"icon":@"asset_home_recharge",@"title":@"充值",@"url":@"RechargeViewController"},
             @{@"icon":@"asset_home_withdraw",@"title":@"提现",@"url":@"WithdrawViewController"},
             @{@"icon":@"asset_home_record",@"title":@"交易记录",@"url":@"TradeRecorderViewController"}
             ];
}
-(void)requestData
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code==1000) {
            [self.dataArr removeAllObjects];
            [self.ignoreArr removeAllObjects];
            [self.orignArr removeAllObjects];
            
            self.model = [AssetHomeModel modelWithJSON:result.data];
            [self.orignArr addObjectsFromArray:self.model.walletList];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.ignored = %@", @(NO)];
            NSArray *filteredArray = [self.orignArr filteredArrayUsingPredicate:predicate];
            [self.ignoreArr addObjectsFromArray:filteredArray];
            if (self.ignoreSwitch.isOn) {
                [self.dataArr addObjectsFromArray:self.ignoreArr];
            }
            else
            {
                [self.dataArr addObjectsFromArray:self.orignArr];
            }
            if (!self.dataArr.count) {
                self.dataSet.title = @"暂无资产";
                self.dataSet.hasBtn = NO;
            }
            [self.tableView reloadData];
            [self.headerView viewAction](RACTuplePack(self.model.quotesToken,self.model.quotesTokenCount,self.model.quotesCurrency,self.model.quotesCurrencyCount));
        }else
        {
            [self.view kk_makeToast:result.message];
            self.dataSet.title = result.message;
            self.dataSet.hasBtn = YES;
        }
        self.dataSet.isLoading = NO;
        return nil;
    }];
}
-(void)test{
    NSArray * tmpArr = @[
    @{
        @"id":@"tokenID",
        @"symbol":@"BTC",
        @"name":@"Bitcoin",
        @"iconUrl":@"/image/btc25451.icon",
        @"availableCount":@"100.00000000",
        @"frozenCount":@"20.00000000",
        @"ignored":@(YES),  // ignored为false代表非小额币钟
        @"quotesType":@"USD",
        @"quotesCount":@"19000"
    },
    @{
        @"id":@"tokenID",
        @"symbol":@"ETH",
        @"name":@"Ethereum",
        @"iconUrl":@"/image/btc25451.icon",
        
        @"availableCount":@"100.00000000",
        @"frozenCount":@"20.00000000",
        @"ignored":@(NO),
        @"quotesType":@"USD",
        @"quotesCount":@"19000"
    },
    @{
        @"id":@"tokenID",
        @"symbol":@"ETH1",
        @"name":@"Ethereum1",
        @"iconUrl":@"/image/btc25451.icon",
        
        @"availableCount":@"100.00000000",
        @"frozenCount":@"20.00000000",
        @"ignored":@(YES),
        @"quotesType":@"USD",
        @"quotesCount":@"19000"
        },
    @{
        @"id":@"tokenID",
        @"symbol":@"ETH3",
        @"name":@"Ethereum3",
        @"iconUrl":@"/image/btc25451.icon",
        
        @"availableCount":@"100.00000000",
        @"frozenCount":@"20.00000000",
        @"ignored":@(NO),
        @"quotesType":@"USD",
        @"quotesCount":@"19000"
        },
    ];
    [tmpArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AssetHomeTokenModel * model = [AssetHomeTokenModel modelWithJSON:obj];
        [self.orignArr addObject:model];
    }];
    
    [self.dataArr addObjectsFromArray:self.orignArr];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ignored == %@", @(NO)];
    NSArray *filteredArray = [self.dataArr filteredArrayUsingPredicate:predicate];
    [self.ignoreArr addObjectsFromArray:filteredArray];
    [self.tableView reloadData];
    
    [self.headerView viewAction](RACTuplePack(@"BTC",@"100.00000000",@"USD",@"39992"));
}

@end
