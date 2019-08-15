//
//  TradeRecorderViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/8.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "TradeRecorderViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "TradeRecouderTableViewCell.h"
#import "TradeRecouderModel.h"
#import "PopTokenListView.h"
@interface TradeRecorderViewController ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) UIButton * rightBtn;
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) NSMutableArray * dataArr;
//
@property (nonatomic, strong) NSString * tokenID;
//
@property (nonatomic, strong) NSArray * tokenArr;
//
@property (nonatomic, strong) PopTokenListView * listView;

@property (nonatomic, strong) KKEmptyDataSet *dataSet;
//
@property (nonatomic, assign) NSInteger pageNum;
//
@property (nonatomic, assign) NSInteger index;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation TradeRecorderViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(RACTuple *)tuple {
    self.tokenID = tuple.first;
    self.tokenArr = tuple.second;
    self.index = [tuple.third integerValue];
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
    self.view.backgroundColor = KKHexColor(ffffff);
    // Do any additional setup after loading the view.
    self.title = @"交易记录";
    [self addViews];
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,44)];
    [_rightBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:KKHexColor(0C1E48) forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = KKCNFont(14);
    [_rightBtn setImage:KKImage(@"filter_icon") forState:UIControlStateNormal];
    [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_rightBtn.imageView.size.width, 0, _rightBtn.imageView.size.width)];
    [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _rightBtn.titleLabel.bounds.size.width + 2.5, 0, -_rightBtn.titleLabel.bounds.size.width-2.5)];

    [_rightBtn addTarget:self action:@selector(clickedFliter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    self.pageNum = 1;
    self.dataArr = [[NSMutableArray alloc]init];
    [self requestData];
//    [self test];
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
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT - Height_NavBar);
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
        adjustsScrollViewInsets(_tableView);
        [_tableView registerClass:NSClassFromString(@"TradeRecouderTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];
        self.dataSet = [KKEmptyDataSet set](_tableView);
        self.dataSet.allowScroll = YES;
        @weakify(self);
        [self.dataSet setActionBlock:^(RACTuple *x){
            @strongify(self);
            [self requestData];
        }];
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
    return [self.dataArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![cell conformsToProtocol:@protocol(KKViewDelegate)]) return cell;
    
    
    id data;
    data = RACTuplePack(self.dataArr[indexPath.row]);
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
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(self.class) cacheByIndexPath:indexPath configuration:^(TradeRecouderTableViewCell *cell) {
        cell.fd_isTemplateLayoutCell = YES;
        id data;
        data = RACTuplePack(self.dataArr[indexPath.row]);
        [(id<KKViewDelegate>)cell viewModel:data action:^(id _Nullable x) {

        }];
    }];
//    static TradeRecouderTableViewCell *cell = nil;
//    static dispatch_once_t onceToken;
//
//    dispatch_once(&onceToken, ^{
//        cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
//    });
//    id data;
//    data = RACTuplePack(self.dataArr[indexPath.row]);
//    [(id<KKViewDelegate>)cell viewModel:data action:^(id _Nullable x) {
//
//    }];
//
//    //自定义计算高度的方法
//    return [self calculateHeightForConfiguredSizingCell:cell];
    
}
- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    //调用系统提供的systemLayoutSizeFittingSize API进行高度计算
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickedFliter
{
    @weakify(self);
    if (!_listView) {
        _listView = [PopTokenListView showWithDefaultIndex:_index Content:self.tokenArr superView:nil action:^(NSNumber *  _Nullable x) {
            @strongify(self);
            self.index = x.integerValue;
            if (self.index >=0) {
                TradeRecouderModel * model = self.tokenArr[self.index];
                self.tokenID = model.tokenID;
            }else
            {
                self.tokenID = @"";
            }
            //请求
            self.pageNum = 1;
            [self requestData];
        }];
    }
    [_listView show];
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
    NSString * url;
    NSDictionary * dic;
    if (self.tokenID.length) {
        url = @"wallet/getTokenTransaction";
        dic = @{@"pageNum":@(_pageNum),@"tokenID":self.tokenID};
    }else
    {
        url = @"wallet/transaction";
        dic = @{@"pageNum":@(_pageNum)};
    }
    @weakify(self);
    self.dataSet.isLoading = YES;
    [[KKRequest jsonRequest].urlString(url).paramaters() {
        @strongify(self);
        if (result.code==1000) {
            if (self.pageNum == 1) {
                [self.dataArr removeAllObjects];
            }
            NSArray * dataArr =  [result arrWithClass:@"TradeRecouderModel"];
            if (!dataArr.count && self.pageNum == 1) {
                self.dataSet.title = @"暂无交易记录";
                self.dataSet.hasBtn = NO;
            }else if(dataArr.count < 10)
            {
                if (dataArr.count) {
                    [self.dataArr addObjectsFromArray:dataArr];
                }
                self.tableView.mj_footer.hidden = YES;
                [self setTableViewFooterView];
            }else
            {
                self.pageNum ++;
                [self.dataArr addObjectsFromArray:dataArr];
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
-(void)test
{
    NSArray * tmpArr =  @[@{
                              @"tokenID": @"BTC0001",
                              @"iconURI": @"/btc/mc.png",
                              @"tokenSymbol": @"BTC",
                              @"tokenCount": @"2.08",
                              @"TxType": @"1",
                              @"TxTypeInfo": @"充值",
                              @"TxDescription": @[
                                      @{
                                          @"title": @"入账时间",
                                          @"content": @"2019年1月3日16点52分"
                                          },
                                      @{
                                          @"title": @"交易哈希",
                                          @"content": @"0x41633566df6679e75abb1caf9488b428f84ef51f6a5a5c7498d0e5f161f1a5bb"
                                          }
                                      ]
                              },
                          @{
                              @"tokenID": @"BTC0001",
                              @"iconURI": @"/btc/mc.png",
                              @"tokenSymbol": @"EOS",
                              @"tokenCount": @"2.08",
                              @"TxType": @"2",
                              @"TxTypeInfo": @"提现",
                              @"TxDescription": @[
                                      @{
                                          @"title": @"入账时间",
                                          @"content": @"2019年1月3日16点52分"
                                          },
                                      @{
                                          @"title": @"转出时间",
                                          @"content": @"2019年1月3日16点52分"
                                          },
                                      ]
                              },
                          @{
                              @"tokenID": @"BTC0001",
                              @"iconURI": @"/btc/mc.png",
                              @"tokenSymbol": @"BTC",
                              @"tokenCount": @"2.08",
                              @"TxType": @"2",
                              @"TxTypeInfo": @"充值",
                              @"TxDescription": @[
                                      @{
                                          @"title": @"交易哈希",
                                          @"content": @"0x41633566df6679e75abb1caf9488b428f84ef51f6a5a5c7498d0e5f161f1a5bb"
                                          },
                                      @{
                                          @"title": @"入账时间",
                                          @"content": @"2019年1月3日16点52分"
                                          },

                                      ]
                              },
                          @{
                              @"tokenID": @"BTC0001",
                              @"iconURI": @"/btc/mc.png",
                              @"tokenSymbol": @"BTC",
                              @"tokenCount": @"2.08",
                              @"TxType": @"1",
                              @"TxTypeInfo": @"充值",
                              @"TxDescription": @[
                                      @{
                                          @"title": @"入账时间",
                                          @"content": @"2019年1月3日16点52分"
                                          },
                                      @{
                                          @"title": @"交易哈希",
                                          @"content": @"0x41633566df6679e75abb1caf9488b428f84ef51f6a5a5c7498d0e5f161f1a5bb"
                                          }
                                      ]
                              },
                          ];
    self.dataArr = [[NSMutableArray alloc]init];
    [tmpArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArr addObject:[TradeRecouderModel modelWithJSON:obj]];
    }];
    [self.tableView reloadData];
}

@end
