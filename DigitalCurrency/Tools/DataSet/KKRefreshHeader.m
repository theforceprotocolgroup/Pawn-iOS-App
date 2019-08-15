//
//  KKRefreshHeader.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/10.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "KKRefreshHeader.h"

@interface KKRefreshHeader()
/*! */
@property (nonatomic, weak) UIImageView *gifView;
/*! */
@property (nonatomic, weak) UIImageView *imageView;
/*! */
@property (nonatomic, weak) UILabel *titleLab;

@property (nonatomic, strong) CAShapeLayer *animationLayer;
@end

@implementation KKRefreshHeader

- (void)prepare {
    [super prepare];
    
    self.mj_h = 80;
    
    UIImageView *gifView = [[UIImageView alloc] init];
    gifView.image = KKImage(@"refresh_arrow");
    gifView.contentMode = UIViewContentModeCenter;
    [self addSubview:gifView];
    
    self.gifView = gifView;
    
    UILabel *title = [UILabel new];
    title.font = KKCNFont(13);
    title.textColor = KKHexColor(d5d5d5);
    title.text = @"下拉即可刷新...";
    [self addSubview:title];
    self.titleLab = title;
}

- (void)placeSubviews {
    [super placeSubviews];
    self.gifView.frame = CGRectMake(self.bounds.size.width/2-70, self.bounds.size.height/2-25, 50, 50);
    [self.gifView.layer addSublayer:self.animationLayer];
    
    self.titleLab.frame = CGRectMake(self.bounds.size.width/2-20, self.bounds.size.height/2-25, 122, 50);
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.titleLab.text = @"下拉即可刷新...";
            break;
        case MJRefreshStatePulling:
            self.titleLab.text = @"释放即可刷新...";
            break;
        case MJRefreshStateRefreshing:
            self.titleLab.text = @"加载中...";
            break;
        case MJRefreshStateWillRefresh:
            self.titleLab.text = @"加载中...";
            break;
        case MJRefreshStateNoMoreData:
            self.titleLab.text = @"加载完毕...";
            break;
        default:
            break;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    _animationLayer.strokeEnd = pullingPercent;
}

- (CAShapeLayer *)animationLayer
{
    if (!_animationLayer) {
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(self.gifView.width/2, self.gifView.height/2) radius:15 startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
        _animationLayer = [CAShapeLayer layer];
        _animationLayer.path = path.CGPath;
        _animationLayer.strokeColor = KKHexColor(d5d5d5).CGColor;
        _animationLayer.fillColor = [UIColor clearColor].CGColor;
        _animationLayer.lineJoin = kCALineJoinRound;
        _animationLayer.lineWidth = 1.5;
        _animationLayer.lineCap = kCALineJoinRound;
        _animationLayer.strokeEnd = .0;
    }
    return _animationLayer;
}
@end
