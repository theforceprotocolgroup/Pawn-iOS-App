//
//  BorrowInfoView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/21.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowInfoView.h"
#import "BorrowInfoFooterView.h"
#import "ContentViewModel.h"
#import "BorrowHomeViewModel.h"
@interface BorrowInfoView ()<UITableViewDelegate,UITableViewDataSource>
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIImageView * titleIcon;
//
@property (nonatomic, strong) UITableView * tableView;
//
@property (nonatomic, strong) BorrowInfoFooterView * footerView;
//
@property (nonatomic, strong) NSArray <ContentViewModel*> * contentArr;
//
@property (nonatomic, strong) NSArray <BorrowHomePageTableViewModel*> * borrowCellArr;
//
@property (nonatomic, strong) NSDictionary * lendInfo;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) BorrowHomeViewModel* model;

@end

@implementation BorrowInfoView

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
        RACTupleUnpack(BorrowHomeViewModel * homeModel,NSArray * tmpContentArr,NSDictionary * lendInfo)= tuple;
        self.model = homeModel;
        self.lendInfo = lendInfo;
        self.borrowCellArr = self.model.borrowDetailCellArr;
        self.contentArr = tmpContentArr;
        [self.footerView viewAction](self.contentArr);
        [self.tableView reloadData];
        [self setNeedsUpdateConstraints];
    };
}

#pragma mark - View
///=============================================================================
/// @name View
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame model:(id)model action:(KKActionHandle)action {
    if (self = [super initWithFrame:frame]) {
        self.actionHandle = action;
        self.model = model;
        [self addViews];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.titleIcon];
    [self.titleView addSubview:self.titleLabel];
    [self addSubview:self.tableView];
    [self addSubview:self.footerView];
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
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    [_titleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.titleView);
        make.left.equalTo(self.titleView).offset(15);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.self.titleIcon);
        make.left.equalTo(self.titleIcon.mas_right).offset(8);
    }];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(339);
    }];
    [_footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
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
        _titleLabel.text = @"借币信息";
    }
    return _titleLabel;
}

-(UIImageView *)titleIcon
{
    if (!_titleIcon) {
        _titleIcon = [[UIImageView alloc]initWithImage:KKImage(@"titleIcon")];
    }
    return _titleIcon;
}
-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =KKHexColor(ffffff);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        adjustsScrollViewInsets(_tableView);
        [_tableView registerClass:NSClassFromString(@"BorrowInfoTableViewCell") forCellReuseIdentifier:NSStringFromClass(self.class)];

    }
    return _tableView;
}
-(BorrowInfoFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [BorrowInfoFooterView viewWithModel:nil action:^(id  _Nullable x) {
            
        }];
    }
    return _footerView;
}
#pragma mark - delegate
///=============================================================================
/// @name delegate
///=============================================================================

#pragma mark - tableViewDelegate && dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.borrowCellArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![cell conformsToProtocol:@protocol(KKViewDelegate)]) return cell;
    id data ;
    if (indexPath.row ==3) {
        data = RACTuplePack(_borrowCellArr[indexPath.row],indexPath,@(indexPath.row ==_borrowCellArr.count-1),_model.rateArr);
    }else if (indexPath.row == 1)
    {
        data = RACTuplePack(_borrowCellArr[indexPath.row],indexPath,@(indexPath.row ==_borrowCellArr.count-1),_lendInfo);
    }
    else
    {
        data = RACTuplePack(_borrowCellArr[indexPath.row],indexPath,@(indexPath.row ==_borrowCellArr.count-1));
    }
    
    [(id<KKViewDelegate>)cell viewModel:data action:^(RACTuple*  _Nullable x) {
        [self changedAction:x];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 3 ? 158 : 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            if (self.actionHandle) {
                self.actionHandle(RACTuplePack(@"push",@"TokenListViewController",@"borrow"));
            }
            }break;
        case 1:
            break;
        case 2:{
            if (self.actionHandle) {
                self.actionHandle(RACTuplePack(@"tap",@"",@"interval"));
            }
        }break;
        default:
            break;
    }

}

-(void)changedAction:(RACTuple *)x
{
    if (self.actionHandle) {
        self.actionHandle(x);
    }
}


@end
