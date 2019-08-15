//
//  TokenListCollectionViewCell.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/19.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "TokenListCollectionViewCell.h"
#import "TokenModel.h"

@interface TokenListCollectionViewCell ()
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * subTitleLabel;
//
@property (nonatomic, strong) UIView * titleView;

#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) TokenModel * model;
@end

@implementation TokenListCollectionViewCell

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================
//更新
- (void)viewModel:(RACTuple *)tuple action:(nullable KKActionHandle)action {
    RACTupleUnpack(TokenModel *model) = tuple;
    self.model =model;
    self.titleLabel.text = self.model.symbol;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.model.iconURI]];
    self.subTitleLabel.text = self.model.name;
    self.actionHandle = action;
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
        make.left.equalTo(self.contentView).offset(21);
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
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
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
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
