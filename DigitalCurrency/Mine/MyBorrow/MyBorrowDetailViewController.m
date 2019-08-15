//
//  MyBorrowDetailViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyBorrowDetailViewController.h"
#import "MyBorrowDetailModel.h"
#import "MyBorrowDetailView.h"
#import "MyBorrowDetailBottomView.h"
#import "MyBorrowMergeView.h"
#import "ResultPopView.h"
#import "RechargePopView.h"
@interface MyBorrowDetailViewController ()

#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;
//
@property (nonatomic, strong) UIScrollView * scrollView;
//
@property (nonatomic, strong) UIView * scrollContentView;
//
@property (nonatomic, strong) MyBorrowDetailView * detailView;
//
@property (nonatomic, strong) MyBorrowDetailBottomView * bottomView;
//
@property (nonatomic, strong) MyBorrowMergeView * mergeView;
//
@property (nonatomic, strong) UILabel * tipsLabel;
//
@property (nonatomic, strong) UIButton * cancelBtn;
//
@property (nonatomic, strong) MyBorrowDetailModel * model;
//
@property (nonatomic, strong) PopValidCode * validCode;
//
@property (nonatomic, strong) PopValidCode * coverValidCode;
//
@property (nonatomic, strong) NSString * code;
//
@property (nonatomic, strong) NSString * coverCode;
@end

@implementation MyBorrowDetailViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(NSString *)tuple {
    self.orderID = tuple;
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
    self.kkLeftBarItemHidden= NO;
    self.kkBarColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = KKHexColor(F5F6F7);
    self.title = @"账单详情";
    [self addViews];
    [self requestData];
//    [self test];
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
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat height = SCREEN_HEIGHT-Height_NavBar;
    if ([_model.status isEqualToString:@"2"]) {
        height = height - 64;
    }
    if (self.scrollView.contentSize.height < SCREEN_HEIGHT) {
        self.scrollView.contentSize = ({
            CGSize size = self.scrollView.contentSize;
            size.height = height;
            size;
        });
    }
}
#pragma mark - View
///=============================================================================
/// @name addViews
///=============================================================================
- (void)addViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollContentView addSubview:self.detailView];
    [self.scrollContentView addSubview:self.mergeView];
    [self.view addSubview:self.bottomView];
    [self.scrollContentView addSubview:self.tipsLabel];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [_scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.greaterThanOrEqualTo(self.scrollView);
    }];
    [_detailView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.scrollContentView);
    }];
    [_mergeView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.scrollContentView);
        make.top.equalTo(self.detailView.mas_bottom).offset(12);
    }];
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    [_tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.scrollContentView);
        make.bottom.equalTo(self.scrollContentView.mas_bottom).offset(-6);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(MyBorrowDetailView *)detailView
{
    if (!_detailView) {
        _detailView = [MyBorrowDetailView viewWithModel:nil action:^(id  _Nullable x) {
            
        }];
    }
    return _detailView;
}

-(UIView *)scrollContentView
{
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc]init];
        _scrollContentView.backgroundColor = KKHexColor(F5F6F7);
        _scrollContentView.userInteractionEnabled = YES;
    }
    return _scrollContentView;
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        adjustsScrollViewInsets(_scrollView);
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
-(MyBorrowDetailBottomView *)bottomView
{
    if (!_bottomView) {
        @weakify(self);
        _bottomView = [MyBorrowDetailBottomView viewWithModel:nil action:^(RACTuple*  _Nullable x) {
            @strongify(self);
            if ([x.second isEqualToString:@"recharge"]) {
                [self requestCoverRecharge];
            }else if ([x.second isEqualToString:@"repay"])
            {
                [self requestConfirm];
            }
        }];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}
-(MyBorrowMergeView *)mergeView
{
    if (!_mergeView) {
        @weakify(self);
        _mergeView = [MyBorrowMergeView viewWithModel:nil action:^(NSNumber *  _Nullable x) {
            @strongify(self);
            if (x.boolValue) {
                //deploy
                [self deploy];
            }else
            {
                //retract
                [self retract];
            }
        }];
        _mergeView.hidden = YES;
    }
    return _mergeView;
}
-(UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}
-(UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setTitle:@"取消借币"forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:KKHexColor(4470E4) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = KKCNFont(15);
        [_cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickCancelBtn
{
    KKAlertAction *  sureAction = [KKAlertAction action].title(@"再想一想").textColor(KKHexColor(4470E4)).handler(^(id x){
    });
    KKAlertAction *  cancel = [KKAlertAction action].title(@"确定").textColor(KKHexColor(435061)).handler(^(id x){
        [self requestCancel];
    });
    [KKAlertActionView alert].message(@"您确定要取消借币，不再募集？").addActions(@[cancel,sureAction]).show(self);
}
-(void)deploy
{
    @weakify(self);

    [self.mergeView deploy];
    [self.scrollContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(self.mergeView.mas_bottom).offset(56);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView layoutSubviews];
    }];
}
-(void)retract
{
    @weakify(self);

    [self.mergeView retract];
    [self.scrollContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.equalTo(self.scrollView);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView layoutSubviews];
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
-(void)test{
    _model = [MyBorrowDetailModel modelWithJSON:@{
                                                  @"orderID":@"LOAN3255974",
                                                  @"status":@"2", //1:持有中2:已回款3:已结清4:借贷失败
                                                  @"createdTime":@"2018-11-11 08:00:00",
                                                  @"investedTime":@"2018-11-11 09:00:00",
                                                  @"repaymentExpectedTime":@"2018-11-18 08:00:00",//预期回款日
                                                  @"repaymentActualTime":@"2018-11-18 08:00:00",//实际回款日期
                                                  @"borrowTokenCount":@"100.00000000",
                                                  @"borrowTokenType":@"BTC",
                                                  @"dailyRate":@"0.1",
                                                  @"fee":@"0.1",
                                                  @"loanDeadline":@"2018.12.11",  //借据有效截止时间
                                                  @"interestCount":@"0.03000000",//去除本金的收益
                                                  @"expected":@"0.03000000",//带本金的总收益,
                                                  @"repaymentStatus":@"正常还款", //还款方式
                                                  @"failureReason":@"借币失败原因",
                                                  @"closeStatus":@(YES), //true:达到警戒线false未达到
                                                  @"coverPositionDateBefore":@"2018.11.12",
                                                  @"coverPositionCount":@"0.02000000",
                                                  @"precautiousLine":@"0.00300000",  //质押预警线（带币种）
                                                  @"offsetLine":@"0.00300000", //质押平仓线（带币种）
                                                  @"coverPositionTips":@"逾期平仓说明xxxxxxxxxxx",
                                                  @"mrgeCount":@"100000000.000",
                                                  @"mrgeTokenType":@"ETH"
                                                  }
              ];
    [self reloadData];
}
-(void)requestData
{
    NSDictionary * dic;
    dic = @{@"orderID":self.orderID};
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            self.model = [MyBorrowDetailModel modelWithJSON:result.data];
            [self reloadData];
        }else
        {
            
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)reloadData
{

    [self.detailView viewAction](RACTuplePack(_model));
    [self.mergeView viewAction](RACTuplePack(_model));
    if ([_model.status isEqualToString:@"2"]) {
        //待还款
        [self.bottomView viewAction](_model);
        self.bottomView.hidden = NO;
        self.mergeView.hidden = NO;
        @weakify(self);
        [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top).priorityHigh();
        }];
        if (_model.reachPreCautiousLine)
        {
            NSString * temp = [NSString stringWithFormat:@"质押币价值已达到预警线，为避免您的损失\n%@",_model.tips];
            NSMutableAttributedString * attText = [NSMutableAttributedString string:temp];
            [attText addAttribute:NSForegroundColorAttributeName value:KKHexColor(041E45) range:NSMakeRange(0, 19)];
            [attText addAttribute:NSForegroundColorAttributeName value:KKHexColor(E84A55) range:NSMakeRange(20,temp.length - 20)];
            [attText addAttribute:NSFontAttributeName value:KKCNFont(11) range:NSMakeRange(0,temp.length)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 4.0f;
            paragraphStyle.lineBreakMode = _tipsLabel.lineBreakMode;
            paragraphStyle.alignment = _tipsLabel.textAlignment;
            [attText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [temp length])];

            _tipsLabel.attributedText = attText;
            _tipsLabel.numberOfLines = 0;
            _tipsLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
        }else
        {
            _tipsLabel.text = @"";
        }
    }else if ([_model.status isEqualToString:@"1"]) {
        //募集中
        self.tipsLabel.text = @"您的借币申请正在募集中，募集成功后将自动打款至您的钱包";
        self.tipsLabel.font = KKCNFont(11);
        self.tipsLabel.textColor = KKHexColor(C7CED9);
        @weakify(self);
        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.detailView.mas_bottom).offset(12);
        }];
        [self.scrollContentView addSubview:self.cancelBtn];
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.scrollContentView);
            make.bottom.equalTo(self.scrollContentView.mas_bottom).offset(-30);
        }];
        [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).priorityHigh();
        }];
        self.bottomView.hidden = YES;
        self.mergeView.hidden = YES;
    }else //结清和失败
    {
        @weakify(self);
        [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).priorityHigh();
        }];
        self.bottomView.hidden = YES;
        self.mergeView.hidden = YES;
        //逾期平仓
        if ([_model.repaymentStatus isEqualToString:@"3"]) {
            self.tipsLabel.text = @"逾期平仓结算时，按市场价扣除账单相应金额后，剩余金额已返还至 您的账户";
            self.tipsLabel.font = KKCNFont(11);
            self.tipsLabel.textColor = KKHexColor(C7CED9);
            self.tipsLabel.numberOfLines = 0;
            self.tipsLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
            @weakify(self);
            [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.centerX.equalTo(self.view);
                make.top.equalTo(self.detailView.mas_bottom).offset(12);
                make.left.equalTo(self.view).offset(15);
                make.right.equalTo(self.view).offset(-15);
            }];
        }
    }


    [self.view setNeedsUpdateConstraints];
}

-(void)requestCoverRecharge
{
    NSDictionary * dic;
    dic = @{@"orderID":self.orderID,@"userID":[UserManager manager].userid};
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000)
        {
            //余额充足
            if (!self.coverValidCode) {
                self.coverValidCode = [PopValidCode showWithTitle:@"确认补仓" superView:nil action:^(RACTuple*  _Nullable x) {
                    if ([x.first isEqualToString:@"code"]) {
                        [self requestConfirm];
                    }else if([x.first isEqualToString:@"check"])
                    {
                        self.coverCode = x.second;
                        [self requestCoverCheckCode];
                    }
                }];
                [self.coverValidCode show];
            }else
            {
                [self.coverValidCode startTimer];
            }
        }
        else if (result.code == 1601)
        {
            ResultPopView * popView = [ResultPopView showWithSurperView:self.tabBarController.view withAction:^(RACTuple *  _Nullable x) {
                if ([x.first isEqualToString:@"0"]) {
                    [[RechargePopView showWithSurperView:self.navigationController.view withModel:RACTuplePack(self.model.mrgeTokenType,self.model.mrgeTokenAddress) withAction:^(RACTuple*  _Nullable x) {
                        if ([x.first isEqualToString:@"0"]) {
                            [self.view kk_makeToast:@"复制成功"];
                        }
                    }]show];
                }
            }];
            popView.type = ResultTypeNoEnough;
            popView.status = @"余额不足";
            popView.content = result.data[@"tokenBalanceInfo"];
            popView.btnArr = @[@"取消",@"去充值"];
            [popView show];
        }
        else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)requestCoverCheckCode
{
    NSDictionary * dic;
    dic = @{@"orderID":self.orderID,@"code":self.coverCode};
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            [self.coverValidCode dismiss];
            [self requestData];
        }else
        {
            [self.coverValidCode showErrorMessage:result.message];
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
//发送还款验证码
-(void)requestConfirm
{
    @weakify(self);
    NSDictionary * dic = @{
                           @"orderID":self.orderID,
                           };
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            if (!self.validCode) {
                self.validCode = [PopValidCode showWithTitle:@"确认还款" superView:nil action:^(RACTuple*  _Nullable x) {
                    if ([x.first isEqualToString:@"code"]) {
                        [self requestConfirm];
                    }else if([x.first isEqualToString:@"check"])
                    {
                        self.code = x.second;
                        [self requestCheckCode];
                    }
                }];
                [self.validCode show];
            }else
            {
                [self.validCode startTimer];
            }
        }else if (result.code == 1601)
        {
            ResultPopView * popView = [ResultPopView showWithSurperView:self.tabBarController.view withAction:^(RACTuple *  _Nullable x) {
                if ([x.first isEqualToString:@"0"]) {
                    [[RechargePopView showWithSurperView:self.navigationController.view withModel:RACTuplePack(self.model.borrowTokenType,self.model.borrowTokenAddress) withAction:^(RACTuple*  _Nullable x) {
                        if ([x.first isEqualToString:@"0"]) {
                            [self.view kk_makeToast:@"复制成功"];
                        }
                    }]show];
                }
            }];
            popView.type = ResultTypeNoEnough;
            popView.status = @"余额不足";
            popView.content = result.data[@"tokenBalanceInfo"];
            popView.btnArr = @[@"取消",@"去充值"];
            [popView show];
        }
        else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)requestCheckCode
{
    NSDictionary * dic;
    dic = @{@"orderID":self.orderID,@"code":self.code,@"phoneNumber":[UserManager manager].username};
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            [self.validCode dismiss];
            [KKRouter pushUri:@"MyBorrowRepaymentViewController" params:result.message];
        }else
        {
            [self.validCode showErrorMessage:result.message];
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
//取消订单
-(void)requestCancel
{
    NSDictionary * dic;
    dic = @{@"orderID":self.orderID};
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(dic).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            [self.view kk_makeToast:result.message];
            [self.navigationController popViewControllerAnimated:YES];
        }else if (result.code == 2000)
        {
            [KKAlertActionView alert].message(result.message).addActions(@[[KKAlertAction action].title(@"查看详情").textColor(KKHexColor(4470E4)).handler(^(id x){
                [self requestData];
            })]).show(self);
        }
        else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
@end
