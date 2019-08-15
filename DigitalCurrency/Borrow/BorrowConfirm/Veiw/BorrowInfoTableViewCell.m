//
//  BorrowInfoTableViewCell.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/21.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowInfoTableViewCell.h"
#import "BorrowHomeViewModel.h"
#import "BorrowSliderView.h"
#import "TokenModel.h"
@interface BorrowInfoTableViewCell ()<UITextFieldDelegate>
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UILabel * title;
//
@property (nonatomic, strong) UITextField * textField;
//
@property (nonatomic, strong) UILabel * noteLabel;
//
@property (nonatomic, strong) UIImageView * acIcon;
//
@property (nonatomic, strong) UIView * hLine;
//
@property (nonatomic, strong) NSIndexPath * indexPath;
//
@property (nonatomic, strong) BorrowSliderView * sliderView;
//
@property (nonatomic, strong) NSArray * rateArr;

#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) BorrowHomePageTableViewModel * model;

@end

@implementation BorrowInfoTableViewCell

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
    RACTupleUnpack(BorrowHomePageTableViewModel*model , NSIndexPath *path , NSNumber * islast ,id content) = tuple;
    self.indexPath = path;
    self.model = model;
    self.hLine.hidden = islast.boolValue;
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
        if ([self.model.actionType isEqualToString:@"tap"]) {
            NSMutableAttributedString * attText = [NSMutableAttributedString string:model.content];
            [attText addAttribute:NSFontAttributeName value:KKThirdFont(16) range:NSMakeRange(0, [(NSString*)model.content length] -1)];
            [attText addAttribute:NSFontAttributeName value:KKCNBFont(15) range:NSMakeRange([(NSString*)model.content length] -1, 1)];
            self.textField.attributedText = attText;
        }else if ([self.model.actionType isEqualToString:@"input"])
        {
            self.textField.font = KKThirdFont(16);
            self.textField.text = self.model.content;
            self.noteLabel.text = [NSString stringWithFormat:@"≈%@ %@",content[@"quotesType"],content[@"quotesCount"]];
        }

    }else if([model.content isKindOfClass:[TokenModel class]])
    {
        self.textField.text = [(TokenModel*)model.content symbol];
        UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [rightView sd_setImageWithURL:[NSURL URLWithString:[(TokenModel*)model.content iconURI]]];
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        [backView addSubview:rightView];
        self.textField.leftView = backView;
        self.textField.leftViewMode = UITextFieldViewModeAlways;
    }
    if ([self.model.actionType isEqualToString:@"tap"]) {
        self.acIcon.hidden = NO;
        self.textField.enabled = NO;
        self.sliderView.hidden = YES;
        self.noteLabel.hidden = YES;
        
    }else if ([self.model.actionType isEqualToString:@"input"])
    {
        self.acIcon.hidden = YES;
        self.textField.enabled = YES;
        self.sliderView.hidden = YES;
        self.noteLabel.hidden = NO;

    }else
    {
        self.acIcon.hidden = YES;
        self.textField.enabled = YES;
        self.sliderView.hidden = NO;
        self.textField.textAlignment = NSTextAlignmentCenter;
        self.noteLabel.hidden = YES;
        self.rateArr = content;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
        label.font = KKCNFont(15);
        label.textColor = KKHexColor(0C1E48);
        label.text = @"%";
        _textField.font = KKThirdFont(17);
        _textField.rightViewMode = UITextFieldViewModeAlways;
        _textField.rightView = label;
        _textField.textAlignment = NSTextAlignmentRight;
        NSString * content = model.content;
        _textField.text = [content substringToIndex:content.length-1];
        [_textField setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        //不设置placeholder 保证长度不会过长
        self.textField.attributedPlaceholder = nil;
    }
    if (self.rateArr.count) {
        [self.sliderView viewAction](RACTuplePack(self.rateArr,model.content));
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
    [self.contentView addSubview:self.noteLabel];
    [self.contentView addSubview:self.acIcon];
    [self.contentView addSubview:self.hLine];
    [self.contentView addSubview:self.sliderView];
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
    if (![self.model.actionType isEqualToString:@"slider"]) {
        [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.height.width.mas_equalTo(17);
        }];
    }else
    {
        [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.contentView).offset(22);
            make.left.equalTo(self.contentView).offset(10);
            make.height.width.mas_equalTo(17);
        }];
    }
    [_title setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [_title mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.icon);
        make.left.equalTo(self.icon.mas_right).offset(12);
    }];
    if (![self.model.actionType isEqualToString:@"slider"]) {
        [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.title.mas_right).offset(22);
            make.right.equalTo(self.acIcon.mas_left);
        }];
    }else
    {
        [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.title.mas_bottom).offset(21);
        }];
    }
    [_noteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.textField);
        make.top.equalTo(self.textField.mas_bottom).offset(4);
    }];
    [_acIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-3);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25).priorityHigh();
    }];
    [_hLine mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [_sliderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
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
        _textField.font = KKCNFont(16);
        _textField.textColor = KKHexColor(0C1E48);
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.delegate = self;
        _textField.text = @"";
        @weakify(self);
        [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if (![self.model.actionType isEqualToString:@"input"]) {
                if (x.length) {
                    [self.sliderView valueChanged:x];
                }
            }
        }];
    }
    return _textField;
}
-(UILabel *)noteLabel
{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc]init];
        _noteLabel.textColor = KKHexColor(9FA4B8);
        _noteLabel.font = KKCNFont(10);
    }
    return _noteLabel;
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

-(BorrowSliderView *)sliderView
{
    if (!_sliderView) {
        @weakify(self);
        _sliderView = [BorrowSliderView viewWithModel:nil action:^(RACTuple*  _Nullable x) {
            @strongify(self);
            if ([x.first isEqualToString:@"changed"]) {
                self.textField.text = x.second;
            }else if ([x.first isEqualToString:@"finished"])
            {
                if (self.actionHandle) {
                    self.actionHandle(RACTuplePack(@"slider",x.second));
                }
            }
        }];
    }
    return _sliderView;
}

#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.model.actionType isEqualToString:@"input"]) {
        if (self.actionHandle) {
            self.actionHandle(RACTuplePack(@"input",textField.text.length ? textField.text : @"0"));
        }
    }else if ([self.model.actionType isEqualToString:@"slider"])
    {
        if (self.actionHandle) {
            self.actionHandle(RACTuplePack(@"slider",textField.text.length ? textField.text : @"0"));
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为小数点
            if([textField.text length]==0){
                if(single == '.'){
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
            }
            if([textField.text length]==1 && [textField.text isEqualToString:@"0"]){
                if(single != '.'){
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt=range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}


@end
