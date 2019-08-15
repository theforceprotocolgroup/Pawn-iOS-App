//
//  MyBorrowViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyBorrowViewController.h"
#import "UtMultbleSegement.h"

@interface MyBorrowViewController ()<UtMultbleSegementDelegate>


@property (nonatomic, strong)UtMultbleSegement *segementView;

@property (nonatomic, strong)UIViewController *showingController;

#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation MyBorrowViewController

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
    self.kkLeftBarItemHidden= NO;
    self.view.backgroundColor = KKHexColor(ffffff);
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;//默认是UIRectEdgeAll
    self.title = @"我的借币";
    self.segementView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 51);
    MyBorrowListViewController * vc1 = [[MyBorrowListViewController alloc]init];
    vc1.type = BorrowTypeAll;
    MyBorrowListViewController * vc2 = [[MyBorrowListViewController alloc]init];
    vc2.type = BorrowTypeRepaying;
    MyBorrowListViewController * vc3 = [[MyBorrowListViewController alloc]init];
    vc3.type = BorrowTypeWaiting;
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
    _currenttype = BorrowTypeAll;
    [self setInitView];
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
        [_segementView setTitlesArr:@[@"全部借币",@"还款中", @"募集中" ] withDefaultIndex:self.currenttype];
        [self.view addSubview:_segementView];
    }
    return _segementView;
}


#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================
- (void)ut_multbleSegement:(UtMultbleSegement *)segement clickedBtnWithIndex:(NSInteger)index {
    
    [self.showingController.view removeFromSuperview];
    
    if (index == 0) {
        
        [self.childViewControllers[0] view].frame = CGRectMake(0, self.segementView.y + self.segementView.height, SCREEN_WIDTH, SCREEN_HEIGHT - (self.segementView.y + self.segementView.height) - 64);
        [self.view addSubview:[self.childViewControllers[0] view]];
        self.showingController = self.childViewControllers[0];
        
    }else if (index == 1) {
        
        [self.childViewControllers[1] view].frame = CGRectMake(0, self.segementView.y + self.segementView.height, SCREEN_WIDTH, SCREEN_HEIGHT - (self.segementView.y + self.segementView.height) - 64);
        [self.view addSubview:[self.childViewControllers[1] view]];
        self.showingController = self.childViewControllers[1];
        
    }else {
        
        [self.childViewControllers[2] view].frame = CGRectMake(0, self.segementView.y + self.segementView.height, SCREEN_WIDTH, SCREEN_HEIGHT - (self.segementView.y + self.segementView.height));
        [self.view addSubview:[self.childViewControllers[2] view]];
        self.showingController = self.childViewControllers[2];
        
    }
    
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
    
    switch (self.currenttype) {
        case BorrowTypeAll: {
            
            [self.childViewControllers[0] view].frame = CGRectMake(0, self.segementView.y + self.segementView.height, SCREEN_WIDTH, SCREEN_HEIGHT - (self.segementView.y + self.segementView.height));
            [self.view addSubview:[self.childViewControllers[0] view]];
            self.showingController = self.childViewControllers[0];
            
        }
            break;
            
        case BorrowTypeRepaying: {
            
            [self.childViewControllers[1] view].frame = CGRectMake(0, self.segementView.y + self.segementView.height, SCREEN_WIDTH, SCREEN_HEIGHT - (self.segementView.y + self.segementView.height));
            [self.view addSubview:[self.childViewControllers[1] view]];
            self.showingController = self.childViewControllers[1];
            
        }
            break;
            
        case BorrowTypeWaiting: {
            
            [self.childViewControllers[2] view].frame = CGRectMake(0, self.segementView.y + self.segementView.height, SCREEN_WIDTH, SCREEN_HEIGHT - (self.segementView.y + self.segementView.height));
            [self.view addSubview:[self.childViewControllers[2] view]];
            self.showingController = self.childViewControllers[2];
            
        }
            break;
            
        default:
            break;
    }
}




@end
