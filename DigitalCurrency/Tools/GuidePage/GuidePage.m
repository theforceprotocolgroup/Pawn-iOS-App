//
//  GuidePage.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/29.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "GuidePage.h"
#import <iCarousel/iCarousel.h>
#import <SMPageControl/SMPageControl.h>

@interface GuidePage ()<iCarouselDelegate,iCarouselDataSource>

#pragma mark - inherent
//
@property (nonatomic, strong) iCarousel * scroll;
//
@property (nonatomic, strong) SMPageControl * pageControl;
//
@property (nonatomic, strong) UIButton * closeBtn;
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;
//
@property (nonatomic, copy) dispatch_block_t  block;
@end

@implementation GuidePage

#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================
+ (instancetype)initializeGuidePageView:(dispatch_block_t)handle
{
    GuidePage *pageView = [[GuidePage alloc] init];
    pageView.backgroundColor = [UIColor clearColor];
    [pageView addViews];
    pageView.block = handle;
    return pageView;
}
+ (BOOL)isFirstLaunch;
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * num = [defaults objectForKey:@"isLaunched"];
    return num ? NO : YES;
}
+ (void)setLaunched;
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"isLaunched"];
}
#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================



#pragma mark - View
///=============================================================================
/// @name View
///=============================================================================


- (void)addViews {
    [self addSubview:self.scroll];
    [self addSubview:self.pageControl];
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
    [_scroll mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.right.left.bottom.equalTo(self);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(iCarousel *)scroll
{
    if (!_scroll) {
        _scroll = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scroll.backgroundColor = [UIColor whiteColor];
        _scroll.type = iCarouselTypeLinear;
        _scroll.delegate = self;
        _scroll.dataSource = self;
        _scroll.pagingEnabled = YES;
        _scroll.bounceDistance = .2;
        _scroll.clipsToBounds = YES;
    }
    return _scroll;
}
-(SMPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[SMPageControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-15, 12)];
        _pageControl.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT -50);
        _pageControl.numberOfPages = 3;
        _pageControl.pageIndicatorImage = [UIImage imageNamed:@"pageDot"];
        _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"currentPageDot"];
        _pageControl.indicatorMargin = 10;
    }
    return _pageControl;
}

-(NSArray *)imageArr
{
    return @[@"page1",@"page2",@"page3"];
}
-(NSArray *)titleArr
{
    return @[@"智能合约  安全透明",@"订单共享  方便快捷",@"高效撮合  利率最优"];
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================

-(void)clickedCloseBtn
{
    [self removeFromSuperview];
    if (self.block) {
        self.block();
    }
}


#pragma mark - Carousel delegate
///=============================================================================
/// @name Carousel delegate
///=============================================================================

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index
         reusingView:(UIView *)view {
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:KKImage([self imageArr][index])];
        [view addSubview:imageView];
        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view).offset(60);
        }];
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = KKHexColor(465062);
        titleLabel.font = KKCNFont(20);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = [self titleArr][index];
        [view addSubview:titleLabel];
        [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(imageView.mas_bottom).offset(60);
        }];
        if (index == 2) {
            _closeBtn= [[UIButton alloc]init];
            [_closeBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_closeBtn setBackgroundColor:KKHexColor(5170EB)];
            _closeBtn.layer.masksToBounds = YES;
            _closeBtn.layer.cornerRadius = 21;
            _closeBtn.titleLabel.font = KKCNFont(15);
            [_closeBtn addTarget:self action:@selector(clickedCloseBtn) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:_closeBtn];
            [_closeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view);
                make.top.equalTo(titleLabel.mas_bottom).offset(40);
                make.height.mas_equalTo(42);
                make.width.mas_equalTo(178);
            }];
        }
    }
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionWrap) return YES;
    return value;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    _pageControl.currentPage = carousel.currentItemIndex;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {

}
@end
