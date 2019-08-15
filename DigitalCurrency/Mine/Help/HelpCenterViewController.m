//
//  HelpCenterViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/8.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "UtMultbleSegement.h"
#import "HelpListViewController.h"
#import "HelpCenterModel.h"
@interface HelpCenterViewController ()<UtMultbleSegementDelegate>

@property (nonatomic, strong)UtMultbleSegement *segementView;

@property (nonatomic, strong)UIViewController *showingController;

@property (nonatomic, assign) NSInteger currenttype;

//
@property (nonatomic, strong) NSArray * dataArr;

#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation HelpCenterViewController

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
    self.kkHairlineHidden = YES;
    self.kkBarColor = [UIColor whiteColor];
    self.view.backgroundColor = KKHexColor(ffffff);
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;//默认是UIRectEdgeAll
    // Do any additional setup after loading the view.
    self.title = @"帮助中心";
    // Do any additional setup after loading the view.

    _currenttype = 0;
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

#pragma mark - View
///=============================================================================
/// @name addViews
///=============================================================================
- (void)addViews {
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UtMultbleSegement *)segementView
{
    if (!_segementView) {
        _segementView = [UtMultbleSegement createSegementWithStyle:UtMultbleSegementStyleDefault];
        _segementView.delegate = self;
//        [_segementView setTitlesArr:@[@"持有中", @"已回款", @"全部出借"] withDefaultIndex:self.currenttype];
        [self.view addSubview:_segementView];
    }
    return _segementView;
}



#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================
- (void)ut_multbleSegement:(UtMultbleSegement *)segement clickedBtnWithIndex:(NSInteger)index {
    
    _currenttype = index;
    [self.showingController.view removeFromSuperview];
    [self.childViewControllers[index] view].frame = CGRectMake(0, self.segementView.y + self.segementView.height, SCREEN_WIDTH, SCREEN_HEIGHT - (self.segementView.y + self.segementView.height) - 64);
    [self.view addSubview:[self.childViewControllers[index] view]];
    self.showingController = self.childViewControllers[index];
    
}



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
- (void)setInitView {
    
    [self.childViewControllers[self.currenttype] view].frame = CGRectMake(0, self.segementView.y + self.segementView.height, SCREEN_WIDTH, SCREEN_HEIGHT - (self.segementView.y + self.segementView.height-64));
    [self.view addSubview:[self.childViewControllers[self.currenttype] view]];
    self.showingController = self.childViewControllers[self.currenttype];
            
}

-(void)requestData
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code==1000) {
            self.dataArr = [result arrWithClass:@"HelpCenterModel"];
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
    NSMutableArray * titleArr = [NSMutableArray array];
    [self.dataArr enumerateObjectsUsingBlock:^(HelpCenterModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArr addObject:obj.issuesCategory];
        
        HelpListViewController * vc = [[HelpListViewController alloc]init];
        vc.listArray = obj.issuesContent;
        [self addChildViewController:vc];
    }];
    self.segementView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 51);
    [self.segementView setTitlesArr:titleArr withDefaultIndex:self.currenttype];
    [self setInitView];
}

@end
