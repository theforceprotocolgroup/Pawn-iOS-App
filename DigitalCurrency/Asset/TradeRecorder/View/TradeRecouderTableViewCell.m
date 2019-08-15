//
//  TradeRecouderTableViewCell.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/8.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "TradeRecouderTableViewCell.h"
#import "TradeRecouderModel.h"

@interface TradeRecouderTableViewCell ()
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * statusLabel;
//
@property (nonatomic, strong) UILabel * line1Title;
//
@property (nonatomic, strong) UILabel * line1Content;
//
@property (nonatomic, strong) UILabel * line2Title;
//
@property (nonatomic, strong) UILabel * line2Content;
//
@property (nonatomic, strong) UIView * line1View;
//
@property (nonatomic, strong) UIView * line2View;
//
@property (nonatomic, strong) UIView * hline;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) TradeRecouderModel * model;

@end

@implementation TradeRecouderTableViewCell

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
//更新
- (void)viewModel:(RACTuple *)tuple action:(nullable KKActionHandle)action {
    self.model = tuple.first;
    [_icon sd_setImageWithURL:[NSURL URLWithString:_model.iconURI]];
    _titleLabel.text = [NSString stringWithFormat:@"%@%@",_model.tokenSymbol,_model.TxTypeInfo];
    _statusLabel.textColor = [_model.TxType isEqualToString:@"1"] ?  KKHexColor(16AC3E) : KKHexColor(E84A55);
    NSString * status = [NSString stringWithFormat:@"%@%@%@",[_model.TxType isEqualToString:@"1"] ? @"+" : @"-",_model.tokenCount,_model.tokenSymbol];
    NSMutableAttributedString * attr = [NSMutableAttributedString string:status];
    [attr addAttribute:NSFontAttributeName value:KKCNBFont(17) range:NSMakeRange(0, _model.tokenCount.length+1)];
    [attr addAttribute:NSFontAttributeName value:KKCNFont(15) range:NSMakeRange(_model.tokenCount.length+1, _model.tokenSymbol.length)];
    _statusLabel.attributedText = attr;
    if (_model.TxDescription.count >= 2) {
        _line1Title.text = _model.TxDescription[0][@"title"];
        _line1Content.text = _model.TxDescription[0][@"content"];
        _line2Title.text = _model.TxDescription[1][@"title"];
        _line2Content.text = _model.TxDescription[1][@"content"];
        NSString * url0 = _model.TxDescription[0][@"url"];
        _line1Content.textColor =  url0.length ? KKRGB(87, 150, 207) : KKHexColor(435061);
        NSString * url1 = _model.TxDescription[1][@"url"];
        _line2Content.textColor = url1.length ? KKRGB(87, 150, 207) : KKHexColor(435061);
    }    
    self.actionHandle = action;
    [self.contentView setNeedsLayout];
    [self setNeedsUpdateConstraints];
}

#pragma mark - Init
///=============================================================================
/// @name Init
///=============================================================================

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH).priorityHigh();
        }];
        self.contentView.backgroundColor = KKHexColor(ffffff);
        [self addViews];
    }
    return self;
}

-(void)addViews
{
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.line1View];
    [self.line1View addSubview:self.line1Title];
    [self.line1View addSubview:self.line1Content];
    [self.contentView addSubview:self.line2View];
    [self.line2View addSubview:self.line2Title];
    [self.line2View addSubview:self.line2Content];
    [self.contentView addSubview:self.hline];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================

- (void)updateConstraints {
    [super updateConstraints];
    [self updateLayout];

}

- (void)updateLayout {
    @weakify(self);
    [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.height.width.mas_equalTo(20);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.centerY.equalTo(self.icon);
    }];
    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    
    [_line1Title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_line2Title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [_line1View mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.icon.mas_bottom).offset(28);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [_line1Title mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.line1View);
        make.top.equalTo(self.line1View);
        make.right.equalTo(self.line1Content.mas_left).offset(-16);
    }];
    [_line1Content mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.line1View);
        make.right.equalTo(self.line1View);
        make.bottom.equalTo(self.line1View);
    }];
    
    
    [_line2View mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.line1View.mas_bottom).offset(12);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        //解决contentView.height == 44冲突
        make.bottom.equalTo(self.contentView).offset(-24).priorityHigh();
    }];
    
    [_line2Title mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.line2View);
        make.top.equalTo(self.line2View);
        make.right.equalTo(self.line2Content.mas_left).offset(-16);
    }];
    [_line2Content mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.line2View);
        make.right.equalTo(self.line2View);
        make.bottom.equalTo(self.line2View);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = KKHexColor(031E45);
        _titleLabel.font = KKCNBFont(15);
    }
    return _titleLabel;
}
-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = KKCNBFont(17);
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}
-(UILabel *)line1Title
{
    if (!_line1Title) {
        _line1Title = [[UILabel alloc]init];
        _line1Title.textColor = KKHexColor(9197A7);
        _line1Title.font = KKCNBFont(13);
    }
    return _line1Title;
}
-(UILabel *)line2Title
{
    if (!_line2Title) {
        _line2Title = [[UILabel alloc]init];
        _line2Title.textColor = KKHexColor(9197A7);
        _line2Title.font = KKCNBFont(13);
    }
    return _line2Title;
}
-(UILabel *)line1Content
{
    if (!_line1Content) {
        _line1Content = [[UILabel alloc]init];
        _line1Content.textColor = KKHexColor(435061);
        _line1Content.font = KKCNFont(13);
        _line1Content.numberOfLines = 0;
        _line1Content.preferredMaxLayoutWidth = SCREEN_WIDTH;
        @weakify(self);

        [_line1Content kkAddTapAction:^(id  _Nullable x) {
            @strongify(self);
            if (self.model.TxDescription.count >= 2 && self.model.TxDescription[0][@"url"]) {
                [KKRouter pushUri:self.model.TxDescription[0][@"url"]];
            }
        }];
    }
    return _line1Content;
}
-(UILabel *)line2Content
{
    if (!_line2Content) {
        _line2Content = [[UILabel alloc]init];
        _line2Content.textColor = KKHexColor(435061);
        _line2Content.font = KKCNFont(13);
        _line2Content.numberOfLines = 0;
        //能换行的动态计算高度一定要设置此属性，否则计算不准确
        _line2Content.preferredMaxLayoutWidth = SCREEN_WIDTH;
        @weakify(self);
        [_line2Content kkAddTapAction:^(id  _Nullable x) {
            @strongify(self);
            if (self.model.TxDescription.count >= 2 && self.model.TxDescription[1][@"url"]) {
                [KKRouter pushUri:self.model.TxDescription[1][@"url"]];
            }
        }];
    }
    return _line2Content;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _hline;
}
-(UIView *)line2View
{
    if (!_line2View) {
        _line2View = [[UIView alloc]init];
        _line2View.backgroundColor = [UIColor clearColor];
    }
    return _line2View;
}
-(UIView *)line1View
{
    if (!_line1View) {
        _line1View = [[UIView alloc]init];
        _line1View.backgroundColor = [UIColor clearColor];
    }
    return _line1View;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
