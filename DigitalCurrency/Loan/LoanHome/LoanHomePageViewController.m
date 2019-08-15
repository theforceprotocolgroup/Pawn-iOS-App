//
//  LoanHomePageViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/12.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "LoanHomePageViewController.h"
#import "LoanHomePageModel.h"
#import "BannerModel.h"
#import <iCarousel/iCarousel.h>

#define kRatio 90.0f/375.0f
@interface LoanHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,iCarouselDelegate,iCarouselDataSource>
//
@property (nonatomic, strong) iCarousel * bannerView;
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) UIView * navView;
//
@property (nonatomic, strong) UILabel * navTitleLabel;
//
@property (nonatomic, strong) NSMutableArray <LoanHomePageModel * >* dataArr;
//
@property (nonatomic, strong) NSMutableArray * bannerDataArr;
//
@property (nonatomic, assign) NSInteger  bannerIndex;

@property (nonatomic, assign) int pageNum;
@property (nonatomic, assign) BOOL refresh;

@property (nonatomic, strong) KKEmptyDataSet *dataSet;
@end

@implementation LoanHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kkHairlineHidden = YES;
    self.kkBarHidden = YES;
    self.kkLeftBarItemHidden= YES;
    self.title = @"出借";
    self.view.backgroundColor = KKHexColor(F5F6F7);
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;//默认是UIRectEdgeAll
    [self addViews];
    _bannerDataArr = [[NSMutableArray alloc]init];
    _dataArr = [[NSMutableArray alloc]init];
    self.pageNum = 1;
//    [self configData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.pageNum == 1) {
        [self requestData];
    }
}
#pragma mark - View
///=============================================================================
/// @name addViews
///=============================================================================
- (void)addViews {
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.navTitleLabel];
    [self.view addSubview:self.tableView];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kRatio * SCREEN_WIDTH)];
    [headerView addSubview:self.bannerView];
    [self.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(headerView);
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =KKHexColor(F5F6F7);
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        adjustsScrollViewInsets(_tableView);
        [_tableView registerClass:NSClassFromString(@"LoanHomePageTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];
        self.dataSet = [KKEmptyDataSet set](_tableView);
//        adjustsScrollViewInsets(_tableView);
        @weakify(self);
        [self.dataSet setActionBlock:^(RACTuple *x){
            @strongify(self);
            [self requestData];
        }];
        self.dataSet.padding = (kRatio * SCREEN_WIDTH - Height_NavBar)/2.0 ;
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
-(iCarousel *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kRatio * SCREEN_WIDTH)];
        _bannerView.backgroundColor = [UIColor whiteColor];
        _bannerView.type = iCarouselTypeLinear;
        _bannerView.delegate = self;
        _bannerView.dataSource = self;
        _bannerView.pagingEnabled = YES;
        _bannerView.bounceDistance = .2;
        _bannerView.clipsToBounds = YES;
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
        _navTitleLabel.text = @"出借";
    }
    return _navTitleLabel;
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
    return 157;
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
    [KKRouter pushUri:@"LoanDetailViewController" params:_dataArr[indexPath.row].orderID];
}

#pragma mark - Carousel delegate
///=============================================================================
/// @name Carousel delegate
///=============================================================================

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.bannerDataArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index
         reusingView:(UIImageView *)view {
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kRatio * SCREEN_WIDTH)];
    }
    BannerModel * model = self.bannerDataArr[index];
    [view sd_setImageWithURL:[NSURL URLWithString:model.imageURI] placeholderImage:KKImage(@"bannerDefault")];
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionWrap) return YES;
    return value;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.bannerIndex = carousel.currentItemIndex;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    BannerModel * model = self.bannerDataArr[index];
    if (model.imageHref) {
        [KKRouter pushUri:model.imageHref];
    }
}
#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================

-(void)configData
{
    NSArray * titleArr = @[@{
        @"orderID":@"LOAN154545",
        @"borrowCount":@"3.00000000BTC",
        @"borrowType":@"BTC",
        @"iconUrl":@"/icon/BTC545.icon",
        @"borrowUserID":@"borrowUserID",
        @"daliyRate":@"0.1%",
        @"interval":@"7天",
        @"expected":@"0.03000000BTC"
    },
    @{
        @"orderID":@"LOAN154545",
        @"borrowCount":@"3.00000000BTC",
        @"borrowType":@"BTC",
        @"iconUrl":@"/icon/BTC545.icon",
        @"borrowUserID":@"borrowUserID",
        @"daliyRate":@"0.1%",
        @"interval":@"7天",
        @"expected":@"0.03000000BTC"
    }
                           ];
    _dataArr = [[NSMutableArray alloc]init];
    [titleArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LoanHomePageModel * model = [LoanHomePageModel modelWithDictionary:obj];
        [self.dataArr addObject:model];
    }];
    NSArray * banner = @[@{
                               @"title":@"LOAN154545",
                               @"url":@"3.00000000BTC",
                               @"address":@"BTC",
                               },
                           @{
                             @"title":@"LOAN154545",
                             @"url":@"3.00000000BTC",
                             @"address":@"BTC",
                               }
                           ];
    _bannerDataArr = [[NSMutableArray alloc]init];
    [banner enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BannerModel * model = [BannerModel modelWithDictionary:obj];
        [self.bannerDataArr addObject:model];
    }];
    [self.tableView reloadData];
    
    [self.bannerView reloadData];
}
-(void)requestData
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code == 1000) {
            NSArray * banner = result.data[@""];
            [self.bannerDataArr removeAllObjects];
            [banner enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BannerModel * model = [BannerModel modelWithDictionary:obj];
                [self.bannerDataArr addObject:model];
            }];
            if (self.pageNum == 1) {
                [self.dataArr removeAllObjects];
            }
            NSArray * list = result.data[@""];
            NSMutableArray * tempArr = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LoanHomePageModel * model = [LoanHomePageModel modelWithDictionary:obj];
                [tempArr addObject:model];
            }];
            if (!tempArr.count && self.pageNum == 1) {
                self.dataSet.title = @"暂无出借产品";
                self.dataSet.hasBtn = NO;
                self.tableView.tableFooterView = nil;

            }else if(tempArr.count < 10)
            {
                if (tempArr.count) {
                    [self.dataArr addObjectsFromArray:tempArr];
                }
                self.tableView.mj_footer.hidden = YES;
                [self setTableViewFooterView];
            }else
            {
                self.pageNum ++;
                [self.dataArr addObjectsFromArray:tempArr];
                self.tableView.tableFooterView = nil;
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView reloadData];
            [self.bannerView reloadData];
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
@end
