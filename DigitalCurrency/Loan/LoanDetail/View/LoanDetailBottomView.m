//
//  LoanDetailBottomView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/2.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanDetailBottomView.h"

@interface LoanDetailBottomView ()
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UIButton * actionBtn;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation LoanDetailBottomView

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
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.hline];
    [self addSubview:self.actionBtn];
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
    [_actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.centerX.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
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
-(UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc]init];
        _actionBtn.kkButtonType = KKButtonTypePriSolid;
        _actionBtn.kkTitle = @"立即出借";
        [_actionBtn addTarget:self action:@selector(clickedActionBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}



#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clickedActionBtn
{
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"push"));
    }
}



@end
