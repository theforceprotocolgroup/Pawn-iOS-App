//
//  KKEmptyDataSet.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/10.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKEmptyDataSet : NSObject<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
/*! */
@property (nonatomic, strong) NSString *title;
/*! */
@property (nonatomic, strong) NSString *imageName;
/*! */
@property (nonatomic, assign) BOOL isLoading;
/*! */
@property (nonatomic, copy) void(^actionBlock)(id x);
/*! */
@property (nonatomic, copy) void(^tapBlock)(id x);
/*! */
@property (nonatomic, weak) UIScrollView *tableView;
/*! */
@property (nonatomic, assign) NSInteger code;
/*! */
@property (nonatomic, assign) BOOL hasData;
/*! */
@property (nonatomic, assign) BOOL hasBtn;
/*! */
@property (nonatomic, assign) BOOL allowScroll;
/*! */
@property (nonatomic, assign) CGFloat padding;
/*!  */
+ (KKEmptyDataSet *(^)(UIScrollView *tab))set;
@end

NS_ASSUME_NONNULL_END
