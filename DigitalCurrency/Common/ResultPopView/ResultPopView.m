//
//  ResultPopView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/15.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "ResultPopView.h"

@interface ResultPopView ()<CAAnimationDelegate>
//
@property (nonatomic, strong) UIImageView * imageView;
//
@property (nonatomic, strong) UILabel * statusLabel;
//
@property (nonatomic, strong) UILabel * contentLabel;
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
@property (nonatomic, strong) id model;

@end

@implementation ResultPopView

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
+ (instancetype)showWithSurperView:(UIView *)view withAction:(KKActionHandle)handle;
{
    ResultPopView * popView = [ResultPopView viewWithModel:nil action:handle];
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

- (instancetype)initWithFrame:(CGRect)frame model:(id)model action:(KKActionHandle)action {
    if (self = [super initWithFrame:frame]) {
        self.actionHandle = action;
        self.model = model;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.imageView];
    [self addSubview:self.statusLabel];
    [self addSubview:self.contentLabel];
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
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.width.mas_equalTo([[self imageSize].firstObject floatValue]);
        make.height.mas_equalTo([[self imageSize].lastObject floatValue]);
        make.top.equalTo(self).offset([[self imageTop] floatValue]);
    }];
    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
    }];
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(20);
        make.left.equalTo(self).offset(52);
        make.right.equalTo(self).offset(-52);
    }];
    [_bottomHline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(80);
        make.height.mas_equalTo(0.5);
    }];

    if (self.btnArr.count>1) {
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
    }

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
-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}
-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = KKHexColor(4184FF);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = KKCNFont(15);
    }
    return _statusLabel;
}
-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = KKHexColor(0C1E48);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = KKCNFont(13);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
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


-(NSArray *)imageSize
{
    NSArray * arr = @[@[@98, @78],@[@97, @106],@[@85, @89]];
    return arr[self.type];
}
-(NSNumber *)imageTop;
{
    NSArray * arr = @[@30,@54,@41];
    return arr[self.type];
}
-(NSString *)iamgeIcon
{
    NSArray * arr = @[@"noenough_failed",@"other_failed",@"withdraw_failed"];
    return arr[self.type];
}

- (void)setType:(ResultType)type
{
    _type = type;
    self.imageView.image = KKImage([self iamgeIcon]);
    [self setNeedsUpdateConstraints];
}
-(void)setBtnArr:(NSArray *)btnArr
{
    _btnArr = btnArr;
    if (_btnArr.count <= 1) {
        [_leftBtn removeFromSuperview];
        [_bottomVline removeFromSuperview];
        @weakify(self);
        [_rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.bottomHline.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(50);
            make.bottom.equalTo(self);
        }];
        [_rightBtn setTitle:btnArr.count == 1 ? btnArr.firstObject : @"确定" forState:UIControlStateNormal];
    }else
    {
        [_rightBtn setTitle:btnArr.lastObject forState:UIControlStateNormal];
        [_leftBtn setTitle:btnArr.firstObject forState:UIControlStateNormal];
    }
}
-(void)setStatus:(NSString *)status
{
    _status = status;
    self.statusLabel.text = status;
}
-(void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.text = content ;
}
@end
