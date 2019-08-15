//
//  LoanHomePageTableViewCell.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/27.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "LoanHomePageTableViewCell.h"
#import "LoanHomePageModel.h"
@interface LoanHomePageTableViewCell ()
//
@property (nonatomic, strong) UIView * headerBackView;
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * subTitleLabel;
//
@property (nonatomic, strong) UIView * lineView;
//
@property (nonatomic, strong) UILabel * rateLabel;
//
@property (nonatomic, strong) UILabel * rateNoteLabel;
//
@property (nonatomic, strong) UILabel * expectedTitleLabel;
//
@property (nonatomic, strong) UILabel * expectedLabel;
//
@property (nonatomic, strong) UILabel * intervalTitleLabel;
//
@property (nonatomic, strong) UILabel * intervalLabel;
//
@property (nonatomic, strong) UIButton * loanBtn;
//
@property (nonatomic, strong) UIView * paddingView;
//
@property (nonatomic, strong) NSIndexPath * path;

#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation LoanHomePageTableViewCell

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

    RACTupleUnpack(LoanHomePageModel * model , NSIndexPath *path) = tuple;
    _path = path;
    _titleLabel.text = [NSString stringWithFormat:@"申请借币%@%@",model.borrowCount,model.borrowType];
    _subTitleLabel.text = [NSString stringWithFormat:@"平台手机尾号%@用户",model.borrowUserID];
    NSString * rate = [NSString stringWithFormat:@"%@%%",model.dailyRate];
    NSMutableAttributedString * att = [NSMutableAttributedString string:rate];
    [att addAttribute:NSFontAttributeName value:KKThirdFont(30) range:NSMakeRange(0, model.dailyRate.length)];
    [att addAttribute:NSFontAttributeName value:KKCNBFont(20) range:NSMakeRange(model.dailyRate.length, 1)];
    _rateLabel.attributedText = att;
    NSString * expected = [NSString stringWithFormat:@"%@%@",model.expected,model.borrowType];
    NSMutableAttributedString * att1 = [NSMutableAttributedString string:expected];
    [att1 addAttribute:NSFontAttributeName value:KKThirdFont(14) range:NSMakeRange(0, model.expected.length)];
    [att1 addAttribute:NSFontAttributeName value:KKCNBFont(11) range:NSMakeRange(model.expected.length, model.borrowType.length)];
    _expectedLabel.attributedText = att1;
    _intervalLabel.text = [NSString stringWithFormat:@"%@天",model.interval];
    self.actionHandle = action;
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.iconURI]];
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
    [self.contentView addSubview:self.headerBackView];
    [self.headerBackView addSubview:self.icon];
    [self.headerBackView addSubview:self.titleLabel];
    [self.headerBackView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.rateLabel];
    [self.contentView addSubview:self.rateNoteLabel];
    [self.contentView addSubview:self.expectedLabel];
    [self.contentView addSubview:self.expectedTitleLabel];
    [self.contentView addSubview:self.intervalLabel];
    [self.contentView addSubview:self.intervalTitleLabel];
    [self.contentView addSubview:self.loanBtn];
    [self.contentView addSubview:self.paddingView];
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
    [_headerBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(64);
    }];
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.bottom.equalTo(self.headerBackView);
        make.left.equalTo(self.headerBackView).offset(15);
        make.right.equalTo(self.headerBackView).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.headerBackView).offset(15);
        make.centerY.equalTo(self.headerBackView);
        make.height.width.mas_equalTo(25);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self.icon.mas_right).offset(12);
        make.top.equalTo(self.headerBackView).offset(16);
    }];
    [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.icon.mas_right).offset(12);
        make.bottom.equalTo(self.headerBackView).offset(-16);
    }];
    [_rateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        make.left.equalTo(self.contentView).offset(15);
    }];
    [_rateNoteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.paddingView.mas_top).offset(-20);
        make.left.equalTo(self.rateLabel);
    }];
    [_expectedTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(114);
        make.top.equalTo(self.lineView.mas_bottom).offset(22);
    }];
    [_expectedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.expectedTitleLabel.mas_right).offset(4);
        make.centerY.equalTo(self.expectedTitleLabel);
    }];
    [_intervalTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(114);
        make.bottom.equalTo(self.paddingView.mas_top).offset(-20);
    }];
    [_intervalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.intervalTitleLabel.mas_right).offset(4);
        make.centerY.equalTo(self.intervalTitleLabel);
    }];
    [_loanBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.intervalTitleLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    [_paddingView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(12);
    }];
    
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIView *)headerBackView
{
    if (!_headerBackView) {
        _headerBackView = [[UIView alloc]init];
        _headerBackView.backgroundColor = [UIColor whiteColor];
    }
    return _headerBackView;
}
-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNBFont(14);
        _titleLabel.textColor = KKHexColor(0C1E48);
    }
    return _titleLabel;
}
-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = KKCNFont(11);
        _subTitleLabel.textColor = KKHexColor(C4C8CE);
    }
    return _subTitleLabel;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = KKHexColor(EFEFF4);
    }
    return _lineView;
}
-(UILabel *)rateLabel
{
    if (!_rateLabel) {
        _rateLabel = [[UILabel alloc]init];
        _rateLabel.textColor = KKHexColor(FF7120);
    }
    return _rateLabel;
}
-(UILabel *)rateNoteLabel
{
    if (!_rateNoteLabel) {
        _rateNoteLabel = [[UILabel alloc]init];
        _rateNoteLabel.font = KKCNFont(11);
        _rateNoteLabel.textColor = KKHexColor(95A0AB);
        _rateNoteLabel.text = @"约定日利率";
    }
    return _rateNoteLabel;
}
-(UILabel *)expectedTitleLabel
{
    if (!_expectedTitleLabel) {
        _expectedTitleLabel = [[UILabel alloc]init];
        _expectedTitleLabel.font = KKCNFont(12);
        _expectedTitleLabel.textColor = KKHexColor(697D91);
        _expectedTitleLabel.text = @"预期收益";
    }
    return _expectedTitleLabel;
}
-(UILabel *)expectedLabel
{
    if (!_expectedLabel) {
        _expectedLabel = [[UILabel alloc]init];
        _expectedLabel.font = KKCNFont(14);
        _expectedLabel.textColor = KKHexColor(FF7120);
    }
    return _expectedLabel;
}
-(UILabel *)intervalTitleLabel
{
    if (!_intervalTitleLabel) {
        _intervalTitleLabel = [[UILabel alloc]init];
        _intervalTitleLabel.font = KKCNFont(12);
        _intervalTitleLabel.textColor = KKHexColor(697D91);
        _intervalTitleLabel.text = @"借币期限";
    }
    return _intervalTitleLabel;
}
-(UILabel *)intervalLabel
{
    if (!_intervalLabel) {
        _intervalLabel = [[UILabel alloc]init];
        _intervalLabel.font = KKThirdFont(12);
        _intervalLabel.textColor = KKHexColor(465062);
    }
    return _intervalLabel;
}
-(UIButton *)loanBtn
{
    if (!_loanBtn) {
        _loanBtn = [[UIButton alloc]init];
        [_loanBtn setTitle:@"立即出借" forState:UIControlStateNormal];
        [_loanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loanBtn setBackgroundColor:KKHexColor(5170EB)];
        _loanBtn.titleLabel.font = KKCNFont(13);
        _loanBtn.layer.cornerRadius = 15;
        _loanBtn.layer.shadowColor = [UIColor colorWithRed:81/255.0 green:112/255.0 blue:235/255.0 alpha:0.29].CGColor;
        _loanBtn.layer.shadowOffset = CGSizeMake(0,3);
        _loanBtn.layer.shadowOpacity = 1;
        _loanBtn.layer.shadowRadius = 6;
        _loanBtn.enabled = NO;
    }
    return _loanBtn;
}
-(UIView *)paddingView
{
    if (!_paddingView) {
        _paddingView = [[UIView alloc]init];
        _paddingView.backgroundColor = KKHexColor(F5F6F7);
    }
    return _paddingView;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
