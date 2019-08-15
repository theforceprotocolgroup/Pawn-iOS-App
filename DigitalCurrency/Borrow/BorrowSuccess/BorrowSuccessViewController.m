//
//  BorrowSuccessViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "BorrowSuccessViewController.h"
#import "BorrowSuccessView.h"
#import "BorrowSuccessModel.h"
@interface BorrowSuccessViewController ()
//
@property (nonatomic, strong) UIScrollView  * scrollView;
//
@property (nonatomic, strong) UIView * scrollContentView;
//
@property (nonatomic, strong) BorrowSuccessView * successView;
//
@property (nonatomic, strong) UIButton * withDrawBtn;
//
@property (nonatomic, strong) UIButton * nextBtn;
//
@property (nonatomic, strong) BorrowSuccessModel * model;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation BorrowSuccessViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(id)tuple {
    self.model = [BorrowSuccessModel modelWithJSON:tuple];
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
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.scrollView.contentSize.height < SCREEN_HEIGHT) {
        self.scrollView.contentSize = ({
            CGSize size = self.scrollView.contentSize;
            size.height = SCREEN_HEIGHT;
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

    [self.scrollContentView addSubview:self.successView];
    [self.scrollContentView addSubview:self.withDrawBtn];
    [self.scrollContentView addSubview:self.nextBtn];
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
//        make.height.greaterThanOrEqualTo(self.scrollView);
    }];
    [_successView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.equalTo(self.scrollContentView);
    }];
    [_withDrawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.scrollContentView).offset(43);
        make.top.equalTo(self.successView.mas_bottom).offset(32);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo((SCREEN_WIDTH - 43 * 2 - 20)/2.0f);
    }];
    [_nextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.scrollContentView).offset(-43);
        make.top.equalTo(self.successView.mas_bottom).offset(32);
        make.height.mas_equalTo(44);
        make.width.equalTo(self.withDrawBtn);
        make.bottom.equalTo(self.scrollContentView).offset(-30);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
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
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;

    }
    return _scrollView;
}
-(BorrowSuccessView *)successView
{
    if (!_successView) {
        _successView = [BorrowSuccessView viewWithModel:self.model action:^(RACTuple*  _Nullable x) {
            if ([x.first isEqualToString:@"push"]) {
                [KKRouter pushUri:[NSString stringWithFormat:@"%@/%@",BorrowVCString,x.second] params:self.model.orderID];
            }
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
        [_nextBtn setTitle:@"再借一笔" forState:UIControlStateNormal];
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
        [_withDrawBtn setTitle:@"查看详情" forState:UIControlStateNormal];
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
    [KKRouter pushUri:BorrowVCString];
}
-(void)clickedWithDrawBtn
{
    [KKRouter pushUri:[NSString stringWithFormat:@"%@/%@",BorrowVCString,@"MyBorrowDetailViewController"] params:self.model.orderID];
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
