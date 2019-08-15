//
//  PopListView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/20.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "PopListView.h"

/*! 行高 */
#define CardH 57
/*! 横向边距 */
#define HPad 0
/*! 最大行数 */
#define MaxR 4
/*! 最大TabH */
#define MaxTabH CardH * MaxR + 44

@interface PopListViewCell : UITableViewCell <KKViewDelegate>
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIImageView * selecetIcon;
//
@property (nonatomic, strong) UIView * hline;

@end

@implementation PopListViewCell

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================
//更新
- (void)viewModel:(RACTuple *)tuple action:(nullable KKActionHandle)action {
    RACTupleUnpack(NSString * title ,NSNumber * isSelected ) = tuple;
    self.titleLabel.text = title;
    self.selecetIcon.hidden = ![isSelected boolValue];
    [self setNeedsUpdateConstraints];
}

#pragma mark - Init
///=============================================================================
/// @name Init
///=============================================================================

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.equalTo(self);
        }];
        self.contentView.backgroundColor = KKHexColor(ffffff);
        [self addViews];
    }
    return self;
}

-(void)addViews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selecetIcon];
    [self.contentView addSubview:self.hline];
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
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.centerX.equalTo(self.contentView);
    }];
    [_selecetIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.titleLabel.mas_right).offset(15);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(21);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
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
        _titleLabel.font = KKCNFont(18);
        _titleLabel.textColor = KKHexColor(0C1E48);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


-(UIImageView *)selecetIcon
{
    if (!_selecetIcon) {
        _selecetIcon = [[UIImageView alloc]initWithImage:KKImage(@"selectedIcon")];
        _selecetIcon.hidden = YES;
    }
    return _selecetIcon;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(E0E0E0);
    }
    return _hline;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

@end

@implementation PopListViewModel


@end

@interface PopListView () <UITableViewDelegate, UITableViewDataSource>
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) UIView * bgView;
//
@property (nonatomic, strong) UIView * superVeiw;
//
@property (nonatomic, strong) NSArray <PopListViewModel * > * dataArr;
//
@property (nonatomic, strong) NSString * title;

//
@property (nonatomic, assign) NSInteger selectedIndex;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;


@end

@implementation PopListView

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

- (instancetype)initWithFrame:(CGRect)frame model:(NSArray*)model action:(KKActionHandle)action {
    CGRect tmpFrame = CGRectMake(0, 0, SCREEN_WIDTH, MIN(MaxTabH, model.count * CardH +44));
    if (self = [super initWithFrame:tmpFrame]) {
        self.actionHandle = action;
        _selectedIndex = -1;
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.tableView];
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
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.top.bottom.equalTo(self);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:NSClassFromString(@"PopListViewCell") forCellReuseIdentifier:@"PopListViewCell"];
    }
    return _tableView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColorHex(070A14);
        _bgView.alpha = 0.01f;
        _bgView.frame = _superVeiw.bounds;
        [_bgView kkAddTapAction:^(RACTuple *x){
            [self dismiss];
        }];
    }
    return _bgView;
}

#pragma mark - tableViewDelegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopListViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![cell conformsToProtocol:@protocol(KKViewDelegate)]) return cell;
    [(id<KKViewDelegate>)cell viewModel:RACTuplePack(_dataArr[indexPath.row].title ,[NSNumber numberWithBool:indexPath.row == _selectedIndex]) action:^(id  _Nullable x) {
        
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CardH;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.backgroundColor = KKHexColor(F7F7F7);
    UILabel * label = [[UILabel alloc]init];
    label.text = self.title;
    label.textColor = KKHexColor(0C1E48);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = KKCNBFont(17);
    [headerView addSubview:label];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(headerView);
    }];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != _selectedIndex) {
        _selectedIndex = indexPath.row;
        [self.tableView reloadData];
        if (self.actionHandle) {
            self.actionHandle(RACTuplePack(_dataArr[indexPath.row],[NSNumber numberWithInteger:indexPath.row]));
        }
    }
    [self dismiss];
}


#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================



#pragma mark - Public
+ (instancetype)showWithTitle:(NSString *)title content:(NSArray*)dataArr superView:(UIView *)superView action:(KKActionHandle)handle;
{
    PopListView * view = [[PopListView alloc]initWithFrame:CGRectZero model:dataArr action:handle];
    view.dataArr = dataArr;
    view.title = title;
    view.superVeiw = superView?:[UIApplication sharedApplication].keyWindow;
    view.center = CGPointMake(view.superVeiw.width/2, view.superVeiw.height);
    return view;
}
- (void)show {
    [_superVeiw addSubview:self.bgView];
    [_superVeiw addSubview:self];
    
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectSetY(self.frame, SCREEN_HEIGHT-self.height);
        self.bgView.alpha = .3f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        self.frame = CGRectSetY(self.frame, SCREEN_HEIGHT);
        self.bgView.alpha = .0f;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
    }];
}
- (void)selectedIndex:(NSInteger)index;
{
    if (index >=self.dataArr.count) {
        return;
    }
    _selectedIndex = index;
}
@end

