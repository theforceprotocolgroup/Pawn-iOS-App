//
//  MyLoanDetailView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/6.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyLoanDetailView.h"
#import "MyLoanDetailModel.h"
#import "MyLoanDetailCell.h"
@interface MyLoanDetailView ()
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * countLabel;
//
@property (nonatomic, strong) UILabel * statusLabel;
//
@property (nonatomic, strong) UIView * loanContentView;
//
@property (nonatomic, strong) UIView * incomeContentView;
//
@property (nonatomic, strong) UIView * hline;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) NSMutableArray *  loanArr;
//
@property (nonatomic, strong) NSMutableArray *  incomeArr;
/*!  */
@property (nonatomic, strong) NSMutableArray *  loanItemArr;
//
@property (nonatomic, strong) NSMutableArray *  incomeItemArr;
//
@property (nonatomic, strong) MyLoanDetailModel * model;
@end

@implementation MyLoanDetailView

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
        RACTupleUnpack(MyLoanDetailModel* model)=tuple;
        
        [model.lendInfo enumerateObjectsUsingBlock:^(NSDictionary  *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyLoanDetailCell * cell = [MyLoanDetailCell viewWithModel:obj[@"title"] action:nil];
            [cell viewAction](obj[@"content"]);
            [self.loanContentView addSubview:cell];
            [self.loanItemArr addObject:cell];
        }];
        [model.collectInfo enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyLoanDetailCell * cell = [MyLoanDetailCell viewWithModel:obj[@"title"] action:nil];
            [cell viewAction](obj[@"content"]);
            [self.incomeContentView addSubview:cell];
            [self.incomeItemArr addObject:cell];
        }];
        
        self.statusLabel.text = [model statusText];
        self.statusLabel.textColor = [model statusColer];
        NSString * countStr = [NSString stringWithFormat:@"%@%@",model.investedCount,model.investedCoinType];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:countStr];
        [att addAttribute:NSFontAttributeName value:KKThirdFont(25) range:NSMakeRange(0, model.investedCount.length)];
        [att addAttribute:NSFontAttributeName value:KKThirdFont(15) range:NSMakeRange(model.investedCount.length, model.investedCoinType.length)];
        self.countLabel.attributedText = att;
        [self setNeedsUpdateConstraints];
    };
}

#pragma mark - View
///=============================================================================
/// @name View
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame model:(RACTuple *)model action:(KKActionHandle)action {
    if (self = [super initWithFrame:frame]) {
        self.actionHandle = action;
        self.backgroundColor = [UIColor whiteColor];
        self.loanArr = [NSMutableArray arrayWithArray:model.first];
        self.incomeArr = [NSMutableArray arrayWithArray:model.second];
        self.loanItemArr = [[NSMutableArray alloc]init];
        self.incomeItemArr = [[NSMutableArray alloc]init];
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.statusLabel];

    [self addSubview:self.loanContentView];
    [self addSubview:self.hline];
    [self addSubview:self.incomeContentView];
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
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(26);
    }];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
    }];
    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.countLabel.mas_bottom).offset(16);
    }];
    [_loanContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(36);
        make.left.right.equalTo(self);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.loanContentView.mas_bottom).offset(21);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    [_incomeContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.hline.mas_bottom).offset(20);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
    }];
    if (_loanItemArr.count) {
        [_loanItemArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:22 leadSpacing:0 tailSpacing:0];
        [_loanItemArr mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.loanContentView).offset(15);
            make.right.equalTo(self.loanContentView).offset(-15);
        }];
    }
    if (_incomeItemArr.count) {
        [_incomeItemArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:22 leadSpacing:0 tailSpacing:0];
        [_incomeItemArr mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.incomeContentView).offset(15);
            make.right.equalTo(self.incomeContentView).offset(-15);
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

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = KKHexColor(0C1E48);
        _titleLabel.font = KKCNFont(16);
        _titleLabel.text = @"回款金额";
    }
    return _titleLabel;
}
-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.textColor = KKHexColor(041E45);
    }
    return _countLabel;
}
-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = KKCNFont(15);
    }
    return _statusLabel;
}
-(UIView *)loanContentView
{
    if (!_loanContentView) {
        _loanContentView = [[UIView alloc]init];
        _loanContentView.backgroundColor = [UIColor clearColor];
    }
    return _loanContentView;
}
-(UIView *)incomeContentView
{
    if (!_incomeContentView) {
        _incomeContentView = [[UIView alloc]init];
        _incomeContentView.backgroundColor = [UIColor clearColor];
    }
    return _incomeContentView;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _hline;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
