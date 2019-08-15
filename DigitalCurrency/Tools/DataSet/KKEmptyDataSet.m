//
//  KKEmptyDataSet.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/10.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "KKEmptyDataSet.h"

@implementation KKEmptyDataSet

+ (KKEmptyDataSet *(^)(UIScrollView *tab))set {
    return ^id(UIScrollView *tab) {
        KKEmptyDataSet *dataSet = [[KKEmptyDataSet alloc] init];
        dataSet.tableView = tab;
        dataSet.imageName = @"no_data";
        return dataSet;
    };
}

- (void)setIsLoading:(BOOL)isLoading {
    //    if (self.isLoading == isLoading) return;
    _isLoading = isLoading;
    [self.tableView reloadEmptyDataSet];
}

- (void)setTableView:(UIScrollView *)tableView {
    _tableView = tableView;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
}

- (instancetype)init {
    if (self = [super init]) {
        _isLoading = YES;
    }
    return self;
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        return nil;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSString *text = _title.length?_title:@"当前网络较差, 加载失败";
    [attributes setObject:KKCNFont(15) forKey:NSFontAttributeName];
    [attributes setObject:KKHexColor(4184FF) forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        return nil;
    }
    return [UIImage imageNamed:self.imageName];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.isLoading || !self.hasBtn) return nil;
    return [[NSAttributedString alloc] initWithString:@"重新加载" attributes:@{NSFontAttributeName:KKCNFont(15), NSForegroundColorAttributeName:KKHexColor(4184FF)}];
}


- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return KKHexColor(ffffff);
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.padding ? self.padding : -20.0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 34.0;
}


#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !self.hasData;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return self.allowScroll;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.isLoading;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (self.tapBlock) {
        self.tapBlock(RACTuplePack(@"tap"));
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    if (self.actionBlock) {
        self.actionBlock(RACTuplePack(@"login"));
    }
}
@end
