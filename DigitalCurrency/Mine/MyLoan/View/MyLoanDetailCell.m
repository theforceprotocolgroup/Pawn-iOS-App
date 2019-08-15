//
//  MyLoanDetailCell.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/6.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyLoanDetailCell.h"

@interface MyLoanDetailCell ()
//
@property (nonatomic, strong) UILabel * title;
//
@property (nonatomic, strong) UILabel * content;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation MyLoanDetailCell

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
    return ^(NSString *tuple) {
        @strongify(self);
        self.content.text = tuple;
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
        self.title.text = model;
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.title];
    [self addSubview:self.content];
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
    [_title setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_title mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).priorityHigh();
        make.top.equalTo(self);
    }];
    [_content mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self);
        make.left.equalTo(self.title.mas_right).offset(15);
        make.right.equalTo(self).priorityHigh();
        make.bottom.equalTo(self);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = KKHexColor(9197A7);
        _title.font = KKCNFont(13);
    }
    return _title;
}
-(UILabel *)content
{
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.textColor = KKHexColor(223452);
        _content.font = KKCNFont(13);
        _content.numberOfLines = 0;
        _content.preferredMaxLayoutWidth = SCREEN_WIDTH;
    }
    return _content;
}


#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
