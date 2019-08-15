//
//  SettingViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) UIButton * logoutBTN;

//
@property (nonatomic, strong) NSArray * dataArr;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation SettingViewController

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
    self.edgesForExtendedLayout = UIRectEdgeNone;//默认是UIRectEdgeAll
    self.title = @"设置";
    self.view.backgroundColor = KKHexColor(F5F6F7);
    [self configData];
    [self addViews];
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
    [self.view addSubview:self.logoutBTN];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    CGFloat height = [UserManager manager].token.length ? 226 : 100;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(height);
    }];
    [self.logoutBTN mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.tableView.mas_bottom).offset(32);
        make.height.mas_equalTo(44);
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor =KKHexColor(F5F6F7);
        [_tableView registerClass:NSClassFromString(@"SettingTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];
    }
    return _tableView;
}
-(UIButton *)logoutBTN
{
    if (!_logoutBTN) {
        _logoutBTN = [[UIButton alloc]init];
        _logoutBTN.kkButtonType = KKButtonTypePriHollow;
        [_logoutBTN addTarget:self action:@selector(clickedLogoutBtn) forControlEvents:UIControlEventTouchUpInside];
        [_logoutBTN setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutBTN.layer.cornerRadius = 22.0f;
        _logoutBTN.layer.masksToBounds = YES;
    }
    return _logoutBTN;
}

#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![cell conformsToProtocol:@protocol(KKViewDelegate)]) return cell;
    
    
    id data;
    data = RACTuplePack(self.dataArr[indexPath.section][indexPath.row] ,@([self.dataArr[indexPath.section] count]-1 ==indexPath.row));
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
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 12;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    view.backgroundColor = KKHexColor(F5F6F7);
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _dataArr[indexPath.section][indexPath.row];
    if ([dic[@"url"] length]) {
        [KKRouter pushUri:dic[@"url"] params:dic[@"content"]];
    }
    if ([dic[@"title"] isEqualToString:@"清理缓存"])
    {
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]){
            [storage deleteCookie:cookie];
        }
        
        //清除UIWebView的缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [self.view kk_makeToast:@"清除缓存成功"];
        }];
    }
}




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickedLogoutBtn
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code==1000) {
            [UserManager clearLoginInfo];
            [self configData];
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
    if ([UserManager manager].token.length) {
        _dataArr = @[@[@{@"title":@"修改登录密码",@"url":@"RegistViewController",@"content":@(YES)}],@[@{@"title":@"换绑手机号",@"url":@"ChangedPhoneViewController"}],@[@{@"title":@"清理缓存",@"url":@""},@{@"title":@"关于我们",@"url":@"AboutUsViewController"}]];
        self.logoutBTN.hidden = NO;
    }else
    {
        _dataArr = @[@[@{@"title":@"清理缓存",@"url":@""},@{@"title":@"关于我们",@"url":@"AboutUsViewController"}]];
        self.logoutBTN.hidden = YES;
    }
    [self.tableView reloadData];
}


@end
