//
//  AssetHomePageHeaderView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/5.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "AssetHomePageHeaderView.h"

@interface AssetHomePageHeaderView ()
//
@property (nonatomic, strong) UIImageView * backgroundView;
//
@property (nonatomic, strong) UIView * navView;
//
@property (nonatomic, strong) UILabel * navTitleLabel;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * countLabel;
//
@property (nonatomic, strong) UILabel * quoetsLabel;
//
@property (nonatomic, strong) UIView * contentView;
//
@property (nonatomic, strong) NSMutableArray * contentItemArr;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) NSArray * model;

@end

@implementation AssetHomePageHeaderView

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
        RACTupleUnpack(NSString * quoetsTotleType,NSString * quoetsTotle,NSString*quoetsType,NSString*quoetsCount) = tuple;
        self.titleLabel.text = [NSString stringWithFormat:@"钱包总资产（折合%@）",quoetsTotleType];
        NSString *tempStr = [NSString stringWithFormat:@"%@%@",quoetsTotle,quoetsTotleType];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:tempStr];
        [att addAttributes:@{NSFontAttributeName:KKThirdFont(24),
                                NSForegroundColorAttributeName:KKHexColor(ffffff)
                                } range:NSMakeRange(0, quoetsTotle.length)];
        [att addAttributes:@{NSFontAttributeName:KKCNBFont(20),
                                NSForegroundColorAttributeName:KKHexColor(ffffff)
                                } range:NSMakeRange(quoetsTotle.length, quoetsTotleType.length)];
        self.countLabel.attributedText = att;
        self.quoetsLabel.text = [NSString stringWithFormat:@"≈%@ %@",quoetsType,quoetsCount];
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
        self.contentItemArr = [[NSMutableArray alloc]init];
        
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.navView];
    [self.navView addSubview:self.navTitleLabel];
    [self.backgroundView addSubview:self.titleLabel];
    [self.backgroundView addSubview:self.countLabel];
    [self.backgroundView addSubview:self.quoetsLabel];
    [self.backgroundView addSubview:self.contentView];
    [self addContentView];
}
-(void)addContentView
{
    @weakify(self);
    [_model enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:backView];
        [backView kkAddTapAction:^(id  _Nullable x) {
            if (self.actionHandle) {
                self.actionHandle(obj[@"url"]);
            }
        }];
        
        UIImageView * icon = [[UIImageView alloc]initWithImage:KKImage(obj[@"icon"])];
        [backView addSubview:icon];
        [icon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.height.width.mas_equalTo(30).priorityHigh();
            make.top.equalTo(backView).priorityHigh();
        }];
        
        UILabel * lebal = [[UILabel alloc]init];
        lebal.text = obj[@"title"];
        lebal.textColor = KKHexColor(ffffff);
        lebal.font = KKCNFont(12);
        lebal.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:lebal];
        [lebal mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.top.equalTo(icon.mas_bottom).offset(3);
            make.bottom.equalTo(backView).priorityHigh();
        }];
        
        [self.contentItemArr addObject:backView];
    }];
    [self.contentItemArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:30 leadSpacing:45 tailSpacing:45];
    [self.contentItemArr mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
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
    [_backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.left.right.top.bottom.equalTo(self);
    }];
    [_navView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self.backgroundView);
        make.height.mas_equalTo(Height_NavBar);
    }];
    [_navTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.navView).offset(15);
        make.centerY.equalTo(self.navView.mas_bottom).offset(-22);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.backgroundView);
        make.top.equalTo(self.navView.mas_bottom);
    }];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.backgroundView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
    }];
    [_quoetsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.backgroundView);
        make.top.equalTo(self.countLabel.mas_bottom).offset(3);
    }];
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.left.bottom.equalTo(self.backgroundView);
        make.height.mas_equalTo(65);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc]initWithImage:KKImage(@"asset_home_bg")];
        _backgroundView.userInteractionEnabled = YES;
    }
    return _backgroundView;
}
-(UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc]init];
        _navView.backgroundColor = [UIColor clearColor];
    }
    return _navView;
}
-(UILabel *)navTitleLabel
{
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc]init];
        _navTitleLabel.font = KKCNBFont(22);
        _navTitleLabel.textColor = KKHexColor(ffffff);
        _navTitleLabel.text = @"资产";
    }
    return _navTitleLabel;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNFont(13);
        _titleLabel.textColor = KKHexColor(B7C1EB);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = KKHexColor(ffffff);
    }
    return _countLabel;
}
-(UILabel *)quoetsLabel
{
    if (!_quoetsLabel) {
        _quoetsLabel = [[UILabel alloc]init];
        _quoetsLabel.font = KKThirdFont(10);
        _quoetsLabel.textAlignment = NSTextAlignmentCenter;
        _quoetsLabel.textColor = KKHexColor(FEFEFE);
    }
    return _quoetsLabel;
}
-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [KKHexColor(B2BCE6) colorWithAlphaComponent:0.2f];
    }
    return _contentView;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
