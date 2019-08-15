//
//  RechargeAddressView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "RechargeAddressView.h"
#import "NSString+QRCode.h"
@interface RechargeAddressView ()
//
@property (nonatomic, strong) UIImageView * addressIcon;
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

@implementation RechargeAddressView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    return ^(NSString *tuple) {
        self.addressLabel.text = tuple;
        self.addressIcon.image = [tuple kk_QRcodeWithHeight:118];
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
    [self addSubview:self.addressIcon];
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
    [_addressIcon mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(33);
        make.height.width.mas_equalTo(118);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.addressIcon.mas_bottom).offset(20);
    }];
    [_addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
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

-(UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = KKCNFont(15);
        _addressLabel.textColor = KKHexColor(0C1E48);
        _addressLabel.numberOfLines = 0;
        _addressLabel.preferredMaxLayoutWidth = SCREEN_WIDTH;
    }
    return _addressLabel;
}
-(UIImageView *)addressIcon
{
    if (!_addressIcon) {
        _addressIcon = [[UIImageView alloc]init];
    }
    return _addressIcon;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = KKHexColor(8F97A6);
        _titleLabel.font = KKCNFont(14);
        _titleLabel.text = @"充值地址";
    }
    return _titleLabel;
}


#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
