//
//  BorrowIntroductionViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/21.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowIntroductionViewController.h"
#import "BorrowIntroductionHeaderView.h"
#import "BorrowIntroductionIMiddleView.h"
#import "BorrowIntroductionBottomView.h"
@interface BorrowIntroductionViewController ()
//
@property (nonatomic, strong) UIScrollView * scrollView;
//
@property (nonatomic, strong) UIView * scrollContentView;
//
@property (nonatomic, strong) NSMutableArray * progressArr;
//
@property (nonatomic, strong) NSArray * rulesArr;
//
@property (nonatomic, strong) NSString * rate;
//
@property (nonatomic, strong) NSMutableArray * contentViewArr;
//
@property (nonatomic, strong) NSArray * dataArr;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation BorrowIntroductionViewController

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
    self.title = @"服务介绍";
    self.view.backgroundColor = KKHexColor(ffffff);
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;//默认是UIRectEdgeAll
    // Do any additional setup after loading the view.
    _contentViewArr = [[NSMutableArray alloc]init];
    _progressArr = [[NSMutableArray alloc]init];
    [self addViews];
    [self requestData];
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
    [self addContainSubviews];
    [self updateLayout];
}
- (void)addContainSubviews {
    @weakify(self);
    
    [[self viewClasses]enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class cls = NSClassFromString(obj);
        if ([cls conformsToProtocol:@protocol(KKViewDelegate)]) {
            @strongify(self);
            UIView *view = [(id<KKViewDelegate>)cls viewWithModel:nil action:^(RACTuple *tuple) {
            }];
            if (view) {
                view.userInteractionEnabled = YES;
                [self.scrollContentView addSubview:view];
                [self.contentViewArr addObject:view];
            }
        }
    }];
}

- (NSArray<NSString *> *)viewClasses {
    return @[@"BorrowIntroductionHeaderView", @"BorrowIntroductionIMiddleView", @"BorrowIntroductionBottomView"];
}

- (CGFloat)height:(NSInteger)index {
    NSArray *arr =@[@0, @0, @0];
    return [arr[index] floatValue];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.bottom.equalTo(self.view);
    }];
    [_scrollContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.contentViewArr kkEachWithPreAndIndex:^(UIView*  _Nonnull obj, UIView*  _Nonnull preObj, NSUInteger idx) {
        @weakify(self);
        [obj mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(preObj?preObj.mas_bottom :self.scrollContentView.mas_top).offset(15);
            make.left.equalTo(self.scrollContentView.mas_left);
            make.right.equalTo(self.scrollContentView.mas_right);
            if ([self height:idx]) {
                make.height.equalTo(@([self height:idx]));
            }
            if (idx==(self.contentViewArr.count-1)) {
                make.bottom.equalTo(self.scrollContentView.mas_bottom);
            }
        }];
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
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}


#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================




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
-(NSArray *)iconArr{
    return @[@"introduction1",@"introduction2",@"introduction3",@"introduction4"];
}
-(void)requestData
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters(nil).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code == 1000) {
            NSArray * arr = result.data[@"processIntroduction"];
            [arr enumerateObjectsUsingBlock:^(NSArray *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * dic = @{@"title":obj,@"icon":[self iconArr][idx]};
                [self.progressArr addObject:dic];
            }];
            self.rate = result.data[@"rateIntroduction"][@"content"];
            self.rulesArr = result.data[@"exchangeRules"];
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
    self.dataArr = @[self.progressArr,self.rate,self.rulesArr];
    [_contentViewArr enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(id<KKViewDelegate>)obj viewAction](self.dataArr[idx]);
    }];
    [self.scrollView layoutSubviews];
}


@end
