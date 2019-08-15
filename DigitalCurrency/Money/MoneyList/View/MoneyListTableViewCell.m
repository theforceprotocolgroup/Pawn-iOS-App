//
//  MoneyListTableViewCell.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/22.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MoneyListTableViewCell.h"
#import "MoneyListModel.h"
@interface MoneyListTableViewCell ()
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * subTitleLabel;
//
@property (nonatomic, strong) UIImageView * bgView;
//
@property (nonatomic, strong) UIImageView * downImage;
//
@property (nonatomic, strong) UIButton * actionBtn;
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UIView * downView;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) MoneyListModel * model;
//
@property (nonatomic, strong) NSIndexPath * indexpath;

@end

@implementation MoneyListTableViewCell

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
    self.indexpath = tuple.second;
    _downImage.hidden = _indexpath.row == 3 ? YES : NO;
    _titleLabel.text = _model.title;
    _subTitleLabel.text = _model.subTitle;
    self.actionBtn.hidden = _indexpath.row == 0 || _indexpath.row == 1 ? NO : YES;
    NSString * btnimg = @"";
    if (_indexpath.row == 0) {
        btnimg = @"money_call";
        [self.actionBtn setImage:KKImage(btnimg) forState:UIControlStateNormal];
    }else if (_indexpath.row == 1)
    {
        btnimg = @"money_form";
        [self.actionBtn setImage:KKImage(btnimg) forState:UIControlStateNormal];
    }
    _bgView.image = KKImage(_model.backImg);

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
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleView];
    [self.titleView addSubview:self.subTitleLabel];
    [self.titleView addSubview:self.titleLabel];
    [self.bgView addSubview:self.actionBtn];
    [self.contentView addSubview:self.downView];
    [self.downView addSubview:self.downImage];
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
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView).offset(self.indexpath.row == 0 ? 15 : 0);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-35);
    }];
    if (_indexpath.row == 0 ||
        _indexpath.row == 1) {
        [_titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.bgView);
            make.left.equalTo(self.bgView).offset(72);
            make.right.equalTo(self.actionBtn.mas_left).offset(-5);
        }];
    }else
    {
        [_titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.bgView);
            make.left.equalTo(self.bgView).offset(72);
            make.right.equalTo(self.bgView.mas_right).offset(-15);
        }];
    }

    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleView);
        make.left.equalTo(self.titleView);
    }];
    [_subTitleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.titleView);
        make.left.equalTo(self.titleView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.titleView);
    }];
    [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(37);
        make.width.mas_equalTo(81);
    }];
    [_downView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.bgView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    [_downImage mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.centerY.equalTo(self.downView);
        make.height.width.mas_equalTo(19);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
    }
    return _bgView;
}
-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    return _titleView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNBFont(16);
        _titleLabel.textColor = KKHexColor(111E4B);
    }
    return _titleLabel;
}
-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = KKCNBFont(13);
        _subTitleLabel.textColor = KKHexColor(465062);
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.preferredMaxLayoutWidth = 196;
    }
    return _subTitleLabel;
}
-(UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc]init];
        [_actionBtn addTarget:self action:@selector(clickedActionBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}
-(UIView *)downView
{
    if (!_downView) {
        _downView = [[UIView alloc]init];
        _downView.backgroundColor = [UIColor clearColor];
    }
    return _downView;
}
-(UIImageView *)downImage
{
    if (!_downImage) {
        _downImage = [[UIImageView alloc]initWithImage:KKImage(@"money_down_arrow")];
    }
    return _downImage;
}

#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickedActionBtn
{
    NSString * action = @"";
    if (_indexpath.row == 0) {
        action = @"call";
    }else if (_indexpath.row == 1)
    {
        action = @"form";
    }
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(action));
    }
}




@end
