//
//  MessageCenterViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/16.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MessageCenterTableViewCell.h"
#import "MessageCenterListModel.h"
@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) NSMutableArray * dataArr;
//
@property (nonatomic, assign) NSInteger pageNum;
//
@property (nonatomic, strong) KKEmptyDataSet *dataSet;

#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation MessageCenterViewController

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
    self.view.backgroundColor = KKHexColor(ffffff);
    self.title = @"消息中心";
    [self addViews];
    self.pageNum = 1;
    self.dataArr = [[NSMutableArray alloc]init];
    [self requestData];
  //  [self requestData];
    
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
        _tableView.backgroundColor =KKHexColor(f5f6f7);
        adjustsScrollViewInsets(_tableView);
        [_tableView registerClass:NSClassFromString(@"MessageCenterTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];
        self.dataSet = [KKEmptyDataSet set](_tableView);
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
    data = self.dataArr[indexPath.row];
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
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(self.class) cacheByIndexPath:indexPath configuration:^(MessageCenterTableViewCell *cell) {
        cell.fd_isTemplateLayoutCell = YES;
        id data;
        data = self.dataArr[indexPath.row];
        [(id<KKViewDelegate>)cell viewModel:data action:^(id _Nullable x) {
            
        }];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCenterListModel * model = self.dataArr[indexPath.row];
    model.noticeIsRead = YES;
    [self.tableView reloadData];
    [KKRouter pushUri:@"MessageDetailViewController" params:model.noticeID];
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
-(void)requestData
{
    @weakify(self);
    self.dataSet.isLoading = YES;
    [[KKRequest jsonRequest].urlString(@"").paramaters(@{@"pageNum":@(_pageNum)}).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            if (self.pageNum == 1) {
                [self.dataArr removeAllObjects];
            }
            NSArray * dataArr =  [result arrWithClass:@"MessageCenterListModel"];
            if (!dataArr.count && self.pageNum == 1) {
                self.dataSet.title = @"暂无消息";
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
    NSArray * tmpArr =  @[  @{
                                @"noticeID": @"notice111",
                                @"noticeTitle": @"notice111",
                                @"noticeContent": @"{Error Domain=kCFErrorDomainCFNetwork Code=-1001  UserInfo={_kCFStreamErrorCodeKey=60, _kCFStreamErrorDomainKey=1}}, _NSURLErrorFailingURLSessi",
                                @"noticeIsRead": @(YES),
                                @"sentTime": @"2018-07-29 15:14:28"
                                },
                            @{
                                @"noticeID": @"notice112",
                                @"noticeTitle": @"{Error Domain=kCFErrorDomainCFNetwork Code=-1001  UserInfo={_kCFStreamErrorCodeKey=60, _kCFStreamErrorDomainKey=1}}, _NSURLErrorFailingURLSessi",
                                @"noticeContent": @"您于2018年12月15日23点32分到款3.25.00000BTC，请查收",
                                @"noticeIsRead": @(YES),
                                @"sentTime": @"2018-07-29 15:14:28"
                                }
                            
                            ];
    self.dataArr = [[NSMutableArray alloc]init];
    [tmpArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArr addObject:[NSClassFromString(@"MessageCenterListModel") modelWithJSON:obj]];
    }];
    [self.tableView reloadData];
}



@end
