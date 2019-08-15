//
//  BorrowHomePageTableViewCell.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/16.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowHomePageTableViewCell.h"
#import "BorrowHomeViewModel.h"
#import "TokenModel.h"
@interface BorrowHomePageTableViewCell ()
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UILabel * title;
//
@property (nonatomic, strong) UITextField * textField;
//
@property (nonatomic, strong) UIImageView * acIcon;
//
@property (nonatomic, strong) UIView * hLine;
//
@property (nonatomic, strong) NSIndexPath * indexPath;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) BorrowHomePageTableViewModel * model;

@end

@implementation BorrowHomePageTableViewCell

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
    RACTupleUnpack(BorrowHomePageTableViewModel*model , NSIndexPath *path) = tuple;
    self.indexPath = path;
    self.model =model;
    if (self.model.title.length >= 4) {
        self.title.text = self.model.title;
    }else
    {
        NSMutableAttributedString * str = [NSMutableAttributedString string:self.model.title];
        [str addAttribute:NSKernAttributeName value:@((4.0f-str.length)*15.0f/(str.length -1))range:NSMakeRange(0, str.length)];
        self.title.attributedText = str;
    }
    self.icon.image = KKImage(self.model.icon);
    NSMutableAttributedString * att = KKMultiAttriString(self.model.placeholder).kkFont(KKCNFont(12)).kkColor(KKHexColor(C7CED9));
    self.textField.attributedPlaceholder = att;
    if ([model.content isKindOfClass:[NSString class]]) {
        self.textField.text = model.content;
        self.textField.font = KKThirdFont(16);
    }else if([model.content isKindOfClass:[TokenModel class]])
    {
        self.textField.font = KKCNFont(15);
        self.textField.text = [(TokenModel*)model.content symbol];
        UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [rightView sd_setImageWithURL:[NSURL URLWithString:[(TokenModel*)model.content iconURI]]];
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        [backView addSubview:rightView];
        self.textField.leftView = backView;
        self.textField.leftViewMode = UITextFieldViewModeAlways;
    }
        
    if ([self.model.actionType isEqualToString:@"tap"]||[self.model.actionType isEqualToString:@"slider"]) {
        self.acIcon.hidden = NO;
        self.textField.enabled = NO;
    }else
    {
        self.acIcon.hidden = YES;
        self.textField.enabled = YES;
    }
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
        self.contentView.backgroundColor = KKHexColor(ffffff);
        [self addViews];
    }
    return self;
}

-(void)addViews
{
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.acIcon];
    [self.contentView addSubview:self.hLine];
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
    [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.height.width.mas_equalTo(17);
    }];
    [_title setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_title mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.icon.mas_right).offset(12);
    }];
    [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.title.mas_right).offset(22);
        make.right.equalTo(self.acIcon.mas_left);
    }];
    [_acIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-3);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25).priorityHigh();
    }];
    [_hLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.right.bottom.equalTo(self.contentView);
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

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = KKCNFont(15);
        _title.textColor = KKHexColor(666666);
    }
    return _title;
}
-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}
-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = KKThirdFont(16);
        _textField.textColor = KKHexColor(0C1E48);
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        @weakify(self);
        [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if (self.actionHandle) {
                self.actionHandle(x);
            }
        }];
    }
    return _textField;
}
-(UIImageView *)acIcon
{
    if (!_acIcon) {
        _acIcon = [[UIImageView alloc]initWithImage:KKImage(@"leftArrow")];
    }
    return _acIcon;
}
-(UIView *)hLine
{
    if (!_hLine) {
        _hLine = [[UIView alloc]init];
        _hLine.backgroundColor = KKHexColor(E0E0E0);
    }
    return _hLine;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
