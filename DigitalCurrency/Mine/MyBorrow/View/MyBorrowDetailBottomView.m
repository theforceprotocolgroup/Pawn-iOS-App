//
//  MyBorrowDetailBottomView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyBorrowDetailBottomView.h"
#import "MyBorrowDetailModel.h"
@interface MyBorrowDetailBottomView ()
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UIButton * repayBtn;
//
@property (nonatomic, strong) UIButton * closePositionBtn;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) MyBorrowDetailModel * model;

@end

@implementation MyBorrowDetailBottomView

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
    return ^(MyBorrowDetailModel *tuple) {
        @strongify(self);
        self.model = tuple;
        if (tuple.reachPreCautiousLine) {
            [self addSubview:self.closePositionBtn];
            [self.closePositionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self).offset(11);
                make.centerY.equalTo(self);
                make.height.mas_equalTo(44);
                make.width.mas_equalTo((SCREEN_WIDTH - 11 * 2 - 22)/2);
            }];

            [self setNeedsUpdateConstraints];
        }else
        {
            [self.closePositionBtn removeFromSuperview];
            [self setNeedsUpdateConstraints];
        }
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
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.hline];
    [self addSubview:self.repayBtn];
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
    [_repayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(self.model.reachPreCautiousLine ? (SCREEN_WIDTH - 11 * 2 - 22)/2 : SCREEN_WIDTH - 11*2);
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
-(UIButton *)repayBtn
{
    if (!_repayBtn) {
        _repayBtn = [[UIButton alloc]init];
        [_repayBtn setTitle:@"立即还款" forState:UIControlStateNormal];
        _repayBtn.kkButtonType = KKButtonTypePriSolid;
        _repayBtn.titleLabel.font = KKCNFont(15);
        [_repayBtn addTarget:self action:@selector(clickRepayButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repayBtn;
}
-(UIButton *)closePositionBtn
{
    if (!_closePositionBtn) {
        _closePositionBtn = [[UIButton alloc]init];
        [_closePositionBtn setTitle:@"立即补仓" forState:UIControlStateNormal];
        [_closePositionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closePositionBtn setBackgroundColor:KKHexColor(93D5FF)];
        _closePositionBtn.titleLabel.font = KKCNFont(15);
        _closePositionBtn.layer.masksToBounds = YES;
        _closePositionBtn.layer.cornerRadius = 22;
        [_closePositionBtn addTarget:self action:@selector(clickedRechageBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closePositionBtn;
}



#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickRepayButton
{
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"request",@"repay"));
    }
}

-(void)clickedRechageBtn
{
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"request",@"recharge"));
    }
}


@end
