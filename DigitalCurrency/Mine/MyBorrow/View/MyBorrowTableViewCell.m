//
//  MyBorrowTableViewCell.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyBorrowTableViewCell.h"
#import "MyBorrowListModel.h"

@interface MyBorrowTableViewCell ()
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * subTitleLabel;
//
@property (nonatomic, strong) UILabel * statusLabel;
//
@property (nonatomic, strong) UILabel * contentLabel;
//
@property (nonatomic, strong) UIImageView * accessIcon;
//
@property (nonatomic, strong) UIView * hline;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) MyBorrowListModel* model;

@end

@implementation MyBorrowTableViewCell

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

    _model = tuple.first;
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",_model.borrowTokenCount,_model.borrowTokenType];
    self.subTitleLabel.text = [NSString stringWithFormat:@"%@",[_model subTitleText]];
    self.statusLabel.text = [_model statusText];
    self.statusLabel.textColor = [_model statusColer];
    self.contentLabel.text = [NSString stringWithFormat:@"%@",[_model contentTitleText]];
    
    self.actionHandle = action;
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
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.accessIcon];
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
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(20);
    }];
    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-46);
    }];
    [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14);
        make.left.equalTo(self.titleLabel);
    }];
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.subTitleLabel);
        make.right.equalTo(self.contentView).offset(-46);
    }];
    [_accessIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentView.mas_right).offset(-3);
        make.centerY.equalTo(self.contentView);
        make.height.width.mas_equalTo(25);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
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
        _titleLabel.font = KKThirdFont(15);
        _titleLabel.textColor = KKHexColor(041E45);
    }
    return _titleLabel;
}
-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = KKCNFont(13);
        _subTitleLabel.textColor = KKHexColor(435061);
    }
    return _subTitleLabel;
}
-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = KKCNBFont(14);
    }
    return _statusLabel;
}
-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = KKCNFont(13);
        _contentLabel.textColor = KKHexColor(9197A7);
    }
    return _contentLabel;
}
-(UIImageView *)accessIcon
{
    if (!_accessIcon) {
        _accessIcon = [[UIImageView alloc]initWithImage:KKImage(@"leftArrow")];
    }
    return _accessIcon;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _hline;
}




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
