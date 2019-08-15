//
//  WithdrawSuccessHeaderView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "WithdrawSuccessHeaderView.h"

@interface WithdrawSuccessHeaderView ()
//
@property (nonatomic, strong) UIImageView * successIcon;
//
@property (nonatomic, strong) UILabel * successLabel;
//
@property (nonatomic, strong) UILabel * countLabel;
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * addressLabel;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation WithdrawSuccessHeaderView

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
    return ^(RACTuple *tuple) {
        @strongify(self);
        RACTupleUnpack(NSString * count,NSString * sybol,NSString *address) = tuple;
        NSString * str= [NSString stringWithFormat:@"%@%@",count,sybol];
        NSMutableAttributedString * attstr = [NSMutableAttributedString string:str];
        [attstr addAttribute:NSFontAttributeName value:KKCNBFont(34) range:NSMakeRange(0, count.length)];
        [attstr addAttribute:NSFontAttributeName value:KKCNFont(15) range:NSMakeRange(count.length, sybol.length)];
        self.countLabel.attributedText = attstr;
        self.addressLabel.text = address;
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
        self.backgroundColor = KKHexColor(ffffff);
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.successIcon];
    [self addSubview:self.successLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.hline];
    [self addSubview:self.titleLabel];
    [self addSubview:self.addressLabel];
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
    [_successIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(47);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(71);
        make.height.mas_equalTo(66);
    }];
    [_successLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.successIcon.mas_bottom).offset(6);
        make.centerX.equalTo(self);
    }];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.successLabel.mas_bottom).offset(64);
        make.centerX.equalTo(self);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.countLabel.mas_bottom).offset(40);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.hline.mas_bottom).offset(21);
        make.left.equalTo(self).offset(15);
    }];
    [_addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UIImageView *)successIcon
{
    if (!_successIcon) {
        _successIcon = [[UIImageView alloc]initWithImage:KKImage(@"success_icon")];
    }
    return _successIcon;
}
-(UILabel *)successLabel
{
    if (!_successLabel) {
        _successLabel = [[UILabel alloc]init];
        _successLabel.font = KKCNFont(15);
        _successLabel.textColor = KKHexColor(1084F9);
        _successLabel.text = @"提现成功";
        _successLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _successLabel;
}
-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.textColor = KKHexColor(0C1E48);
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _hline;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNFont(14);
        _titleLabel.textColor = KKHexColor(8F97A6);
        _titleLabel.text = @"转出地址";
    }
    return _titleLabel;
}
-(UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = KKCNFont(15);
        _addressLabel.textColor = KKHexColor(0C1E48);
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.numberOfLines = 0;
        _addressLabel.preferredMaxLayoutWidth = SCREEN_WIDTH;
    }
    return _addressLabel;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
