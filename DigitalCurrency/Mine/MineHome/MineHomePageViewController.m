//
//  MineHomePageViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/12.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "MineHomePageViewController.h"
#import "MineHomePageHeaderView.h"
#import "MineHomePageLoginHeaderView.h"
#import "MineHomeModel.h"
@interface MineHomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) UIView * navView;
//
@property (nonatomic, strong) UIImageView * headerIcon;
//
@property (nonatomic, strong) UILabel * phoneLabel;
//
@property (nonatomic, strong) UIButton * messageBtn;
//
@property (nonatomic, strong) UIButton * settingBtn;
//
@property (nonatomic, strong) MineHomePageLoginHeaderView * loginHeaderView;
//
@property (nonatomic, strong) MineHomePageHeaderView * noLoginHeaderView;
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) UIView * headerView;
//
@property (nonatomic, strong) NSMutableArray * dataArr;
//
@property (nonatomic, strong) MineHomeModel * model;
@end

@implementation MineHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kkHairlineHidden = YES;
    self.kkBarHidden = YES;
    self.kkLeftBarItemHidden= YES;
    self.title = @"我的";
    self.view.backgroundColor = KKHexColor(F5F6F7);
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;//默认是UIRectEdgeAll
    // Do any additional setup after loading the view.
    [self addViews];
    [self.tableView reloadData];
    if ([UserManager manager].token.length) {
        [self.headerView removeAllSubviews];
        [self.headerView addSubview:self.loginHeaderView];
        @weakify(self);
        [self.loginHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.right.top.bottom.equalTo(self.headerView);
        }];
    }else
    {
        [self.headerView removeAllSubviews];
        [self.headerView addSubview:self.noLoginHeaderView];
        @weakify(self);
        [self.noLoginHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.right.top.bottom.equalTo(self.headerView);
        }];
    }
    [self observerLoginStatus];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
    self.phoneLabel.text = [UserManager manager].username;
}

-(void)observerLoginStatus
{
    @weakify(self);
    [[UserManager loginSignal] subscribeNext:^(NSNumber*  _Nullable x) {
        @strongify(self);
        if (x.boolValue) {
            [self.headerView removeAllSubviews];
            [self.headerView addSubview:self.loginHeaderView];
            @weakify(self);
            [self.loginHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.right.top.bottom.equalTo(self.headerView);
            }];
        }else
        {
            [self.headerView removeAllSubviews];
            [self.headerView addSubview:self.noLoginHeaderView];
            @weakify(self);
            [self.noLoginHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.right.top.bottom.equalTo(self.headerView);
            }];
        }
        
    }];
}
- (void)addViews {
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.headerIcon];
    [self.navView addSubview:self.phoneLabel];
    [self.navView addSubview:self.messageBtn];
    [self.navView addSubview:self.settingBtn];
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
    [_navView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(60+Height_StatusBar);
    }];
    [_headerIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.navView).offset(-12);
        make.left.equalTo(self.navView).offset(13);
        make.height.width.mas_equalTo(37);
    }];
    
    [_phoneLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.headerIcon.mas_right).offset(8);
        make.centerY.equalTo(self.headerIcon);
    }];
    [_settingBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.navView.mas_right).offset(-13);
        make.centerY.equalTo(self.headerIcon);
        make.height.width.mas_equalTo(25);
    }];
    [_messageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.settingBtn.mas_left).offset(-23);
        make.centerY.equalTo(self.headerIcon);
        make.height.width.mas_equalTo(25);
    }];
    [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
        make.height.mas_equalTo(186);
    }];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-Height_TabBar);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc]init];
        _navView.backgroundColor = [UIColor whiteColor];
    }
    return _navView;
}
-(UIImageView *)headerIcon
{
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc]initWithImage:KKImage(@"mine_headerIcon")];
    }
    return _headerIcon;
}
-(UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.textColor = KKHexColor(0C1E48);
        _phoneLabel.font = KKCNFont(13);
    }
    return _phoneLabel;
}
-(UIButton *)messageBtn
{
    if (!_messageBtn) {
        _messageBtn = [[UIButton alloc]init];
        [_messageBtn setImage:KKImage(@"mine_messageIcon") forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(clickMessageBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}
-(UIButton *)settingBtn
{
    if (!_settingBtn) {
        _settingBtn = [[UIButton alloc]init];
        [_settingBtn setImage:KKImage(@"mine_settingIcon") forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(clickSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}
-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =KKHexColor(ffffff);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        adjustsScrollViewInsets(_tableView);
        [_tableView registerClass:NSClassFromString(@"MineHomeTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];
    }
    return _tableView;
}
-(MineHomePageLoginHeaderView *)loginHeaderView
{
    if (!_loginHeaderView) {
        _loginHeaderView = [MineHomePageLoginHeaderView viewWithModel:nil action:^(id  _Nullable x) {
            
        }];
    }
    return _loginHeaderView;
}
-(MineHomePageHeaderView *)noLoginHeaderView
{
    if (!_noLoginHeaderView) {
        _noLoginHeaderView = [MineHomePageHeaderView viewWithModel:nil action:^(NSString*  _Nullable x) {
            if ([x isEqualToString:@"login"]) {
                [KKRouter pushUri:LoginVCString];
            }else
            {
                [KKRouter pushUri:RegisterVCString];
            }
        }];
    }
    return _noLoginHeaderView;
}
#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self titleArr] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self titleArr][section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![cell conformsToProtocol:@protocol(KKViewDelegate)]) return cell;
    //需要显示状态
    NSNumber * needStatus;
    if (indexPath.section == 0 && indexPath.row ==0) {
        needStatus = @(YES);
    }else
    {
        needStatus = @(NO);
    }
    //是不是最后一个
    BOOL islast = indexPath.row == [[self titleArr][indexPath.section] count]-1;
    if (indexPath.section == [self titleArr].count-1) {
        islast = NO;
    }
    //status
    NSString * status = [NSString stringWithFormat:@"%@",self.model.userIdentified];
    id data;
    data = RACTuplePack([self titleArr][indexPath.section][indexPath.row],[self iconArr][indexPath.section][indexPath.row],needStatus,status,@(islast));
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
    return 12;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    view.backgroundColor = KKHexColor(F5F6F7);
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section !=2) {
        if (![UserManager manager].token.length) {
            [KKRouter pushUri:LoginVCString];
            return;
        }
    }
    [KKRouter pushUri:[self routerArr][indexPath.section][indexPath.row]];
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clickMessageBtn
{
    if (![UserManager manager].token.length) {
        [KKRouter pushUri:LoginVCString];
        return;
    }
    [KKRouter pushUri:@"MessageCenterViewController"];
}
-(void)clickSettingBtn
{
    [KKRouter pushUri:@"SettingViewController"];
}

-(NSArray *)iconArr
{
    return @[@[@"mine_identify"],@[@"mine_borrow",@"mine_loan"],@[@"mine_help",@"mine_about"]];
}
-(NSArray *)titleArr
{
    return @[@[@"身份信息"],@[@"我的借币",@"我的出借"],@[@"帮助中心",@"关于我们"]];
}
-(NSArray *)routerArr
{
    return @[@[@"IndentifyViewController"],@[@"MyBorrowViewController",@"MyLoanViewController"],@[@"HelpCenterViewController",@"AboutUsViewController"]];
}

-(void)requestData
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(nil).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            self.model = [MineHomeModel modelWithJSON:result.data];
            [self.loginHeaderView viewAction](self.model);
            [self.messageBtn setImage:(self.model.unreadMessages ? KKImage(@"mine_messageIcon"):KKImage(@"mine_no_messageIcon"))forState:UIControlStateNormal];
            [self.tableView reloadData];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
@end
