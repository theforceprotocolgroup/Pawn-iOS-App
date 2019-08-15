//
//  LoanSuccessViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanSuccessViewController.h"
#import "LoanSuccessModel.h"
#import "LoanSuccessView.h"
@interface LoanSuccessViewController ()
//
@property (nonatomic, strong) LoanSuccessView * successView;
//
@property (nonatomic, strong) UIButton * withDrawBtn;
//
@property (nonatomic, strong) UIButton * nextBtn;
//
@property (nonatomic, strong) LoanSuccessModel * model;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation LoanSuccessViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(id)tuple {
    self.model = [LoanSuccessModel modelWithJSON:tuple];

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
    self.kkBarHidden = YES;
    self.kkLeftBarItemHidden= YES;
    self.view.backgroundColor = KKHexColor(f5f6f7);
    self.kkDistanceToLeftEdge = 0.01f;
    [self addViews];    // Do any additional setup after loading the view.
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
    [self.view addSubview:self.successView];
    [self.view addSubview:self.withDrawBtn];
    [self.view addSubview:self.nextBtn];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_successView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.equalTo(self.view);
    }];
    [_withDrawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view).offset(43);
        make.top.equalTo(self.successView.mas_bottom).offset(32);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo((SCREEN_WIDTH - 43 * 2 - 20)/2.0f);
    }];
    [_nextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.view).offset(-43);
        make.top.equalTo(self.successView.mas_bottom).offset(32);
        make.height.mas_equalTo(44);
        make.width.equalTo(self.withDrawBtn);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(LoanSuccessView *)successView
{
    if (!_successView) {
        _successView = [LoanSuccessView viewWithModel:self.model action:^(id  _Nullable x) {
            
        }];
    }
    return _successView;
}

-(UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setBackgroundColor:KKHexColor(5170EB)];
        [_nextBtn setTitleColor:KKHexColor(ffffff) forState:UIControlStateNormal];
        _nextBtn.layer.cornerRadius = 22;
        _nextBtn.layer.shadowColor = [UIColor colorWithRed:68/255.0 green:112/255.0 blue:228/255.0 alpha:0.29].CGColor;
        _nextBtn.layer.shadowOffset = CGSizeMake(0,3);
        _nextBtn.layer.shadowOpacity = 1;
        _nextBtn.layer.shadowRadius = 6;
        [_nextBtn setTitle:@"再次出借" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = KKCNFont(15);
        [_nextBtn addTarget:self action:@selector(clickedNextBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
-(UIButton *)withDrawBtn
{
    if (!_withDrawBtn) {
        _withDrawBtn = [[UIButton alloc]init];
        _withDrawBtn.kkButtonType = KKButtonTypePriHollow;
        _withDrawBtn.layer.cornerRadius = 22;
        _withDrawBtn.layer.masksToBounds = YES;
        [_withDrawBtn setTitle:@"出借详情" forState:UIControlStateNormal];
        _withDrawBtn.titleLabel.font = KKCNFont(15);
        [_withDrawBtn addTarget:self action:@selector(clickedWithDrawBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _withDrawBtn;
}



#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickedNextBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)clickedWithDrawBtn
{
    [KKRouter pushUri:[NSString stringWithFormat:@"%@/MyLoanDetailViewController",LoanVCString] params:self.model.orderID];
}



#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================




#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================





@end
