//
//  BorrowHomwPageViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/12.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowHomwPageViewController.h"
#import "BorrowHomePageTableViewCell.h"
#import "TokenModel.h"
#import "PopListView.h"
#import "PopSliderView.h"
#import "GuidePage.h"
#import "BorrowHomeRequestModel.h"
#import "BorrowHomeViewModel.h"
#import "RechargePopView.h"
#import "ResultPopView.h"
#import "ProtocolModel.h"
@interface BorrowHomwPageViewController ()<UITableViewDelegate,UITableViewDataSource,KKViewDelegate>
//
@property (nonatomic, strong) UIImageView * bgImageView;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * subTitleLabel;
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) UIButton * actionBtn;
//
@property (nonatomic, strong) UILabel * protocolLabel;
//
@property (nonatomic, strong) UIButton * protocolBtn;
//
@property (nonatomic, strong) UIView * protocolView;
//
@property (nonatomic, strong) PopListView * popListView;
//
@property (nonatomic, strong) PopSliderView * popSliderView;
//
//@property (nonatomic, strong) UIButton * testBtn;
//
@property (nonatomic, strong) GuidePage * guidePage;

//
@property (nonatomic, strong) BorrowHomeViewModel * viewModel;
//
@property (nonatomic, assign) float rate;
//
@property (nonatomic, assign) NSInteger dateIndex;
//
@property (nonatomic, strong) BorrowHomeRequestModel * requestModel;
//
@property (nonatomic, strong) TokenModel * borrowModel;
//
@property (nonatomic, strong) TokenModel * mrgeModel;
//
@property (nonatomic, assign) BOOL isshow;
//
@property (nonatomic, strong) PopValidCode * code ;
//
@property (nonatomic, strong) NSMutableArray * borrowProtocols;
@end

@implementation BorrowHomwPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kkHairlineHidden = YES;
    self.kkBarHidden = YES;
    self.kkLeftBarItemHidden= YES;
    self.view.backgroundColor = KKHexColor(ffffff);
    // Do any additional setup after loading the view.

    [self configData];
    [self addViews];
    [self autoDismissKeyboard];
    if ([GuidePage isFirstLaunch]) {
        [self.tabBarController.view addSubview:self.guidePage];
        @weakify(self);
        [self.guidePage mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.left.right.bottom.equalTo(self.tabBarController.view);
        }];
        [GuidePage setLaunched];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
#pragma mark - View
///=============================================================================
/// @name addViews
///=============================================================================
- (void)addViews {
    [self.view addSubview:self.bgImageView];
    
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.subTitleLabel];
    [self.bgImageView addSubview:self.tableView];
//    [self.bgImageView addSubview:self.testBtn];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.bottom.equalTo(self.view);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.bgImageView).offset(40+Height_StatusBar);
        make.left.equalTo(self.bgImageView).offset(17);
    }];
    [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
    }];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.bgImageView).offset(15);
        make.right.equalTo(self.bgImageView).offset(-15);
        make.height.mas_equalTo(400);
    }];
//    [_testBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.bgImageView).offset(-20);
//        make.height.width.equalTo(@(50));
//        make.top.equalTo(self.bgImageView).offset(40);
//    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:KKImage(@"borrow_home_bg")];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNBFont(32);
        _titleLabel.textColor = KKHexColor(465062);
        _titleLabel.text = @"币币贷";
    }
    return _titleLabel;
}
-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = KKCNFont(13);
        _subTitleLabel.textColor = KKHexColor(465062);
        _subTitleLabel.text = @"C2C数字资产借贷服务";
    }
    return _subTitleLabel;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =KKHexColor(ffffff);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        adjustsScrollViewInsets(_tableView);
        [_tableView registerClass:NSClassFromString(@"BorrowHomePageTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];
        _tableView.layer.cornerRadius = 5;
        _tableView.layer.masksToBounds = YES;
    }
    return _tableView;
}

-(UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc]init];
        _actionBtn.kkButtonType = KKButtonTypePriSolid;
        [_actionBtn setTitle:@"我要借币" forState:UIControlStateNormal];
        _actionBtn.titleLabel.font = KKCNFont(15);
        [_actionBtn addTarget:self action:@selector(clickActionButton) forControlEvents:UIControlEventTouchUpInside];
        _actionBtn.enabled = NO;
    }
    return _actionBtn;
}
//-(UIButton *)testBtn
//{
//    if (!_testBtn) {
//        _testBtn = [[UIButton alloc]init];
//        [_testBtn setTitle:@"测试" forState:UIControlStateNormal];
//        [_testBtn setBackgroundColor:KKHexColor(E0E0E0)];
//        [_testBtn setTitleColor:KKHexColor(999999) forState:UIControlStateNormal];
//        [_testBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _testBtn;
//}
-(GuidePage *)guidePage
{
    if (!_guidePage) {
        @weakify(self);
        _guidePage = [GuidePage initializeGuidePageView:^{
            @strongify(self);
            [self requestData];
        }];
    }
    return _guidePage;
}
-(NSMutableArray *)borrowProtocols
{
    if (!_borrowProtocols) {
        _borrowProtocols = [[NSMutableArray alloc]init];
    }
    return _borrowProtocols;
}
-(UIView *)protocolView
{
    if (!_protocolView) {
        _protocolView = [[UIView alloc]init];
        _protocolView.userInteractionEnabled = YES;
        _protocolView.backgroundColor = [UIColor whiteColor];
    }
    return _protocolView;
}
-(UILabel *)protocolLabel
{
    if (!_protocolLabel) {
        _protocolLabel = [[UILabel alloc]init];
        _protocolLabel.font = KKCNFont(11);
        _protocolLabel.textColor = KKHexColor(C7CED9);
        _protocolLabel.text = @"点击我要借币即表示已阅读并同意";
    }
    return _protocolLabel;
}
-(UIButton *)protocolBtn
{
    if (!_protocolBtn) {
        _protocolBtn = [[UIButton alloc]init];
        [_protocolBtn setTitle:@"《借贷服务协议》" forState:UIControlStateNormal];
        [_protocolBtn setTitleColor:KKHexColor(5170EB) forState:UIControlStateNormal];
        _protocolBtn.titleLabel.font = KKCNFont(11);
        [_protocolBtn kkExtendHitTestSizeByWidth:100 height:100];
        [_protocolBtn addTarget:self action:@selector(clickProtocolButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolBtn;
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
    return self.viewModel.borrowCellArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![cell conformsToProtocol:@protocol(KKViewDelegate)]) return cell;
    
    id data;
    id model = self.viewModel.borrowCellArr[indexPath.row];
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 95)];
    [view addSubview:self.actionBtn];
    [view addSubview:self.protocolView];
    [self.protocolView addSubview:self.protocolLabel];
    [self.protocolView addSubview:self.protocolBtn];
    @weakify(self);
    [_protocolView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.actionBtn.mas_top).offset(-10);
        make.centerX.equalTo(view);
    }];
    [_protocolLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.protocolView);
        make.left.equalTo(self.protocolView);
        make.top.bottom.equalTo(self.protocolView);
    }];
    [_protocolBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.protocolView);
        make.left.equalTo(self.protocolLabel.mas_right).offset(5);
        make.right.equalTo(self.protocolView.mas_right);
    }];
    [self.actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(32);
        make.left.equalTo(view).offset(25);
        make.right.equalTo(view).offset(-25);
        make.height.mas_equalTo(44);
    }];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            @weakify(self);
            [[KKRouter pushUri:@"TokenListViewController" params:RACTuplePack(@(0),self.requestModel.mrgeType)  navi:self.navigationController] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                @strongify(self);
                self.borrowModel = t.result;
                BorrowHomePageTableViewModel * viewmodel = self.viewModel.borrowCellArr[indexPath.row];
                viewmodel.content = self.borrowModel;
                self.requestModel.borrowType = self.borrowModel.tokenID;
                [self.tableView reloadData];
                [self checkBtnEnable];
                return nil;
            }];
        }   break;
        case 1:
            break;
        case 2:
            if (!_popSliderView) {
                @weakify(self);
                _popSliderView = [PopSliderView showWithTitle:@"设置日利率" valueArr:self.viewModel.rateArr superView:nil action:^(NSNumber *  _Nullable x) {
                    @strongify(self);
                    float num = x.floatValue;
                    BorrowHomePageTableViewModel * viewmodel = self.viewModel.borrowCellArr[indexPath.row];
                    viewmodel.content = [NSString stringWithFormat:@"%.2f%%",num];
                    self.requestModel.rate = [NSString stringWithFormat:@"%.2f",num];
                    [self.tableView reloadData];
                    [self checkBtnEnable];
                }];
            }
            [_popSliderView show];
            break;
        case 3:{
            @weakify(self);
            [[KKRouter pushUri:@"TokenListViewController" params:RACTuplePack(@(1),self.requestModel.borrowType)  navi:self.navigationController] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
                @strongify(self);
                self.mrgeModel = t.result;
                BorrowHomePageTableViewModel * viewmodel = self.viewModel.borrowCellArr[indexPath.row];
                viewmodel.content = self.mrgeModel;
                self.requestModel.mrgeType = self.mrgeModel.tokenID;
                [self.tableView reloadData];
                [self checkBtnEnable];
                return nil;
            }];
        }break;
        case 4:
        {
            NSMutableArray * arr = [NSMutableArray array];
            [self.viewModel.intervalArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PopListViewModel * model = [[PopListViewModel alloc]init];
                model.title = obj[@"interval"];
                [arr addObject:model];
            }];
            if (!_popListView) {
                @weakify(self);
                _popListView = [PopListView showWithTitle:@"选择借币期限" content:arr superView:nil action:^(RACTuple *  _Nullable x) {
                    @strongify(self);
                    RACTupleUnpack(PopListViewModel * model , NSNumber * selectedIndex) = x;
                    BorrowHomePageTableViewModel * viewmodel = self.viewModel.borrowCellArr[indexPath.row];
                    viewmodel.content = [NSString stringWithFormat:@"%@天",model.title];
                    [self.tableView reloadData];
                    self.dateIndex = selectedIndex.integerValue;
                    self.requestModel.interval = self.viewModel.intervalArr[self.dateIndex][@"id"];
                    [self checkBtnEnable];
                }];
            }
            [_popListView show];
        }    break;
        default:
            break;
    }
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickProtocolButton
{
    NSMutableArray * temArr = [NSMutableArray array];
    [self.borrowProtocols enumerateObjectsUsingBlock:^(ProtocolModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KKAlertAction *action = [KKAlertAction action].title(obj.protocolName).handler(^ (UIAlertAction* x){
            [KKRouter pushUri:obj.protocolHref];
        });
        [temArr addObject:action];
    }];
    [temArr addObject:[KKAlertAction cancelAction]];
    [KKAlertActionView alert].style(UIAlertControllerStyleActionSheet).addActions(temArr).show(self);
}
-(void)clickActionButton
{
    if (_requestModel.count.doubleValue > self.borrowModel.maxAvaliableBorrowCount.doubleValue) {
        [self.view kk_makeToast:@"借币数量超过最大可借额度"];
        return;
    }
    if (_requestModel.count.doubleValue < self.borrowModel.minAvaliableBorrowCount.doubleValue) {
        [self.view kk_makeToast:@"借币数量不得小于最小可借额度"];
        return;
    }
    if (![UserManager manager].token.length) {
        [KKRouter pushUri:LoginVCString];
        return;
    }
    [self requestConfirm];
}

-(void)test{
//    [[RechargePopView showWithSurperView:self.navigationController.view withModel:RACTuplePack(@"BTC",@"osodfjsaofjaofjosdfiajdfa") withAction:^(id  _Nullable x) {
//
//    }]show];
//    ResultPopView * popView = [ResultPopView showWithSurperView:self.tabBarController.view withAction:^(id  _Nullable x) {
//
//    }];
//    popView.type = ResultTypeFailed;
//    popView.status = @"借币未成功";
//    popView.content = @"账户余额不足";
//    popView.btnArr = @[@"去充值"];
//    [popView show];
//
//    if (!_isshow) {
//        @weakify(self);
//        _code = [PopValidCode showWithTitle:@"确认支付" superView:nil action:^(RACTuple*  _Nullable x) {
//            @strongify(self);
//            if ([x.first isEqualToString:@"check"]) {
//                self.isshow = YES;
//            }else
//            {
//                [self.code showErrorMessage:@"keke"];
//                self.isshow = NO;
//
//            }
//        }];
//        [_code show];
//    }else
//    {
//        [_code startTimer];
//    }
   
//    @weakify(self);
//    [[KKRequest jsonRequest].urlString(@"").paramaters(@{@"noticeID":@"notice140"}).needCustomFormat(YES).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
//        @strongify(self);
//        if (result.code == 1000) {
//
//        }else
//        {
//            [self.view kk_makeToast:result.message];
//        }
//        return nil;
//    }];
//    BorrowSuccessViewController
//      [KKRouter pushUri:@"MyBorrowDetailViewController" params:@""];
//        [KKRouter pushUri:@"LoanSuccessViewController" params:@{
//            @"orderID":@"loan165684",
//            @"investedCount":@"100.00000000",
//            @"investedTokenType":@"BTC",
//            @"investInfoDetail":@[
//                         @{
//                             @"title":@"还款数额",
//                             @"content":@"3000.00000000"
//                         },
//                         @{
//                             @"title":@"借币类型",
//                             @"content":@"BTC"
//                         },
//                         @{
//                             @"title":@"利息与服务费",
//                             @"content":@"0.10000000"
//                         },
//                         @{
//                             @"title":@"折合美元",
//                             @"content":@"300.000"
//                         },
//                         @{
//                             @"title":@"到账数额",
//                             @"content":@"299.00000000"
//                         },
//                         @{
//                             @"title":@"还款日期",
//                             @"content":@"20180101"
//                         }
//                         ],
//            @"tips":@"预计24小时转入您的钱包"
//        }
//         ];
    [KKRouter pushUri:@"BorrowSuccessViewController" params:@{
        @"orderID":@"loan165684",
        @"borrowCount":@"100.00000000",
        @"borrowSymbol":@"BTC",
        @"repayInfo":@[
                     @{
                         @"title":@"还款数额",
                         @"content":@"3000.00000000"
                     },
                     @{
                         @"title":@"借币类型",
                         @"content":@"BTC"
                     },
                     @{
                         @"title":@"利息与服务费",
                         @"content":@"0.10000000"
                     },
                     @{
                         @"title":@"折合美元",
                         @"content":@"300.000"
                     },
                     @{
                         @"title":@"到账数额",
                         @"content":@"299.00000000"
                     },
                     @{
                         @"title":@"还款日期",
                         @"content":@"20180101"
                     }
                     ],
        @"tips":@"预计24小时转入您的钱包"
    }
     ];
//    [KKRouter pushUri:LoginVCString];MessageCenterViewController
//    [KKRouter pushUri:@"LoanConfirmViewController" params:RACTuplePack(@"f",@[])];
}
-(void)viewAction:(NSString *)x
{
    self.requestModel.count = x;
    BorrowHomePageTableViewModel * viewmodel = self.viewModel.borrowCellArr[1];
    viewmodel.content = x;
    [self checkBtnEnable];
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
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(nil).needCustomFormat(YES).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            self.viewModel.rateArr = result.data[@"rate"];
            self.viewModel.intervalArr = result.data[@"interval"];
            NSArray * tempArr = result.data[@"protocol"];
            if (tempArr.count) {
                [self.borrowProtocols removeAllObjects];
                [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ProtocolModel * model = [ProtocolModel modelWithJSON:obj];
                    if (model) {
                        [self.borrowProtocols addObject:model];
                    }
                }];
            }
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
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
            [KKRouter pushUri:@"BorrowConfirmViewController" params:RACTuplePack(self.viewModel,result.data,self.requestModel,self.borrowModel,self.mrgeModel)];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}

-(void)configData
{
    _requestModel = [[BorrowHomeRequestModel alloc]init];
    _viewModel = [[BorrowHomeViewModel alloc]init];
    
    NSArray * titleArr = @[@"借币种类",@"借币数量",@"日利率",@"质押币种",@"借币期限"];
    NSArray * iconArr = @[@"borrow_home_1",@"borrow_home_2",@"borrow_home_3",@"borrow_home_4",@"borrow_home_5"];
    NSArray * placeholderArr = @[@"请选择借币种类",@"请输入借币数量",@"请设置日利率",@"请选择质押币种",@"请选择借币期限"];
    NSArray * actionArr = @[@"tap",@"input",@"slider",@"tap",@"tap"];
    NSMutableArray * dataArr = [[NSMutableArray alloc]init];
    [titleArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BorrowHomePageTableViewModel * model = [[BorrowHomePageTableViewModel alloc]init];
        model.title = obj;
        model.icon = iconArr[idx];
        model.placeholder = placeholderArr[idx];
        model.actionType = actionArr[idx];
        [dataArr addObject:model];
    }];
    _viewModel.borrowCellArr = dataArr;
    
}

-(void)checkBtnEnable
{
    if (self.requestModel.borrowType.length && self.requestModel.mrgeType.length && self.requestModel.interval.length && self.requestModel.rate && self.requestModel.count.length) {
        self.actionBtn.enabled = YES;
    }else
    {
        self.actionBtn.enabled = NO;
    }
}

@end


