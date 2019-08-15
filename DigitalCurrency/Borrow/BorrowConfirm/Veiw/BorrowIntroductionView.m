//
//  BorrowIntroductionView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/21.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowIntroductionView.h"

@interface BorrowIntroductionView ()
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIImageView * accessIcon;
//
@property (nonatomic, strong) UIControl * control;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation BorrowIntroductionView

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

- (instancetype)initWithFrame:(CGRect)frame model:(id)model action:(KKActionHandle)action {
    if (self = [super initWithFrame:frame]) {
        self.actionHandle = action;
        self.model = model;
        [self addViews];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        self.control.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.control];
    [self.control addSubview:self.accessIcon];
    [self.control addSubview:self.titleLabel];
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
    [_control mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.bottom.right.equalTo(self);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.control).offset(15);
        make.centerY.equalTo(self.control);
    }];
    [_accessIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.control).offset(-8);
        make.centerY.equalTo(self.control);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
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
        _titleLabel.font = KKCNFont(15);
        _titleLabel.textColor = KKHexColor(0C1E48);
        _titleLabel.text = @"查看并了解服务详情";
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

-(UIControl *)control
{
    if (!_control) {
        _control = [[UIControl alloc]init];
        [_control addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _control;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clicked
{
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"push",@"BorrowIntroductionViewController"));
    }
}

@end
