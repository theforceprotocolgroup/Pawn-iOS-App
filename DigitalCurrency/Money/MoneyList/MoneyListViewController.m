//
//  MoneyListViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/22.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MoneyListViewController.h"
#import "MoneyListModel.h"
#define kCellRatio 98.0f/345.0f
@interface MoneyListViewController ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) UIButton * introBtn;
//
@property (nonatomic, strong) NSMutableArray * dataArr;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation MoneyListViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(NSString *)tuple {
    self.title = tuple;
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
    
    self.dataArr = [[NSMutableArray alloc]init];
    [self addViews];
    [self configData];
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
    UIView * footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
    footer.backgroundColor = KKHexColor(ffffff);
    [footer addSubview:self.introBtn];
    [_introBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer);
        make.centerX.equalTo(footer);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    [self.tableView setTableFooterView:footer];
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
        make.top.bottom.left.right.equalTo(self.view);
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
        _tableView.backgroundColor =KKHexColor(ffffff);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        adjustsScrollViewInsets(_tableView);
        [_tableView registerClass:NSClassFromString(@"MoneyListTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];
        //        adjustsScrollViewInsets(_tableView);
        
    }
    return _tableView;
}
-(UIButton *)introBtn
{
    if (!_introBtn) {
        _introBtn = [[UIButton alloc]init];
        [_introBtn setBackgroundColor:KKHexColor(EBEFFF)];
        [_introBtn setTitle:@"查看币币贷产品说明" forState:UIControlStateNormal];
        [_introBtn setTitleColor:KKHexColor(5170EB) forState:UIControlStateNormal];
        _introBtn.titleLabel.font = KKCNBFont(13);
        [_introBtn addTarget:self action:@selector(clickedIntroBtn) forControlEvents:UIControlEventTouchUpInside];
        _introBtn.layer.masksToBounds = YES;
        _introBtn.layer.borderColor = KKHexColor(5170EB).CGColor;
        _introBtn.layer.borderWidth = 1.0f;
        _introBtn.layer.cornerRadius = 15.0f;
    }
    return _introBtn;
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
    return indexPath.row == 0 ? (SCREEN_WIDTH -30) * kCellRatio + 15 + 35 : (SCREEN_WIDTH -30) * kCellRatio + 35;
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
    if (indexPath.row == 0) {
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
    }else if (indexPath.row == 1)
    {
        [KKRouter pushUri:@"https://jinshuju.net/f/SKwMCD"];
    }
}




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickedIntroBtn
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(nil).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            [KKRouter pushUri:result.data[@"productDetailIntroduce"][@"protocolHref"]];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)viewAction:(RACTuple * )x
{
    if([x.first isEqualToString:@"call"])
    {
        
    }else if([x.first isEqualToString:@"form"])
    {
        
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
-(void)configData
{
    NSArray * temp = @[
                       @{
                           @"title":@"意向沟通",
                           @"subTitle":@"致电借贷经理沟通借款需求",
                           @"backImg":@"borrowlist_bg_1",
                           },
                       @{
                           @"title":@"办理质押",
                           @"subTitle":@"将质押资产转帐至约定地址 填写质押登记表",
                           @"backImg":@"borrowlist_bg_2",
                           },
                       @{
                           @"title":@"发放贷款",
                           @"subTitle":@"币币贷向用户发放贷款",
                           @"backImg":@"borrowlist_bg_3",
                           },
                       @{
                           @"title":@"按期还款",
                           @"subTitle":@"按期还清本息后，币币贷退还质押资产",
                           @"backImg":@"borrowlist_bg_4",
                           }
                       ];
    [temp enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MoneyListModel * model = [MoneyListModel modelWithJSON:obj];
        [self.dataArr addObject:model];
    }];
    [self.tableView reloadData];
}




@end
