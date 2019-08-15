//
//  MyBorrowRepaymentViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/17.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyBorrowRepaymentViewController.h"

@interface MyBorrowRepaymentViewController ()
//
@property (nonatomic, strong) UIView * headerView;
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * statusLabel;
//
@property (nonatomic, strong) UIButton * actionBtn;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation MyBorrowRepaymentViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(NSString *)tuple {
    self.titleLabel.text = tuple;
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
    self.kkBarHidden= YES;
    self.view.backgroundColor = KKHexColor(f5f6f7);
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.kkDistanceToLeftEdge = 0.01f;
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
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.icon];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.statusLabel];
    [self.view addSubview:self.actionBtn];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(220);
    }];
    [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.headerView).offset(47);
        make.centerX.equalTo(self.headerView);
        make.width.mas_equalTo(71);
        make.height.mas_equalTo(66);
    }];
    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.icon.mas_bottom).offset(15);
        make.centerX.equalTo(self.headerView);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(14);
        make.centerX.equalTo(self.headerView);
    }];
    [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.headerView.mas_bottom).offset(32);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc]init];
        _actionBtn.kkButtonType = KKButtonTypePriSolid;
        [_actionBtn setTitle:@"完成" forState:UIControlStateNormal];
        _actionBtn.titleLabel.font = KKCNFont(15);
        [_actionBtn addTarget:self action:@selector(clickActionButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}
-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithImage:KKImage(@"success_icon")];
    }
    return _icon;
}
-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = KKCNFont(16);
        _statusLabel.textColor = KKHexColor(1084F9);
        _statusLabel.text = @"还款成功 账单已结清";
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = KKHexColor(0C1E48);
        _titleLabel.font = KKCNBFont(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickActionButton
{
    NSInteger index = self.navigationController.viewControllers.count - 2;
    UIViewController * vc = self.navigationController.viewControllers[index];
    [self.navigationController popToViewController:vc animated:YES];
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
