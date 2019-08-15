//
//  WithdrawContentView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "WithdrawContentView.h"
#import "WithdrawModel.h"

@interface WithdrawContentView ()<UITextFieldDelegate>
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UITextField * addressTextField;
//
@property (nonatomic, strong) UIView * addressLineView;
//
@property (nonatomic, strong) UIButton * addressBtn;
//
@property (nonatomic, strong) UILabel * countTitleLabel;
//
@property (nonatomic, strong) UITextField * countFeild;
//
@property (nonatomic, strong) UIButton * countBtn;
//
@property (nonatomic, strong) UILabel * quoetsLabel;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) WithdrawModel * model;

@end

@implementation WithdrawContentView

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
        RACTupleUnpack(WithdrawModel * model , NSString * address) = tuple;
        self.quoetsLabel.text = [NSString stringWithFormat:@"%@ %@",model.quoteType , model.quotesCount];
        if (address.length) {
            self.addressTextField.text = address;
        }
        self.model = model;
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
        self.backgroundColor = KKHexColor(ffffff);
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.addressTextField];
    [self addSubview:self.addressBtn];
    [self addSubview:self.addressLineView];
    [self addSubview:self.countBtn];
    [self addSubview:self.countTitleLabel];
    [self addSubview:self.countFeild];
    [self addSubview:self.quoetsLabel];
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
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
    }];
    
    [_addressTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.equalTo(self).offset(15);
    }];
    [_addressBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.addressTextField);
        make.height.width.mas_equalTo(24);
        make.left.equalTo(self.addressTextField.mas_right);
    }];
    [_addressLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.addressTextField.mas_bottom).offset(5);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    [_countTitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_countBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [_countTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.addressLineView.mas_bottom).offset(23);
        make.left.equalTo(self).offset(15);
    }];
    [_countFeild mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.countTitleLabel);
        make.left.equalTo(self.countTitleLabel.mas_right).offset(30);
    }];
    [_quoetsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.countFeild.mas_bottom).offset(5);
        make.left.equalTo(self.countFeild);
        make.right.equalTo(self.countBtn.mas_left);
        make.bottom.equalTo(self).offset(-6);
    }];
    [_countBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.countTitleLabel);
        make.left.equalTo(self.countFeild.mas_right);
    }];
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
        _titleLabel.font = KKCNBFont(15);
        _titleLabel.textColor = KKHexColor(8F97A6);
        _titleLabel.text = @"转出地址";
    }
    return _titleLabel;
}

-(UIView *)addressLineView
{
    if (!_addressLineView) {
        _addressLineView = [[UIView alloc]init];
        _addressLineView.backgroundColor = KKHexColor(e0e0e0);
    }
    return _addressLineView;
}
-(UITextField *)addressTextField
{
    if (!_addressTextField) {
        _addressTextField = [[UITextField alloc]init];
        _addressTextField.font = KKCNFont(14);
        _addressTextField.textColor = KKHexColor(0C1E48);
        [_addressTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            if (self.actionHandle) {
                self.actionHandle(RACTuplePack(@"address",x));
            }
        }];
    }
    return _addressTextField;
}
-(UIButton *)addressBtn
{
    if (!_addressBtn) {
        _addressBtn = [[UIButton alloc]init];
        [_addressBtn setImage:KKImage(@"scan_icon") forState:UIControlStateNormal];
        [_addressBtn addTarget:self action:@selector(clickedScan) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressBtn;
}
-(UILabel *)countTitleLabel
{
    if (!_countTitleLabel) {
        _countTitleLabel = [[UILabel alloc]init];
        _countTitleLabel.font = KKCNBFont(15);
        _countTitleLabel.textColor = KKHexColor(8F97A6);
        _countTitleLabel.text = @"转出金额";
    }
    return _countTitleLabel;
}
-(UIButton *)countBtn
{
    if (!_countBtn) {
        _countBtn = [[UIButton alloc]init];
        [_countBtn setTitle:@"全部转出" forState:UIControlStateNormal];
        [_countBtn setTitleColor:KKHexColor(4470E4) forState:UIControlStateNormal];
        _countBtn.titleLabel.font = KKCNFont(14);
        [_countBtn addTarget:self action:@selector(clickedCountBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countBtn;
}
-(UITextField *)countFeild
{
    if (!_countFeild) {
        _countFeild = [[UITextField alloc]init];
        _countFeild.font = KKCNBFont(16);
        _countFeild.textColor = KKHexColor(041E45);
        _countFeild.delegate = self;
        _countFeild.keyboardType = UIKeyboardTypeDecimalPad;
        [_countFeild.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            if (self.actionHandle) {
                self.actionHandle(RACTuplePack(@"count",x));
            }
        }];
    }
    return _countFeild;
}
-(UILabel *)quoetsLabel
{
    if (!_quoetsLabel) {
        _quoetsLabel = [[UILabel alloc]init];
        _quoetsLabel.textColor = KKHexColor(9FA4B8);
        _quoetsLabel.font = KKCNFont(10);
    }
    return _quoetsLabel;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickedScan
{
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"scan"));
    }
}
-(void)clickedCountBtn
{
    self.countFeild.text = _model.maxAvailableWithdrawCount;
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"count",_model.maxAvailableWithdrawCount));
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.actionHandle||textField.text.doubleValue>0) {
        self.actionHandle(RACTuplePack(@"request",textField.text));
    }
}
@end
