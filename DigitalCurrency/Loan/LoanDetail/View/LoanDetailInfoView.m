//
//  LoanDetailInfoView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/2.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "LoanDetailInfoView.h"
#import "LoanDetailInfoViewModel.h"
#import "LoanInfoOrderInfoModel.h"
@interface LoanDetailInfoView ()
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UIImageView * tokenIcon;
//
@property (nonatomic, strong) UILabel * tokenTitle;
//
@property (nonatomic, strong) UILabel * rateLabel;
//
@property (nonatomic, strong) UILabel * rateUnitLabel;
//
@property (nonatomic, strong) UIView * contentView;
//
@property (nonatomic, strong) UIImageView * backGroundView;
//
@property (nonatomic, strong) NSMutableArray * contentArr;
//
@property (nonatomic, strong) NSMutableArray * contentItemArr;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) LoanInfoOrderInfoModel* model;

@end

@implementation LoanDetailInfoView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    return ^(LoanInfoOrderInfoModel *tuple) {
        [self.contentArr removeAllObjects];
        LoanDetailInfoViewModel * model1 = [[LoanDetailInfoViewModel alloc]init];
        model1.title = [NSString stringWithFormat:@"出借金额(%@)",tuple.borrowType];
        model1.content = tuple.borrowCount;
        [self.contentArr addObject:model1];
        LoanDetailInfoViewModel * model2 = [[LoanDetailInfoViewModel alloc]init];
        model2.title = [NSString stringWithFormat:@"到期收益(%@)",tuple.borrowType];
        model2.content = tuple.expected;
        [self.contentArr addObject:model2];
        LoanDetailInfoViewModel * model3 = [[LoanDetailInfoViewModel alloc]init];
        model3.title = [NSString stringWithFormat:@"出借周期(%@)",@"天"];
        model3.content = tuple.interval;
        [self.contentArr addObject:model3];
        
        NSString * str = [NSString stringWithFormat:@"%@%%",tuple.dailyRate];
        NSMutableAttributedString * attstr = [NSMutableAttributedString string:str];
        [attstr addAttribute:NSFontAttributeName value:KKThirdFont(40) range:NSMakeRange(0, str.length-1)];
        [attstr addAttribute:NSFontAttributeName value:KKCNFont(23) range:NSMakeRange(str.length-1, 1)];
        [attstr addAttribute:NSForegroundColorAttributeName value:KKHexColor(ffffff) range:NSMakeRange(0, str.length)];
        self.rateLabel.attributedText = attstr;
        [self.tokenIcon sd_setImageWithURL:[NSURL URLWithString:tuple.iconURI]];
        self.tokenTitle.text =[NSString stringWithFormat:@"%@借币",tuple.borrowType] ;
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
        self.model = model;
        [self addViews];
        self.contentArr = [[NSMutableArray alloc]init];
        self.contentItemArr = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.backGroundView];
    [self.backGroundView addSubview:self.titleView];
    [self.titleView addSubview:self.tokenTitle];
    [self.titleView addSubview:self.tokenIcon];
    [self.backGroundView addSubview:self.rateLabel];
    [self.backGroundView addSubview:self.rateUnitLabel];
    [self.backGroundView addSubview:self.contentView];
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
    [_backGroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.top.left.bottom.equalTo(self);
    }];
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.backGroundView);
        make.top.equalTo(self.backGroundView).offset(16+Height_StatusBar);
    }];
    [_tokenIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleView);
        make.top.bottom.equalTo(self.titleView);
        make.height.width.mas_equalTo(20);
    }];
    [_tokenTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.tokenIcon.mas_right).offset(12);
        make.right.equalTo(self.titleView);
        make.centerY.equalTo(self.titleView);
    }];
    [_rateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.backGroundView);
        make.top.equalTo(self.titleView.mas_bottom).offset(iPhone5 ? 5: 36);
    }];
    [_rateUnitLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.backGroundView);
        make.top.equalTo(self.rateLabel.mas_bottom).offset(12);
    }];
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.rateUnitLabel.mas_bottom).offset(iPhone5 ? 30 :47);
        make.left.right.equalTo(self.backGroundView);
        make.bottom.equalTo(self.backGroundView).offset(-73);
    }];
    if (_contentArr.count) {
        [self setUpItem];
    }
}
-(void)setUpItem
{
    __weak typeof(self) weakSelf = self;
    [_contentItemArr enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_contentItemArr removeAllObjects];
    [_contentArr enumerateObjectsUsingBlock:^(LoanDetailInfoViewModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * itemView = [[UIView alloc]init];
        itemView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:itemView];
        UILabel * title = [[UILabel alloc]init];
        title.font = KKThirdFont(17);
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = [NSString stringWithFormat:@"%@",obj.content];
        [itemView addSubview:title];
        
        UILabel * content = [[UILabel alloc]init];
        content.font = KKCNFont(12);
        content.textColor = [KKHexColor(ffffff) colorWithAlphaComponent:0.5];
        content.textAlignment = NSTextAlignmentCenter;
        content.text = [NSString stringWithFormat:@"%@",obj.title];
        [itemView addSubview:content];
        
        [title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemView.mas_top);
            make.centerX.equalTo(itemView);
        }];
        [content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(itemView.mas_bottom);
            make.centerX.equalTo(itemView);
            make.top.equalTo(title.mas_bottom).offset(8);
            
        }];
        [self.contentItemArr addObject:itemView];
    }];
    [self.contentItemArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:((SCREEN_WIDTH-30)/3) leadSpacing:0 tailSpacing:0];
    [self.contentItemArr mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
    }];
}
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    return _titleView;
}
-(UIImageView *)tokenIcon
{
    if (!_tokenIcon) {
        _tokenIcon = [[UIImageView alloc]init];
    }
    return _tokenIcon;
}
-(UILabel *)tokenTitle
{
    if (!_tokenTitle) {
        _tokenTitle = [[UILabel alloc]init];
        _tokenTitle.textColor = [UIColor whiteColor];
        _tokenTitle.font = KKCNFont(16);
        _tokenTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _tokenTitle;
}
-(UILabel *)rateLabel
{
    if (!_rateLabel) {
        _rateLabel = [[UILabel alloc]init];
        _rateLabel.textAlignment = NSTextAlignmentCenter;
        _rateLabel.textColor = [UIColor whiteColor];
    }
    return _rateLabel;
}
-(UILabel *)rateUnitLabel
{
    if (!_rateUnitLabel) {
        _rateUnitLabel = [[UILabel alloc]init];
        _rateUnitLabel.textAlignment = NSTextAlignmentCenter;
        _rateUnitLabel.font = KKCNFont(12);
        _rateUnitLabel.textColor = [UIColor whiteColor];
        _rateUnitLabel.text = @"约定日利率";
    }
    return _rateUnitLabel;
}
-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}
-(UIImageView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIImageView alloc]initWithImage:KKImage(@"loan_detail_bg")];
    }
    return _backGroundView;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
