//
//  MyBorrowDetailView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyBorrowDetailView.h"
#import "MyBorrowDetailModel.h"
#import "MyBorrowDetailCell.h"
@interface MyBorrowDetailView ()
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * countLabel;
//
@property (nonatomic, strong) UILabel * statusLabel;
//
@property (nonatomic, strong) UIView * borrowContentView;
//
@property (nonatomic, strong) UIView * repaymentContentView;
//
@property (nonatomic, strong) UIView * hline;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) MyBorrowDetailModel * model;
/*!  */
@property (nonatomic, strong) NSMutableArray *  borrowArr;
//
@property (nonatomic, strong) NSMutableArray *  repaymentArr;
/*!  */
@property (nonatomic, strong) NSMutableArray *  borrowItemArr;
//
@property (nonatomic, strong) NSMutableArray *  repaymentItemArr;
//
@end

@implementation MyBorrowDetailView

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
        RACTupleUnpack(MyBorrowDetailModel* model)=tuple;
        
        [self removeData];
        
        [self.borrowArr addObjectsFromArray:model.borrowInfo];
        [self.repaymentArr addObjectsFromArray:model.repaymentInfo];
        [self.borrowArr enumerateObjectsUsingBlock:^(NSDictionary  *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyBorrowDetailCell * cell = [MyBorrowDetailCell viewWithModel:obj[@"title"] action:nil];
            [self.borrowContentView addSubview:cell];
            [self.borrowItemArr addObject:cell];
            [cell viewAction](obj[@"content"]);

        }];
        [self.repaymentArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyBorrowDetailCell * cell = [MyBorrowDetailCell viewWithModel:obj[@"title"] action:nil];
            [self.repaymentContentView addSubview:cell];
            [self.repaymentItemArr addObject:cell];
            [cell viewAction](obj[@"content"]);
        }];
        
        self.titleLabel.text = [model titleText];
        self.statusLabel.text = [model statusText];
        self.statusLabel.textColor = [model statusTextColor];
        NSString * countStr = [NSString stringWithFormat:@"%@%@",model.titleCount,model.borrowTokenType];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:countStr];
        [att addAttribute:NSFontAttributeName value:KKThirdFont(25) range:NSMakeRange(0, model.titleCount.length)];
        [att addAttribute:NSFontAttributeName value:KKThirdFont(15) range:NSMakeRange(model.titleCount.length, model.borrowTokenType.length)];
        self.countLabel.attributedText = att;
        self.hline.hidden = self.repaymentArr.count ? NO : YES;
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
        self.borrowArr = [[NSMutableArray alloc]init];
        self.repaymentArr = [[NSMutableArray alloc]init];
        self.borrowItemArr = [[NSMutableArray alloc]init];
        self.repaymentItemArr = [[NSMutableArray alloc]init];
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.statusLabel];
    
    [self addSubview:self.borrowContentView];
    [self addSubview:self.hline];
    [self addSubview:self.repaymentContentView];

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
    [_borrowContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(36);
        make.left.right.equalTo(self);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.borrowContentView.mas_bottom).offset(21);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    if (_borrowItemArr.count) {
        [_borrowItemArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:22 leadSpacing:0 tailSpacing:0];
        [_borrowItemArr mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.borrowContentView).offset(15);
            make.right.equalTo(self.borrowContentView).offset(-15);
        }];
    }

    if (_repaymentItemArr.count) {
        [_repaymentContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.hline.mas_bottom).offset(20);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-20);
        }];
        [_repaymentItemArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:22 leadSpacing:0 tailSpacing:0];
        [_repaymentItemArr mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.repaymentContentView).offset(15);
            make.right.equalTo(self.repaymentContentView).offset(-15);
        }];
    }else
    {
        [_borrowContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.statusLabel.mas_bottom).offset(36);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-21);
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
-(UIView *)borrowContentView
{
    if (!_borrowContentView) {
        _borrowContentView = [[UIView alloc]init];
        _borrowContentView.backgroundColor = [UIColor clearColor];
    }
    return _borrowContentView;
}
-(UIView *)repaymentContentView
{
    if (!_repaymentContentView) {
        _repaymentContentView = [[UIView alloc]init];
        _repaymentContentView.backgroundColor = [UIColor clearColor];
    }
    return _repaymentContentView;
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

-(void)removeData
{
    [self.borrowArr removeAllObjects];
    [self.repaymentArr removeAllObjects];
    
    [self.borrowItemArr enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.repaymentItemArr enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.borrowItemArr removeAllObjects];
    [self.repaymentItemArr removeAllObjects];
}



@end
