//
//  PopSliderView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/20.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "PopSliderView.h"

@interface PopSliderView ()<UITextFieldDelegate>
//
@property (nonatomic, strong) UIView * bgView;
//
@property (nonatomic, strong) UIView * superVeiw;
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIButton * cancelBtn;
//
@property (nonatomic, strong) UIButton * sureBtn;
//
@property (nonatomic, strong) UITextField * textField;
//
@property (nonatomic, strong) UIView * hlineView;
//
@property (nonatomic, strong) UISlider * slider;

//
@property (nonatomic, strong) UITapGestureRecognizer * tap;

@property (nonatomic, assign) double max;
//
@property (nonatomic, assign) double min;
//
@property (nonatomic, strong) NSArray * rateArr;
//
@property (nonatomic, assign) double lastValue;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation PopSliderView

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
        
    };
}

#pragma mark - View
///=============================================================================
/// @name View
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame model:(id)model action:(KKActionHandle)action {
    CGRect tmpFrame = CGRectMake(0, 0, SCREEN_WIDTH, 214);
    if (self = [super initWithFrame:tmpFrame]) {
        self.actionHandle = action;
        self.model = model;
        [self addViews];
        self.backgroundColor = KKHexColor(ffffff);
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.titleLabel];
    [self.titleView addSubview:self.cancelBtn];
    [self.titleView addSubview:self.sureBtn];
    
    [self addSubview:self.textField];
    [self addSubview:self.hlineView];
    [self addSubview:self.slider];
    //    [self addSubview:self.minLabel];
    //    [self addSubview:self.maxLabel];
    
}
-(void)setRateArr:(NSArray *)rateArr
{
    _rateArr = rateArr;
    @weakify(self);
    [_rateArr enumerateObjectsUsingBlock:^(NSDictionary *   _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        UILabel * label = [[UILabel alloc]init];
        label.font = KKThirdFont(15);
        label.textColor = KKHexColor(0C1E48);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%@%%",obj[@"rate"]];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = KKHexColor(CDD0D4);
        [view addSubview:label];
        [view addSubview:lineView];
        [self addSubview:view];
        [self bringSubviewToFront:self.slider];
        float value = [(NSString*)obj[@"rate"] doubleValue] - [(NSString*)self.rateArr.firstObject[@"rate"] doubleValue];
        float width = SCREEN_WIDTH - 57*2;
        float totalValue = [(NSString*)self.rateArr.lastObject[@"rate"] doubleValue] - [(NSString*)self.rateArr.firstObject[@"rate"] doubleValue];
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.slider).offset( width/totalValue*value - width/2.0f);
            make.top.equalTo(self.slider.mas_bottom).offset(-10);
            make.bottom.equalTo(self.slider).offset(20);
        }];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(view);
        }];
        [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(label);
            make.width.mas_equalTo(0.5);
            make.top.equalTo(view);
            make.bottom.equalTo(label.mas_top).offset(-4);
        }];
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
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.centerY.equalTo(self.titleView);
    }];
    [_cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.bottom.equalTo(self.titleView);
        make.width.mas_equalTo(60);
    }];
    [_sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.right.bottom.equalTo(self.titleView);
        make.width.mas_equalTo(60);
    }];
    [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleView.mas_bottom).offset(36);
        make.centerX.equalTo(self);
    }];
    [_hlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(48);
        make.right.equalTo(self).offset(-48);
        make.top.equalTo(self.textField.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    [_slider mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.hlineView.mas_bottom).offset(25);
        make.left.equalTo(self).offset(44);
        make.right.equalTo(self).offset(-44);
    }];
    //    [_minLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    //        @strongify(self);
    //        make.left.equalTo(self.slider.mas_left);
    //        make.top.equalTo(self.slider.mas_bottom).offset(5);
    //    }];
    //    [_maxLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    //        @strongify(self);
    //        make.right.equalTo(self.slider.mas_right);
    //        make.top.equalTo(self.slider.mas_bottom).offset(5);
    //    }];
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
        _titleView.backgroundColor = KKHexColor(F7F7F7);
    }
    return _titleView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = KKHexColor(0C1E48);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = KKCNBFont(17);
    }
    return _titleLabel;
}
-(UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:KKHexColor(465062) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = KKCNFont(14);
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:KKHexColor(5170EB) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = KKCNFont(14);
        [_sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = KKThirdFont(19);
        _textField.textColor = KKHexColor(0C1E48);
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.rightViewMode = UITextFieldViewModeAlways;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 19, 19)];
        label.font = KKCNFont(19);
        label.textColor = KKHexColor(0C1E48);
        label.text = @"%";
        _textField.rightView = label;
        @weakify(self);
        [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.slider.value = [x doubleValue];
        }];
        _textField.delegate = self;
    }
    return _textField;
}
-(UIView *)hlineView
{
    if (!_hlineView) {
        _hlineView = [[UIView alloc]init];
        _hlineView.backgroundColor = KKHexColor(F5F5F5);
    }
    return _hlineView;
}
-(UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc]init];
        [_slider setContinuous:YES];
        [_slider setThumbImage:KKImage(@"borrow_home_slider") forState:UIControlStateNormal] ;
        _slider.minimumTrackTintColor = KKHexColor(5170EB);
        _slider.maximumTrackTintColor = KKHexColor(EBEEF2);
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderTourchDown) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(sliderTourchUp) forControlEvents:UIControlEventTouchUpInside];
        
        self.tap = [[UITapGestureRecognizer alloc]init];
        [self.tap addTarget:self action:@selector(sliderTap:)];
        [_slider addGestureRecognizer:self.tap];
    }
    return _slider;
}
//-(UILabel *)minLabel
//{
//    if (!_minLabel) {
//        _minLabel = [[UILabel alloc]init];
//        _minLabel.font = KKCNFont(15);
//        _minLabel.textColor = KKHexColor(0C1E48);
//        _minLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _minLabel;
//}
//-(UILabel *)maxLabel
//{
//    if (!_maxLabel) {
//        _maxLabel = [[UILabel alloc]init];
//        _maxLabel.font = KKCNFont(15);
//        _maxLabel.textColor = KKHexColor(0C1E48);
//        _maxLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _maxLabel;
//}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColorHex(070A14);
        _bgView.alpha = 0.01f;
        _bgView.frame = _superVeiw.bounds;
        [_bgView kkAddTapAction:^(RACTuple *x){
            [self dismiss];
        }];
    }
    return _bgView;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)sliderTap:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:self.slider];
    CGFloat value = (self.slider.maximumValue - self.slider.minimumValue) * (touchPoint.x / self.slider.frame.size.width ) + self.slider.minimumValue;
    //先保留两位有效数字,四舍五入
    __block double realValue = floorf(value*100 +0.5)/100;
    [self.rateArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //如果和最近的一个数小于0.02 则等于最近的h数
        double rateValue = [(NSString*)obj[@"rate"] doubleValue];
        if (rateValue * 100 +2 >= realValue * 100 && rateValue * 100 -2 <= realValue * 100) {
            realValue = rateValue;
            *stop =YES;
        }
    }];
    [self.slider setValue:realValue animated:YES];
    self.textField.text = [NSString stringWithFormat:@"%.2f",self.slider.value];
}
- (void)sliderTourchDown
{
    _tap.enabled = NO;
}
- (void)sliderTourchUp
{
    _tap.enabled = YES;
}
- (void)sure
{
    _lastValue = round(self.slider.value*100)/100 ;
    if (self.actionHandle) {
        self.actionHandle([NSNumber numberWithDouble:_lastValue]);
    }
    [self dismiss];
}
- (void)cancel
{
    [self dismiss];
}
- (void)sliderValueChanged:(UISlider *)slider
{
    self.textField.text = [NSString stringWithFormat:@"%.2f",slider.value];
}

- (void)keyBoardWillShow:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    [UIView animateWithDuration:animationTime animations:^{
        self.frame = CGRectSetY(self.frame, SCREEN_HEIGHT-self.height-keyBoardHeight);
        self.bgView.alpha = .3f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyBoardWillHide:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    [UIView animateWithDuration:animationTime animations:^{
        self.frame = CGRectSetY(self.frame, SCREEN_HEIGHT);
        self.bgView.alpha = .0f;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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


#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================
+ (instancetype)showWithTitle:(NSString *)title valueArr:(NSArray*)valueArr superView:(UIView * _Nullable )superView action:(KKActionHandle)handle;
{
    PopSliderView * view = [[PopSliderView alloc]initWithFrame:CGRectZero model:nil action:handle];
    view.titleLabel.text = title;
    view.rateArr = valueArr;
    view.slider.minimumValue = [(NSString*)valueArr.firstObject[@"rate"] doubleValue];
    view.slider.maximumValue = [(NSString*)valueArr.lastObject[@"rate"] doubleValue];
    //    view.minLabel.text = [NSString stringWithFormat:@"%@%%",valueArr.firstObject[@"rate"]];
    //    view.maxLabel.text = [NSString stringWithFormat:@"%@%%",valueArr.lastObject[@"rate"]];
    view.superVeiw = superView?:[UIApplication sharedApplication].keyWindow;
    view.center = CGPointMake(view.superVeiw.width/2, view.superVeiw.height);
    return view;
}
- (void)show;
{
    self.slider.value = MAX(self.lastValue, self.slider.minimumValue);
    
    // 添加对键盘的监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [_superVeiw addSubview:self.bgView];
    [_superVeiw addSubview:self];
    
    [self.textField becomeFirstResponder];
    
    
    
}
- (void)dismiss;
{
    [self.textField resignFirstResponder];
}
@end
