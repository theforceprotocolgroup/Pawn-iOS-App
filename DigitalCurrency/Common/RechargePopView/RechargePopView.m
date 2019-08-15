//
//  RechargePopView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/13.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "RechargePopView.h"
#import "NSString+QRCode.h"
@interface RechargePopView ()<CAAnimationDelegate>
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UILabel * addressLabel;
//
@property (nonatomic, strong) UILabel * subtitleLabel;
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UIImageView * codeImageView;
//
@property (nonatomic, strong) UILabel * tipLabel;
//
@property (nonatomic, strong) UIButton * rightBtn;
//
@property (nonatomic, strong) UIButton * leftBtn;
//
@property (nonatomic, strong) UIView * bottomHline;
//
@property (nonatomic, strong) UIView * bottomVline;
//
@property (nonatomic, strong) UIView * bgView;
//
@property (nonatomic, strong) UIView * superVC;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) RACTuple * model;

@end

@implementation RechargePopView

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
+ (instancetype)showWithSurperView:(UIView *)view withModel:(RACTuple *)model withAction:(KKActionHandle)handle;
{
    RechargePopView * popView = [RechargePopView viewWithModel:model action:handle];
    popView.superVC = view;
    return popView;
}
- (void)show;
{
    [_superVC addSubview:self.bgView];
    
    [_superVC addSubview:self];
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.mas_equalTo(0);
    }];

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.mas_equalTo(48);
        make.right.mas_equalTo(-48);
    }];
    [self setNeedsUpdateConstraints];
    [self showAmimation];
}
- (void)dismiss;
{
    [self dismissAmimation];
}
#pragma mark - View
///=============================================================================
/// @name View
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame model:(RACTuple *)model action:(KKActionHandle)action {
    if (self = [super initWithFrame:frame]) {
        self.actionHandle = action;
        self.model = model;
        [self addViews];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.text = [NSString stringWithFormat:@"%@钱包账户",_model.first];
        self.addressLabel.text = _model.second;
        self.subtitleLabel.text = [NSString stringWithFormat:@"请转入%@",_model.first];
        self.codeImageView.image = [_model.second kk_QRcodeWithHeight:126];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.hline];
    [self addSubview:self.codeImageView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.rightBtn];
    [self addSubview:self.leftBtn];
    [self addSubview:self.bottomHline];
    [self addSubview:self.bottomVline];
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
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(13);
    }];
    [_addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(0.5);
    }];
    [_subtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.hline.mas_bottom).offset(16);
    }];
    [_codeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(8);
        make.height.width.mas_equalTo(126);
    }];
    [_tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.codeImageView.mas_bottom).offset(29);
    }];
    [_bottomHline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(0.5);
    }];
    [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.bottomHline.mas_bottom);
        make.left.equalTo(self);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo((SCREEN_WIDTH - 48 *2)/2);
        make.bottom.equalTo(self);
    }];
    [_bottomVline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.leftBtn);
        make.left.equalTo(self.leftBtn.mas_right);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(0.5);
    }];
    [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.bottomHline.mas_bottom);
        make.right.equalTo(self);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo((SCREEN_WIDTH - 48 *2)/2-1);
        make.bottom.equalTo(self);
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
        _titleLabel.textColor = KKHexColor(0C1E48);
        _titleLabel.font = KKCNBFont(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = KKHexColor(9097A6);
        _addressLabel.font = KKCNFont(11);
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.numberOfLines = 0;
        _addressLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 2*48 - 2*15;
    }
    return _addressLabel;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _hline;
}
-(UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc]init];
        _subtitleLabel.textColor = KKHexColor(465062);
        _subtitleLabel.font = KKCNFont(14);
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subtitleLabel;
}
-(UIImageView *)codeImageView
{
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc]init];
    }
    return _codeImageView;
}
-(UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.textColor = KKHexColor(C7C7CD);
        _tipLabel.font = KKCNFont(12);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
-(UIView *)bottomHline
{
    if (!_bottomHline) {
        _bottomHline = [[UIView alloc]init];
        _bottomHline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _bottomHline;
}
-(UIView *)bottomVline
{
    if (!_bottomVline) {
        _bottomVline = [[UIView alloc]init];
        _bottomVline.backgroundColor = KKHexColor(e0e0e0);
    }
    return _bottomVline;
}
-(UIButton *)leftBtn
{
    if (!_leftBtn) {

        _leftBtn = [[UIButton alloc]init];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:KKHexColor(465062) forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = KKCNFont(15);
        [_leftBtn addTarget:self action:@selector(clickedLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
-(UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        [_rightBtn setTitle:@"复制地址" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:KKHexColor(5170EB) forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = KKCNFont(15);
        [_rightBtn addTarget:self action:@selector(clickedRight) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [KKHexColor(000517) colorWithAlphaComponent:0.7];
    }
    return _bgView;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clickedLeft
{
    [self dismissAmimation];

}
-(void)clickedRight
{
    [self dismissAmimation];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.second;
    if (self.actionHandle) {
        self.actionHandle(RACTuplePack(@"0"));
    }
}

-(void)showAmimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
    animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.5;
    animation.delegate = self;
    [animation setValue:@"show" forKey:@"Scale"];
    [self.layer addAnimation:animation forKey:@"bouce"];
    
    
}
- (void)dismissAmimation {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1), @(1.2), @(0.01)];
    animation.keyTimes = @[@(0), @(0.4), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.35;
    animation.delegate = self;
    [animation setValue:@"miss" forKey:@"Scale"];
    [self.layer addAnimation:animation forKey:@"bounce"];
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
}
#pragma mark - animation
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([[anim valueForKey:@"Scale"]isEqualToString:@"miss"]) {
        if (flag) {
            [_bgView removeFromSuperview];
            [self removeFromSuperview];
        }
    }
    
}
@end
