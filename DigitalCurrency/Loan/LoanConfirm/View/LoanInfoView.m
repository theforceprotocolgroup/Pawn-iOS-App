//
//  LoanInfoView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/10.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanInfoView.h"
#import "LoanConfirmOrderInfoModel.h"
@interface LoanInfoView ()
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * countLabel;
//
@property (nonatomic, strong) UILabel * rateLabel;
//
@property (nonatomic, strong) UILabel * rateNoteLabel;
//
@property (nonatomic, strong) UILabel * expectTitleLabel;
//
@property (nonatomic, strong) UILabel * expectLabel;
//
@property (nonatomic, strong) UILabel * intervalTitleLabel;
//
@property (nonatomic, strong) UILabel * intervalLabel;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) LoanConfirmOrderInfoModel * model;

@end

@implementation LoanInfoView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    @weakify(self);
    return ^(LoanConfirmOrderInfoModel *tuple) {
        @strongify(self);
        self.model = tuple;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:tuple.iconURI]];
        //
        NSString * str = [NSString stringWithFormat:@"%@%@",tuple.borrowCount,tuple.borrowTokenType];
        NSMutableAttributedString * attstr = [NSMutableAttributedString string:str];
        [attstr addAttribute:NSFontAttributeName value:KKThirdFont(14) range:NSMakeRange(0, tuple.borrowCount.length)];
        [attstr addAttribute:NSFontAttributeName value:KKCNFont(11) range:NSMakeRange(tuple.borrowCount.length, tuple.borrowTokenType.length)];
        self.countLabel.attributedText = attstr;
        //
        self.rateLabel.text = [NSString stringWithFormat:@"%@%%",tuple.dailyRate];
        //
        NSString * str1 = [NSString stringWithFormat:@"%@%@",tuple.expected,tuple.borrowTokenType];
        NSMutableAttributedString * attstr1 = [NSMutableAttributedString string:str1];
        [attstr1 addAttribute:NSFontAttributeName value:KKThirdFont(13) range:NSMakeRange(0, tuple.expected.length)];
        [attstr1 addAttribute:NSFontAttributeName value:KKCNFont(11) range:NSMakeRange(tuple.expected.length, tuple.borrowTokenType.length)];
        self.expectLabel.attributedText = attstr1;
        
        self.intervalLabel.text = [NSString stringWithFormat:@"%@天",tuple.interval];
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
        self.backgroundColor = KKHexColor(F5F6F7);
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.icon];
    [self addSubview:self.titleLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.rateLabel];
    [self addSubview:self.rateNoteLabel];
    [self addSubview:self.expectTitleLabel];
    [self addSubview:self.expectLabel];
    [self addSubview:self.intervalTitleLabel];
    [self addSubview:self.intervalLabel];
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
        make.top.left.equalTo(self).offset(15);
        make.height.width.mas_equalTo(20);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.icon);
        make.left.equalTo(self.icon.mas_right).offset(7);
    }];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.icon);
        make.left.equalTo(self.titleLabel.mas_right).offset(9);
    }];
    [_rateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(42);
        make.top.equalTo(self.icon.mas_bottom).offset(12);
    }];
    [_rateNoteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.rateLabel);
        make.top.equalTo(self.rateLabel.mas_bottom).offset(6);
    }];
    [_expectTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.rateLabel);
        make.left.equalTo(self).offset(160);
    }];
    [_expectLabel mas_updateConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.left.equalTo(self.expectTitleLabel.mas_right).offset(7);
        make.centerY.equalTo(self.rateLabel);
    }];
    [_intervalTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.expectTitleLabel);
        make.centerY.equalTo(self.rateNoteLabel);
    }];
    [_intervalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.intervalTitleLabel);
        make.left.equalTo(self.intervalTitleLabel.mas_right).offset(7);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

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
        _titleLabel.font = KKCNFont(12);
        _titleLabel.textColor = KKHexColor(95A0AB);
        _titleLabel.text = @"申请借币金额";
    }
    return _titleLabel;
}
-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.textColor = KKHexColor(6F7480);
    }
    return _countLabel;
}
-(UILabel *)rateLabel
{
    if (!_rateLabel) {
        _rateLabel = [[UILabel alloc]init];
        _rateLabel.font = KKThirdFont(20);
        _rateLabel.textColor = KKHexColor(6f7480);
    }
    return _rateLabel;
}
-(UILabel *)rateNoteLabel
{
    if (!_rateNoteLabel) {
        _rateNoteLabel = [[UILabel alloc]init];
        _rateNoteLabel.font = KKCNBFont(11);
        _rateNoteLabel.textColor = KKHexColor(95A0AB);
        _rateNoteLabel.text = @"约定日利率";
    }
    return _rateNoteLabel;
}
-(UILabel *)expectTitleLabel
{
    if (!_expectTitleLabel) {
        _expectTitleLabel = [[UILabel alloc]init];
        _expectTitleLabel.font = KKCNBFont(11);
        _expectTitleLabel.textColor = KKHexColor(95A0AB);
        _expectTitleLabel.text = @"预期收益";
    }
    return _expectTitleLabel;
}
-(UILabel *)expectLabel
{
    if (!_expectLabel) {
        _expectLabel = [[UILabel alloc]init];
        _expectLabel.textColor = KKHexColor(6F7480);
    }
    return _expectLabel;
}
-(UILabel *)intervalTitleLabel
{
    if (!_intervalTitleLabel) {
        _intervalTitleLabel = [[UILabel alloc]init];
        _intervalTitleLabel.font = KKCNBFont(11);
        _intervalTitleLabel.textColor = KKHexColor(95A0AB);
        _intervalTitleLabel.text = @"借币期限";
    }
    return _intervalTitleLabel;
}
-(UILabel *)intervalLabel
{
    if (!_intervalLabel) {
        _intervalLabel = [[UILabel alloc]init];
        _intervalLabel.textColor = KKHexColor(6F7480);
        _intervalLabel.font = KKThirdFont(13);
    }
    return _intervalLabel;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
