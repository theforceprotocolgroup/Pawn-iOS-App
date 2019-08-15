//
//  BorrowInfoFooterView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/21.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowInfoFooterView.h"
#import "ContentViewModel.h"
@interface BorrowInfoFooterView ()
//
@property (nonatomic, strong) UIView * backView;
//
@property (nonatomic, strong) UIView * lineView;
//
@property (nonatomic, strong) NSMutableArray * viewArr;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) NSArray * modelArr;

@end

@implementation BorrowInfoFooterView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    return ^(NSArray *tuple) {
        self.modelArr = tuple;
        [self setNeedsUpdateConstraints];
    };
}

#pragma mark - View
///=============================================================================
/// @name View
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame model:(id)model action:(KKActionHandle)action {
    if (self = [super initWithFrame:frame]) {
        self.actionHandle = action;
        self.modelArr = model;
        _viewArr = [[NSMutableArray alloc]init];
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.lineView];
    [self addSubview:self.backView];
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
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).priorityHigh();
        make.left.equalTo(self).offset(15).priorityHigh();
        make.right.equalTo(self).offset(-15).priorityHigh();
        make.height.mas_equalTo(0.5).priorityHigh();
    }];
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.lineView.mas_bottom).offset(15).priorityHigh();
        make.left.equalTo(self).offset(15).priorityHigh();
        make.right.equalTo(self).offset(-15).priorityHigh();
        make.bottom.equalTo(self).offset(-15).priorityHigh();
    }];
    
    [self updateContentView];
    
}
-(void)updateContentView
{
    [_backView removeAllSubviews];
    [_viewArr removeAllObjects];
    [_modelArr enumerateObjectsUsingBlock:^(ContentViewModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:contentView];
        UIImageView * icondot = [[UIImageView alloc]init];
        icondot.image = KKImage(@"dot");
        [contentView addSubview:icondot];
        UILabel * title = [[UILabel alloc]init];
        title.font = KKCNFont(12);
        title.textColor = KKHexColor(9197A7);
        title.text = obj.title;
        [contentView addSubview:title];
        UILabel * content = [[UILabel alloc]init];
        content.font = KKCNFont(12);
        content.textColor = KKHexColor(435061);
        content.text = obj.content;
        content.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:content];
        [self.viewArr addObject:contentView];
        [icondot mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contentView);
            make.height.width.mas_equalTo(4);
            make.left.equalTo(contentView).offset(12);
        }];
        [title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contentView);
            make.left.equalTo(icondot.mas_right).offset(7);
            make.top.bottom.equalTo(contentView);
        }];
        [content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contentView);
            make.right.equalTo(contentView).offset(-12);
        }];
    }];
    [self.viewArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:12 leadSpacing:12 tailSpacing:12];
    [self.viewArr mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backView);
    }];
}
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = KKHexColor(E0E0E0);
    }
    return _lineView;
}
-(UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = KKHexColor(F7F9FD);
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5;
    }
    return _backView;
}



#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
