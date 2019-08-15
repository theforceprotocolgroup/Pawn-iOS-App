//
//  PopTokenListView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "PopTokenListView.h"

@interface PopTokenListCollectionViewCell : UICollectionViewCell <KKViewDelegate>
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * subTitleLabel;
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UIImageView * choosenIcon;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) AssetHomeTokenModel * model;
@end

@implementation PopTokenListCollectionViewCell

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================
//更新
- (void)viewModel:(RACTuple *)tuple action:(nullable KKActionHandle)action {
    RACTupleUnpack(AssetHomeTokenModel *model, NSNumber * selected) = tuple;
    self.model =model;
    self.titleLabel.text = self.model.tokenSymbol;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.model.iconURI]];
    self.subTitleLabel.text = self.model.tokenName;
    self.actionHandle = action;
    self.choosenIcon.hidden = !selected.boolValue;
    if (selected.boolValue) {
        self.layer.borderColor = KKHexColor(5170EB).CGColor;
        self.layer.borderWidth = 1.0f;
    }else
    {
        self.layer.borderColor = KKHexColor(ffffff).CGColor;
        self.layer.borderWidth = 1.0f;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - Init
///=============================================================================
/// @name Init
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.equalTo(self);
        }];
        self.contentView.backgroundColor = KKHexColor(ffffff);
        [self addViews];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.shadowColor = [KKHexColor(C3D3F6) colorWithAlphaComponent:0.2].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,5);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 8;
    }
    return self;
}

-(void)addViews
{
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleView];
    [self.titleView addSubview:self.titleLabel];
    [self.titleView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.choosenIcon];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================

- (void)updateConstraints {
    [self updateLayout];
    [super updateConstraints];
}

- (void)updateLayout {
    @weakify(self);
    [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.height.width.mas_equalTo(25);
    }];
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.icon.mas_right).offset(12);
        
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.equalTo(self.titleView);
    }];
    [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.left.equalTo(self.titleView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    }];
    [_choosenIcon mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.right.top.equalTo(self.contentView);
        make.height.width.mas_equalTo(18);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNBFont(15);
        _titleLabel.textColor = KKHexColor(0C1E48);
    }
    return _titleLabel;
}
-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}
-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = KKCNFont(11);
        _subTitleLabel.textColor = KKHexColor(8C9FAD);
    }
    return _subTitleLabel;
}

-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = KKHexColor(ffffff);
    }
    return _titleView;
}
-(UIImageView *)choosenIcon
{
    if (!_choosenIcon) {
        _choosenIcon = [[UIImageView alloc]initWithImage:KKImage(@"token_choose")];
    }
    return _choosenIcon;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

@end


@interface PopTokenListView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _oraginalIndex ;
}
//
@property (nonatomic, strong) UICollectionView * collectionView;
//
@property (nonatomic, strong) UIView * bgView;
//
@property (nonatomic, strong) UIView * superVeiw;
//
@property (nonatomic, strong) NSArray < AssetHomeTokenModel* > * dataArr;
//
@property (nonatomic, strong) UIButton * resetBtn;
//
@property (nonatomic, strong) UIButton * suerBtn;
//
@property (nonatomic, assign) NSInteger selectedIndex;

#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation PopTokenListView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    return ^(RACTuple *tuple) {
        
    };
}

#pragma mark - View
///=============================================================================
/// @name View
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame model:(id)model action:(KKActionHandle)action {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 285 / 375, SCREEN_HEIGHT)]) {
        self.actionHandle = action;
        self.model = model;
        [self addViews];
        self.backgroundColor=KKHexColor(F5F6F7);
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.collectionView];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================

- (void)updateConstraints {
    [self updateLayout];
    [super updateConstraints];
}

- (void)updateLayout {
    @weakify(self);
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout= [[UICollectionViewFlowLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.itemSize = CGSizeMake((SCREEN_WIDTH * 285 / 375 - 15*2 -10)/2, 40);
        layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH * 285 / 375, 80);

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 285 / 375, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = KKHexColor(F5F6F7);
        [_collectionView registerClass:NSClassFromString(@"PopTokenListCollectionViewCell") forCellWithReuseIdentifier:@"PopTokenListCollectionViewCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        
    }
    return _collectionView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColorHex(010517) colorWithAlphaComponent:0.7];
        _bgView.frame = _superVeiw.bounds;
        [_bgView kkAddTapAction:^(RACTuple *x){
            [self dismiss];
        }];
    }
    return _bgView;
}
-(UIButton *)resetBtn
{
    if (!_resetBtn) {
        _resetBtn = [[UIButton alloc]init];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setBackgroundColor:KKHexColor(38BBFF)];
        _resetBtn.layer.cornerRadius = 18;
        [_resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = KKCNFont(15);
        [_resetBtn addTarget:self action:@selector(clickedResetBtn) forControlEvents:UIControlEventTouchUpInside];
        _resetBtn.layer.shadowOffset = CGSizeMake(0,3);
        _resetBtn.layer.shadowOpacity = 1;
        _resetBtn.layer.shadowRadius = 6;
        _resetBtn.layer.shadowColor = [UIColor colorWithRed:56/255.0 green:187/255.0 blue:255/255.0 alpha:0.29].CGColor;

    }
    return _resetBtn;
}
-(UIButton *)suerBtn
{
    if (!_suerBtn) {
        _suerBtn = [[UIButton alloc]init];
        [_suerBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_suerBtn setBackgroundColor:KKHexColor(4470E4)];
        _suerBtn.layer.cornerRadius = 18;
        [_suerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _suerBtn.titleLabel.font = KKCNFont(15);
        [_suerBtn addTarget:self action:@selector(clickedSureBtn) forControlEvents:UIControlEventTouchUpInside];
        _suerBtn.layer.shadowColor = [UIColor colorWithRed:68/255.0 green:112/255.0 blue:228/255.0 alpha:0.29].CGColor;
        _suerBtn.layer.shadowOffset = CGSizeMake(0,3);
        _suerBtn.layer.shadowOpacity = 1;
        _suerBtn.layer.shadowRadius = 6;
        _suerBtn.layer.cornerRadius = 18;
    }
    return _suerBtn;
}
#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH * 285 / 375, 80);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:self.suerBtn];
    [footerView addSubview:self.resetBtn];
    [_resetBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(42);
        make.top.equalTo(footerView).offset(35);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(89);
    }];
    [_suerBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footerView).offset(-42);
        make.top.equalTo(footerView).offset(35);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(89);
    }];
    return footerView;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"PopTokenListCollectionViewCell" forIndexPath:indexPath];
    
    if (![cell conformsToProtocol:@protocol(KKViewDelegate)]) return cell;
    
    id data;
    id model = _dataArr[indexPath.row];
    data = RACTuplePack(model, @(_selectedIndex == indexPath.row));
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
    _selectedIndex=indexPath.row;
    [collectionView reloadData];
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clickedResetBtn
{
    _selectedIndex = _oraginalIndex;
    [self.collectionView reloadData];
}
-(void)clickedSureBtn
{
    if (self.actionHandle) {
        self.actionHandle(@(_selectedIndex));
    }
    [self dismiss];
}

#pragma mark - Public
+ (instancetype)showWithDefaultIndex:(NSInteger)index Content:(NSArray <AssetHomeTokenModel *>*)dataArr superView:(UIView * _Nullable )superView action:(KKActionHandle)handle;
{
    PopTokenListView * view = [[PopTokenListView alloc]initWithFrame:CGRectZero model:dataArr action:handle];
    view.selectedIndex = index;
    view.dataArr = dataArr;
    view.superVeiw = superView?:[UIApplication sharedApplication].keyWindow;
    view.center = CGPointMake(view.superVeiw.width, view.superVeiw.height/2);
    return view;
}
- (void)show {
    [_superVeiw addSubview:self.bgView];
    [_superVeiw addSubview:self];
    
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectSetX(self.frame, SCREEN_WIDTH-self.width);
        self.bgView.alpha = .3f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectSetX(self.frame, SCREEN_WIDTH);
        self.bgView.alpha = .0f;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}
-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    _oraginalIndex = selectedIndex;
    _selectedIndex = selectedIndex;
}
@end
