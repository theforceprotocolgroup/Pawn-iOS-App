//
//  BorrowSliderView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/22.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "BorrowSliderView.h"

@interface BorrowSliderView ()<UITextFieldDelegate>
//
@property (nonatomic, strong) UISlider * slider;
////
//@property (nonatomic, strong) UILabel * minLabel;
////
//@property (nonatomic, strong) UILabel * maxLabel;
//
@property (nonatomic, assign) float max;
//
@property (nonatomic, assign) float min;
//
@property (nonatomic, strong) NSArray * rateArr;
//
@property (nonatomic, strong) UITapGestureRecognizer * tap;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation BorrowSliderView

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
        RACTupleUnpack( NSArray * rateArr,NSString * defualtnum) = tuple;
        self.rateArr = rateArr;
        [self.slider setMaximumValue:[rateArr.lastObject[@"rate"] doubleValue]];
        [self.slider setMinimumValue:[rateArr.firstObject[@"rate"] doubleValue]];
        NSString * str = [defualtnum substringWithRange:NSMakeRange(0, defualtnum.length-1)];
        float value = str.floatValue;
        self.slider.value = value;
        @weakify(self);
        [self.rateArr enumerateObjectsUsingBlock:^(NSDictionary *   _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView * view = [[UIView alloc]init];
            view.backgroundColor = [UIColor clearColor];
            UILabel * label = [[UILabel alloc]init];
            label.font = KKThirdFont(13);
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
                make.bottom.equalTo(self.slider).offset(18);
            }];
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(view);
            }];
            [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(label);
                make.width.mas_equalTo(0.5);
                make.top.equalTo(view);
                make.height.mas_equalTo(8);
//                make.bottom.equalTo(label.mas_top).offset(-4);
            }];
        }];
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
        self.userInteractionEnabled = YES;
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.slider];
//    [self addSubview:self.minLabel];
//    [self addSubview:self.maxLabel];
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
    [_slider mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(14);
        make.left.equalTo(self).offset(30).priorityHigh();
        make.right.equalTo(self).offset(-30).priorityHigh();
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

-(UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc]init];
        [_slider setContinuous:YES];
        [_slider setThumbImage:KKImage(@"borrow_home_slider") forState:UIControlStateNormal] ;
        _slider.minimumTrackTintColor = KKHexColor(5170EB);
        _slider.maximumTrackTintColor = KKHexColor(EBEEF2);
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(sliderTourchDown) forControlEvents:UIControlEventTouchDown];
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
    if (self.actionHandle) {
        NSString * str = [NSString stringWithFormat:@"%.2f",self.slider.value];
        self.actionHandle(RACTuplePack(@"changed",str));
    }
    if (self.actionHandle) {
        NSString * str = [NSString stringWithFormat:@"%.2f",self.slider.value];
        self.actionHandle(RACTuplePack(@"finished",str));
    }
}
- (void)sliderValueChanged:(UISlider *)slider
{
    if (self.actionHandle) {
        NSString * str = [NSString stringWithFormat:@"%.2f",slider.value];
        self.actionHandle(RACTuplePack(@"changed",str));
    }
}
- (void)sliderTourchDown
{
    _tap.enabled = NO;
}
-(void)sliderTouchUpInSide:(UISlider *)slider
{
    _tap.enabled = YES;
    if (self.actionHandle) {
        NSString * str = [NSString stringWithFormat:@"%.2f",slider.value];
        self.actionHandle(RACTuplePack(@"finished",str));
    }
}
-(void)valueChanged:(NSString *)value;
{
    self.slider.value = [value doubleValue];
}
@end
