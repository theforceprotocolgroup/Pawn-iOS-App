//
//  TokenListViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/18.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "TokenListViewController.h"
#import "TokenModel.h"
@interface TokenListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
//
@property (nonatomic, strong) NSMutableArray * dataArr;
//
@property (nonatomic, strong) UICollectionView * collectionView;

#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation TokenListViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(RACTuple * )tuple {
    RACTupleUnpack(NSNumber * type , NSString * parmaID) = tuple;
    self.type = [type integerValue];
    self.tokenType = parmaID;
    NSString * title ;
    switch (self.type) {
        case TokenListTypeBorrow:
            title = @"选择借贷币种";
            break;
        case TokenListTypeLoan:
            title = @"选择质押币种";
            break;
        case TokenListTypeWallet:
            title = @"选择币种";
            break;
        default:
            break;
    }
    self.title = title;
    self.type = type.integerValue;
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = KKHexColor(F5F6F7);
    [self addViews];
    _dataArr = [[NSMutableArray alloc]init];
//    [self test];
    // Do any additional setup after loading the view.
    switch (self.type) {
        case TokenListTypeBorrow:
            [self requestBorrowToken];
            break;
        case TokenListTypeLoan:
            [self requestLoanToken];
            break;
        case TokenListTypeWallet:
            [self requestWalletToken];
            break;
        default:
            break;
    }
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
    [self.view addSubview:self.collectionView];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout= [[UICollectionViewFlowLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsMake(20, 15, 15, 20);
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 15*2 -26)/2, 60);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:NSClassFromString(@"TokenListCollectionViewCell") forCellWithReuseIdentifier:@"TokenListCollectionViewCell"];
    }
    return _collectionView;
}


#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"TokenListCollectionViewCell" forIndexPath:indexPath];

    if (![cell conformsToProtocol:@protocol(KKViewDelegate)]) return cell;
    
    id data;
    id model = _dataArr[indexPath.row];
    data = RACTuplePack(model);
    @weakify(self);
    [(id<KKViewDelegate>)cell viewModel:data action:^(id _Nullable x) {
        @strongify(self);
        if ([self conformsToProtocol:@protocol(KKViewDelegate)] && [self respondsToSelector:@selector(viewAction:)]) {
            return [(id<KKViewDelegate>)self viewAction:x];
        }
    }];
    return cell;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tcs trySetResult:_dataArr[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)requestBorrowToken
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code==1000) {
            [self.dataArr addObjectsFromArray: [result arrWithClass:@"TokenModel"]];
            [self.collectionView reloadData];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)requestLoanToken
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code==1000) {
            [self.dataArr addObjectsFromArray: [result arrWithClass:@"TokenModel"]];
            [self.collectionView reloadData];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)requestWalletToken
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code==1000) {
            [self.dataArr addObjectsFromArray: [result arrWithClass:@"TokenModel"]];
            [self.collectionView reloadData];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
@end
