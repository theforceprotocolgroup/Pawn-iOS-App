//
//  BorrowMoneyTableViewCell.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/20.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "BorrowMoneyTableViewCell.h"
#import "BorrowMoneyModel.h"
@interface BorrowMoneyTableViewCell ()
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * subTitleLabel;
//
@property (nonatomic, strong) UIImageView * apllyBtn;
//
@property (nonatomic, strong) UILabel * countLabel;
//
@property (nonatomic, strong) UILabel * tokenLabel;
//
@property (nonatomic, strong) UILabel * intervalLabel;
//
@property (nonatomic, strong) UIImageView * bgView;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation BorrowMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================
//更新NSForegroundColorAttributeName
- (void)viewModel:(RACTuple *)tuple action:(nullable KKActionHandle)action {
    BorrowMoneyModel * model = tuple.first;
    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.subTitle;
    
    NSMutableAttributedString * att = [NSMutableAttributedString string:model.count];
    [att addAttributes:@{NSFontAttributeName:KKCNFont(12),NSForegroundColorAttributeName:KKHexColor(697D91)} range:NSMakeRange(0, 4)];
    [att addAttributes:@{NSFontAttributeName:KKCNBFont(14),NSForegroundColorAttributeName:KKHexColor(FF7120)} range:NSMakeRange(4, model.count.length - 4)];
    _countLabel.attributedText = att;
    
    NSMutableAttributedString * att1 = [NSMutableAttributedString string:model.token];
    [att1 addAttributes:@{NSFontAttributeName:KKCNFont(12),NSForegroundColorAttributeName:KKHexColor(697D91)} range:NSMakeRange(0, 4)];
    [att1 addAttributes:@{NSFontAttributeName:KKCNFont(12),NSForegroundColorAttributeName:KKHexColor(111E4B)} range:NSMakeRange(4, model.token.length - 4)];
    _tokenLabel.attributedText = att1;
    
    NSMutableAttributedString * att2 = [NSMutableAttributedString string:model.interval];
    [att2 addAttributes:@{NSFontAttributeName:KKCNFont(12),NSForegroundColorAttributeName:KKHexColor(697D91)} range:NSMakeRange(0, 4)];
    [att2 addAttributes:@{NSFontAttributeName:KKCNFont(12),NSForegroundColorAttributeName:KKHexColor(111E4B)} range:NSMakeRange(4, model.interval.length - 4)];
    
    _bgView.image = KKImage(model.backImg);
    _intervalLabel.attributedText = att2;
    
    self.actionHandle = action;
    [self setNeedsUpdateConstraints];
}

#pragma mark - Init
///=============================================================================
/// @name Init
///=============================================================================

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.equalTo(self);
        }];
        self.contentView.backgroundColor = KKHexColor(f0f4f7);
        [self addViews];
    }
    return self;
}

-(void)addViews
{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.subTitleLabel];
    [self.bgView addSubview:self.apllyBtn];
    [self.bgView addSubview:self.countLabel];
    [self.bgView addSubview:self.tokenLabel];
    [self.bgView addSubview:self.intervalLabel];
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
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.bgView).offset(17);
        make.left.equalTo(self.bgView).offset(71);
    }];
    [_apllyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.bgView).offset(-10);
        make.height.mas_equalTo(37);
        make.width.mas_equalTo(81);
    }];
    [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
    }];
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.tokenLabel.mas_top).offset(-10);
    }];
    [_tokenLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_tokenLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.bgView).offset(-12);
    }];
    [_intervalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.tokenLabel);
        make.left.equalTo(self.tokenLabel.mas_right).offset(41);
        make.right.equalTo(self.bgView).offset(14);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
    }
    return _bgView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNBFont(16);
        _titleLabel.textColor = KKHexColor(111E4B);
    }
    return _titleLabel;
}
-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.font = KKCNBFont(12);
        _subTitleLabel.textColor = KKHexColor(465062);
    }
    return _subTitleLabel;
}
-(UIImageView *)apllyBtn
{
    if (!_apllyBtn) {
        _apllyBtn = [[UIImageView alloc]initWithImage:KKImage(@"borrowmoney_apl")];
    }
    return _apllyBtn;
}
-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
    }
    return _countLabel;
}
-(UILabel *)tokenLabel
{
    if (!_tokenLabel) {
        _tokenLabel = [[UILabel alloc]init];
        _tokenLabel.numberOfLines = 0;
        _tokenLabel.preferredMaxLayoutWidth = SCREEN_WIDTH;
    }
    return _tokenLabel;
}
-(UILabel *)intervalLabel
{
    if (!_intervalLabel) {
        _intervalLabel = [[UILabel alloc]init];
    }
    return _intervalLabel;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
