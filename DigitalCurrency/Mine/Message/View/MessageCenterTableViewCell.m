//
//  MessageCenterTableViewCell.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/16.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MessageCenterTableViewCell.h"
#import "MessageCenterListModel.h"
@interface MessageCenterTableViewCell ()
//
@property (nonatomic, strong) UIView * backView;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * subTitleLabel;
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UILabel * noteLabel;
//
@property (nonatomic, strong) UIImageView * accessIcon;
//
@property (nonatomic, strong) UIView * readView;
//
@property (nonatomic, strong) UILabel * timeLabel;

#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) MessageCenterListModel * model;

@end

@implementation MessageCenterTableViewCell

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
- (void)viewModel:(MessageCenterListModel *)tuple action:(nullable KKActionHandle)action {
    self.model = tuple;
    self.titleLabel.text = self.model.noticeTitle;
    self.subTitleLabel.text = self.model.noticeContent;
    self.actionHandle = action;
    self.readView.hidden = self.model.noticeIsRead;
    self.timeLabel.text = self.model.sentTime;
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
        self.contentView.backgroundColor = KKHexColor(F5F6F7);
        [self addViews];
    }
    return self;
}

-(void)addViews
{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.subTitleLabel];
    [self.backView addSubview:self.hline];
    [self.backView addSubview:self.noteLabel];
    [self.backView addSubview:self.accessIcon];
    [self.backView addSubview:self.readView];
    [self.backView addSubview:self.timeLabel];
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
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.backView).offset(13);
        make.left.equalTo(self.backView).offset(15);
    }];
    [_readView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.width.mas_equalTo(7);
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.titleLabel.mas_top).offset(2);
    }];
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.accessIcon.mas_left).offset(-15);
        make.centerY.equalTo(self.noteLabel.mas_centerY);
    }];
    [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.right.equalTo(self.backView).offset(-15);
        make.left.equalTo(self.backView).offset(15);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(15);
        make.right.equalTo(self.backView).offset(-15);
        make.left.equalTo(self.backView).offset(15);
        make.height.mas_equalTo(0.5);
    }];
    [_noteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.hline.mas_bottom).offset(15);
        make.right.equalTo(self.backView).offset(-15);
        make.left.equalTo(self.backView).offset(15);
        make.bottom.equalTo(self.backView).offset(-15).priorityHigh();
    }];
    [_accessIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.noteLabel);
        make.right.equalTo(self.backView).offset(-7);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = KKHexColor(ffffff);
        _backView.layer.masksToBounds = YES;
        _backView.layer.borderColor = KKHexColor(e0e0e0).CGColor;
        _backView.layer.borderWidth = 1.0f;
    }
    return _backView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = KKHexColor(041E45);
        _titleLabel.font = KKCNBFont(15);
        _titleLabel.numberOfLines = 0 ;
        _titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 60;
    }
    return _titleLabel;
}
-(UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = KKHexColor(9197A7);
        _subTitleLabel.font = KKCNBFont(13);
        _subTitleLabel.numberOfLines = 0 ;
        _subTitleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 60;
    }
    return _subTitleLabel;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _hline;
}
-(UILabel *)noteLabel
{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc]init];
        _noteLabel.textColor = KKHexColor(C7CED9);
        _noteLabel.font = KKCNBFont(12);
        _noteLabel.text = @"查看详情";
    }
    return _noteLabel;
}
-(UIImageView *)accessIcon
{
    if (!_accessIcon) {
        _accessIcon = [[UIImageView alloc]initWithImage:KKImage(@"leftArrow")];
    }
    return _accessIcon;
}
-(UIView *)readView
{
    if (!_readView) {
        _readView = [[UIView alloc]init];
        _readView.backgroundColor = KKHexColor(E84A55);
        _readView.layer.masksToBounds = YES;
        _readView.layer.cornerRadius = 3.5f;
    }
    return _readView;
}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = KKHexColor(C7CED9);
        _timeLabel.font = KKCNBFont(12);
    }
    return _timeLabel;

}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
