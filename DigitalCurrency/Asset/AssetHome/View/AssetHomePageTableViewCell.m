//
//  AssetHomePageTableViewCell.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/5.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "AssetHomePageTableViewCell.h"
#import "AssetHomeTokenModel.h"
@interface AssetHomePageTableViewCell ()
//
@property (nonatomic, strong) UIView * backView;
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * enableTitleLabel;
//
@property (nonatomic, strong) UILabel * enableLabel;
//
@property (nonatomic, strong) UILabel * frozenTitleLabel;
//
@property (nonatomic, strong) UILabel * frozenLabel;
//
@property (nonatomic, strong) UILabel * quoetsTitleLabel;
//
@property (nonatomic, strong) UILabel * quoetsLabel;
//
@property (nonatomic, strong) UIImageView * accessIcon;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) AssetHomeTokenModel * model;

@end

@implementation AssetHomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================
//更新
- (void)viewModel:(RACTuple *)tuple action:(nullable KKActionHandle)action {

    self.actionHandle = action;
    
    RACTupleUnpack(AssetHomeTokenModel * tokenModel , NSIndexPath * path)= tuple;
    
    self.model = tokenModel;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:_model.iconURI]];
    self.titleLabel.text = _model.tokenSymbol;
    self.enableLabel.text = _model.tokenBalance;
    self.frozenLabel.text = _model.tokenFrozen;
    self.quoetsLabel.text = _model.quotesCurrencyCount;
    self.quoetsTitleLabel.text = [NSString stringWithFormat:@"折合(%@)",_model.quotesType];
    [self setNeedsUpdateConstraints];
}

#pragma mark - Init
///=============================================================================
/// @name Init
///=============================================================================

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        @weakify(self);
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.bottom.right.left.equalTo(self);
        }];
        self.contentView.backgroundColor = KKHexColor(f0f4f7);
        [self addViews];
    }
    return self;
}

-(void)addViews
{
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.icon];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.accessIcon];
    [self.backView addSubview:self.enableTitleLabel];
    [self.backView addSubview:self.enableLabel];
    [self.backView addSubview:self.frozenTitleLabel];
    [self.backView addSubview:self.frozenLabel];
    [self.backView addSubview:self.quoetsTitleLabel];
    [self.backView addSubview:self.quoetsLabel];
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
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(30);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.backView).offset(-15);
        make.height.width.mas_equalTo(36);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.backView).offset(18);
        make.left.equalTo(self.backView).offset(30);
    }];
    [_accessIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.backView.mas_right).offset(-3);
        make.centerY.equalTo(self.titleLabel);
        make.height.width.mas_equalTo(25);
    }];
    [_enableLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.backView.mas_left).offset(12);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-15);
    }];
    [_enableTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.backView.mas_left).offset(12);
        make.bottom.equalTo(self.enableLabel.mas_top).offset(-9);
    }];
    [_frozenLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.backView.mas_left).offset(120);
        make.centerY.equalTo(self.enableLabel);
    }];
    [_frozenTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.frozenLabel);
        make.bottom.equalTo(self.enableLabel.mas_top).offset(-9);
    }];
    [_quoetsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.backView).offset(-12);
        make.centerY.equalTo(self.enableLabel);
    }];
    [_quoetsTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.quoetsLabel);
        make.bottom.equalTo(self.enableLabel.mas_top).offset(-9);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5.0f;
    }
    return _backView;
}
-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 18.0f;
        _icon.layer.borderColor = [UIColor whiteColor].CGColor;
        _icon.layer.borderWidth = 2.0f;
    }
    return _icon;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNBFont(15);
        _titleLabel.textColor = KKHexColor(111E4B);
    }
    return _titleLabel;
}
-(UIImageView *)accessIcon
{
    if (!_accessIcon) {
        _accessIcon = [[UIImageView alloc]initWithImage:KKImage(@"leftArrow")];
    }
    return _accessIcon;
}
-(UILabel *)enableTitleLabel
{
    if (!_enableTitleLabel) {
        _enableTitleLabel = [[UILabel alloc]init];
        _enableTitleLabel.font = KKCNFont(11);
        _enableTitleLabel.textColor = KKHexColor(909FAE);
        _enableTitleLabel.text = @"可用";
    }
    return _enableTitleLabel;
}
-(UILabel *)enableLabel
{
    if (!_enableLabel) {
        _enableLabel = [[UILabel alloc]init];
        _enableLabel.font = KKThirdFont(13);
        _enableLabel.textColor = KKHexColor(0C1E48);
    }
    return _enableLabel;
}
-(UILabel *)frozenTitleLabel
{
    if (!_frozenTitleLabel) {
        _frozenTitleLabel = [[UILabel alloc]init];
        _frozenTitleLabel.font = KKCNFont(11);
        _frozenTitleLabel.textColor = KKHexColor(909FAE);
        _frozenTitleLabel.text = @"冻结";
    }
    return _frozenTitleLabel;
}
-(UILabel *)frozenLabel
{
    if (!_frozenLabel) {
        _frozenLabel = [[UILabel alloc]init];
        _frozenLabel.font = KKThirdFont(13);
        _frozenLabel.textColor = KKHexColor(0C1E48);
    }
    return _frozenLabel;
}
-(UILabel *)quoetsTitleLabel
{
    if (!_quoetsTitleLabel) {
        _quoetsTitleLabel = [[UILabel alloc]init];
        _quoetsTitleLabel.font = KKCNFont(11);
        _quoetsTitleLabel.textColor = KKHexColor(909FAE);
        _quoetsTitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _quoetsTitleLabel;
}
-(UILabel *)quoetsLabel
{
    if (!_quoetsLabel) {
        _quoetsLabel = [[UILabel alloc]init];
        _quoetsLabel.font = KKThirdFont(13);
        _quoetsLabel.textColor = KKHexColor(0C1E48);
        _quoetsLabel.textAlignment = NSTextAlignmentRight;
    }
    return _quoetsLabel;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
