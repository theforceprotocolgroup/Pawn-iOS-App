//
//  LoanSuccessView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanSuccessView.h"
#import "LoanSuccessModel.h"
@interface LoanSuccessView ()
//
@property (nonatomic, strong) UIImageView * successIcon;
//
@property (nonatomic, strong) UILabel * successLabel;
//
@property (nonatomic, strong) UILabel * countLabel;
//
@property (nonatomic, strong) UIView * backView;
//
@property (nonatomic, strong) UIView * contentView;
//
@property (nonatomic, strong) NSArray * contentArr;
//
@property (nonatomic, strong) NSMutableArray * contentItemArr;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) LoanSuccessModel * model;

@end

@implementation LoanSuccessView

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
        self.backgroundColor = KKHexColor(ffffff);
        self.contentArr = self.model.investInfoDetail;
        self.contentItemArr = [[NSMutableArray alloc]init];
        NSString * str= [NSString stringWithFormat:@"%@%@",_model.investedCount,_model.investedTokenType];
        NSMutableAttributedString * attstr = [NSMutableAttributedString string:str];
        [attstr addAttribute:NSFontAttributeName value:KKThirdFont(34) range:NSMakeRange(0, _model.investedCount.length)];
        [attstr addAttribute:NSFontAttributeName value:KKCNFont(15) range:NSMakeRange(_model.investedCount.length, _model.investedTokenType.length)];
        self.countLabel.attributedText = attstr;
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.successIcon];
    [self addSubview:self.successLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.backView];
    [self.backView addSubview:self.contentView];
    [_contentArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * itemView = [[UIView alloc]init];
        itemView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:itemView];
        UILabel*titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = KKHexColor(9097A6);
        titleLabel.text = obj[@"title"];
        titleLabel.font = KKCNFont(12);
        [itemView addSubview:titleLabel];
        [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(itemView);
        }];
        UILabel*contentLabel = [[UILabel alloc]init];
        contentLabel.textColor = KKHexColor(435061);
        contentLabel.text = obj[@"content"];
        contentLabel.font = KKCNFont(12);
        contentLabel.textAlignment = NSTextAlignmentRight;
        [itemView addSubview:contentLabel];
        [contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(itemView);
        }];
        [self.contentItemArr addObject:itemView];
    }];
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
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.countLabel.mas_bottom).offset(25);
        make.bottom.equalTo(self).offset(-20);
    }];
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.right.bottom.equalTo(self.backView);
    }];
    if (_contentItemArr.count) {
        [_contentItemArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:12 leadSpacing:15 tailSpacing:15];
        [_contentItemArr mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
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
        _successLabel.text = @"出借成功";
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

-(UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = KKHexColor(FAFBFF);
    }
    return _backView;
}
-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
