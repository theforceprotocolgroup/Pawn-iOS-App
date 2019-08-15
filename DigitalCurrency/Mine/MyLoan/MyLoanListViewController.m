//
//  MyLoanListViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/6.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyLoanListViewController.h"
#import "MyLoanListModel.h"

@interface MyLoanListViewController ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, assign) int pageNum;
@property (nonatomic, assign) BOOL refresh;

@property (nonatomic, strong) KKEmptyDataSet *dataSet;

#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation MyLoanListViewController

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
    self.kkLeftBarItemHidden= NO;
    self.view.backgroundColor = KKHexColor(ffffff);
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addViews];
    self.pageNum = 1;
    [self requestData];
//    switch (self.type) {
//        case LoanTypeHoldIng:
//            [self test];
//            break;
//        case LoanTypeFinished:
//            [self test1];
//            break;
//        case LoanTypeAll:
//            [self test2];
//            break;
//        default:
//            break;
//    }
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
    [self.view addSubview:self.tableView];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT - 51 -Height_NavBar );
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor =KKHexColor(ffffff);
        [_tableView registerClass:NSClassFromString(@"MyLoanTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];
        self.dataSet = [KKEmptyDataSet set](_tableView);
        adjustsScrollViewInsets(_tableView);
        @weakify(self);
        [self.dataSet setActionBlock:^(RACTuple *x){
            @strongify(self);
            [self requestData];
        }];
        self.dataSet.padding = -51.0f/2.0f;
        self.dataSet.allowScroll = YES;
        _tableView.mj_footer = [KKRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self requestData];
        }];
        _tableView.mj_header = [KKRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.pageNum = 1;
            [self requestData];
        }];
    }
    
    return _tableView;
    
}

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
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
    return [self.listArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![cell conformsToProtocol:@protocol(KKViewDelegate)]) return cell;
    

    id data;
    data = RACTuplePack(self.listArray[indexPath.row]);
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
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLoanListModel * model = _listArray[indexPath.row];
    [KKRouter pushUri:@"MyLoanDetailViewController" params:model.orderID];
}

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
    NSArray * tmpArr = @[
                        @{
                            @"orderID":@"LOAN3255974",
                            @"status":@"1", //1:持有中2:已回款,
                            @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                            @"investedCount":@"100.00000000",
                            @"investedCoinType":@"BTC",
                            @"interestCount":@"0.03000000"
                        },
                        @{
                            @"orderID":@"LOAN3255974",
                            @"status":@"1", //1:持有中2:已回款,
                            @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                            @"investedCount":@"190.00000000",
                            @"investedCoinType":@"ETC",
                            @"interestCount":@"0.03000000"
                            },
                        @{
                            @"orderID":@"LOAN3255974",
                            @"status":@"1", //1:持有中2:已回款,
                            @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                            @"investedCount":@"340.00000000",
                            @"investedCoinType":@"NASA",
                            @"interestCount":@"0.03000000"
                            },
                        ];
    [tmpArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyLoanListModel * model = [MyLoanListModel modelWithJSON:obj];
        [self.listArray addObject:model];
    }];
    [self.tableView reloadData];

}

-(void)test1{
    NSArray * tmpArr = @[
                         @{
                             @"orderID":@"LOAN3255974",
                             @"status":@"2", //1:持有中2:已回款,
                             @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                             @"investedCount":@"100.00000000",
                             @"investedCoinType":@"BTC",
                             @"interestCount":@"0.03000000"
                             },
                         @{
                             @"orderID":@"LOAN3255974",
                             @"status":@"2", //1:持有中2:已回款,
                             @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                             @"investedCount":@"190.00000000",
                             @"investedCoinType":@"ATM",
                             @"interestCount":@"0.03000000"
                             },
                         @{
                             @"orderID":@"LOAN3255974",
                             @"status":@"2", //1:持有中2:已回款,
                             @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                             @"investedCount":@"340.00000000",
                             @"investedCoinType":@"FIFA",
                             @"interestCount":@"0.03000000"
                             },
                         ];
    [tmpArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyLoanListModel * model = [MyLoanListModel modelWithJSON:obj];
        [self.listArray addObject:model];
    }];
    [self.tableView reloadData];
}
-(void)requestData
{
    NSDictionary * dic;
    dic = @{@"pageNum":@(_pageNum),@"type":[NSString stringWithFormat:@"%li",(long)self.type]};

    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            if (self.pageNum == 1) {
                [self.listArray removeAllObjects];
            }
            NSArray * dataArr =  [result arrWithClass:@"MyLoanListModel"];
            if (!dataArr.count && self.pageNum == 1) {
                NSString * str ;
                switch (self.type) {
                    case 1:
                        str = @"暂无持有中出借订单";
                        break;
                    case 2:
                        str = @"暂无已回款出借订单";
                        break;
                    case 3:
                        str = @"暂无出借订单";
                        break;
                    default:
                        break;
                }
                self.dataSet.title = str;
                self.dataSet.hasBtn = NO;
            }else if(dataArr.count < 10)
            {
                if (dataArr.count) {
                    [self.listArray addObjectsFromArray:dataArr];
                }
                self.tableView.mj_footer.hidden = YES;
                [self setTableViewFooterView];
            }else
            {
                self.pageNum ++;
                [self.listArray addObjectsFromArray:dataArr];
                self.tableView.tableFooterView = nil;
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView reloadData];
        }else
        {
            [self.view kk_makeToast:result.message];
            self.dataSet.title = result.message;
            self.dataSet.hasBtn = YES;
        }
        self.dataSet.isLoading = NO;
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:nil];
        [self.tableView.mj_header endRefreshingWithCompletionBlock:nil];
        
        return nil;
    }];
}
- (void)setTableViewFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    footer.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"当前没有更多";
    label.font = KKCNFont(13);
    label.textColor = KKHexColor(C7CED9);
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [footer addSubview:label];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footer);
        make.centerX.equalTo(footer);
    }];
    self.tableView.tableFooterView = footer;
}
-(void)test2{
    NSArray * tmpArr = @[
                         @{
                             @"orderID":@"LOAN3255974",
                             @"status":@"2", //1:持有中2:已回款,
                             @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                             @"investedCount":@"100.00000000",
                             @"investedCoinType":@"BTC",
                             @"interestCount":@"0.03000000"
                             },
                         @{
                             @"orderID":@"LOAN3255974",
                             @"status":@"1", //1:持有中2:已回款,
                             @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                             @"investedCount":@"100.00000000",
                             @"investedCoinType":@"BTC",
                             @"interestCount":@"0.03000000"
                             },
                         @{
                             @"orderID":@"LOAN3255974",
                             @"status":@"1", //1:持有中2:已回款,
                             @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                             @"investedCount":@"190.00000000",
                             @"investedCoinType":@"ETC",
                             @"interestCount":@"0.03000000"
                             },
                         @{
                             @"orderID":@"LOAN3255974",
                             @"status":@"2", //1:持有中2:已回款,
                             @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                             @"investedCount":@"190.00000000",
                             @"investedCoinType":@"ATM",
                             @"interestCount":@"0.03000000"
                             },
                         @{
                             @"orderID":@"LOAN3255974",
                             @"status":@"2", //1:持有中2:已回款,
                             @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                             @"investedCount":@"340.00000000",
                             @"investedCoinType":@"FIFA",
                             @"interestCount":@"0.03000000"
                             },
                         @{
                             @"orderID":@"LOAN3255974",
                             @"status":@"1", //1:持有中2:已回款,
                             @"expectedrepaymentDate":@" 2018-11-18 08:00:00",
                             @"investedCount":@"340.00000000",
                             @"investedCoinType":@"NASA",
                             @"interestCount":@"0.03000000"
                             },
                         ];
    [tmpArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MyLoanListModel * model = [MyLoanListModel modelWithJSON:obj];
        [self.listArray addObject:model];
    }];
    [self.tableView reloadData];
}
@end
