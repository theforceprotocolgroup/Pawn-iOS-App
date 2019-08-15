//
//  LaunchBannerView.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "LaunchBannerView.h"

@interface LaunchBannerView()
/*! */
@property (nonatomic, strong) UIImageView *imageView;
/*! */
@property (nonatomic, strong) UIButton *btn;
@end

@implementation LaunchBannerView

+ (instancetype)show {
    LaunchBannerView *task = [[LaunchBannerView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:task];
    return task;
}

#pragma mark - Init
///=============================================================================
/// @name Init
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect f = {0, 0, SCREEN_WIDTH, SCREEN_HEIGHT};
    if (self = [super initWithFrame:f]) {
        [self addView];
    }
    return self;
}

- (void)addView {
    [self addSubview:self.imageView];
}

#pragma mark - Function
///=============================================================================
/// @name Function
///=============================================================================

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)showOpenScreen:(UIImage *)image {
    self.imageView.image = image;
    [self addBtn];
}

- (void)addBtn {
    [self.imageView kkAddTapAction:^(id x){
        [self.tcs trySetResult:@(YES)];
        [self dismiss];
    }];
    [self addSubview:self.btn];
    [self countDown:3];
}

- (void)countDown:(NSInteger)count {
    if (count == 0) {
        [self.tcs trySetError:[NSError errorWithDomain:@"" code:9999 userInfo:@{}]];
        [self removeFromSuperview];
        return;
    }
    //self.btn.kkTitle = Format(@"%lis后跳过", count);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self countDown:(count-1)];
    });
}

#pragma mark - Get
///=============================================================================
/// @name Get
///=============================================================================

- (BFTaskCompletionSource *)tcs {
    if (!_tcs) {
        _tcs = [BFTaskCompletionSource taskCompletionSource];
    }
    return _tcs;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = [self getLauchImage];
    }
    return _imageView;
}

- (UIImage *)getLauchImage {
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    NSString *launchImage = nil;
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(size, imageSize) &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(kScreenWidth-79, 22, 50, 22);
        [_btn kkExtendHitTestSizeByWidth:20 height:20];
        _btn.titleLabel.font = KKCNFont(13);
        _btn.layer.cornerRadius = 3.0f;
        _btn.layer.borderColor = KKHexColor(ffffff).CGColor;
        _btn.layer.borderWidth = .7;
        _btn.kkTitle = @"跳过";
        [_btn setTitleColor:KKHexColor(ffffff) forState:UIControlStateNormal];
        @weakify(self);
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.tcs trySetError:[NSError errorWithDomain:@"" code:9999 userInfo:@{}]];
            [self dismiss];
        }];
    }
    return _btn;
}
@end
