//
//  BorrowBottomView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/1.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "BorrowBottomView.h"

@interface BorrowBottomView ()
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UIButton * submitBtn;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation BorrowBottomView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    return ^(NSNumber *tuple) {
        self.submitBtn.enabled = tuple.boolValue;
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
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.hline];
    [self addSubview:self.submitBtn];
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
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    [_submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.centerX.equalTo(self);
        make.left.equalTo(self).offset(11);
        make.right.equalTo(self).offset(-11);
        make.height.mas_equalTo(44);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(E0E0E0);
    }
    return _hline;
}
-(UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc]init];
        [_submitBtn setTitle:@"我要借币" forState:UIControlStateNormal];
        _submitBtn.kkButtonType = KKButtonTypePriSolid;
        _submitBtn.titleLabel.font = KKCNFont(15);
        [_submitBtn addTarget:self action:@selector(clickSubmitButton) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.enabled = NO;
    }
    return _submitBtn;
}



#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clickSubmitButton
{
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"request",@"submit"));
    }
}



@end
