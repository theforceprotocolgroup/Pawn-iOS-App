//
//  UtMultbleSegement.h
//  UThing
//
//  Created by Michael on 15/7/11.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UtMultbleSegement;

typedef enum
{
    UtMultbleSegementStyleDefault,
    UtMultbleSegementStyleCustom,//自定义，通过回调
    UtMultbleSegementStyleScroll,//自定义，可滑动，View可回调
}UtMultbleSegementStyle;


@protocol UtMultbleSegementDelegate <NSObject>

@optional
/**
 *	@brief	选择回调
 *
 *	@param 	segement 	自己
 *	@param 	index 	选择的index
 */
-(void)ut_multbleSegement:(UtMultbleSegement*)segement clickedBtnWithIndex:(NSInteger)index;

@end

@interface UtMultbleSegement : UIView

/**
 *	@brief	选择器
 *
 *	@param 	style 	选择器类型
 *
 *	@return	实例
 */
+(UtMultbleSegement*)createSegementWithStyle:(UtMultbleSegementStyle)style;
///内容数组（字符串数组）
@property (nonatomic , readonly ,strong)NSArray * titlesArr;
///选择状态下的icon 的数组 图片名数组
@property (nonatomic , strong)NSArray * selectedIconsArr;
///未选择状态下的icon 的数组 图片名数组
@property (nonatomic , strong)NSArray * unSelectedIconsArr;
///空白宽度
@property (nonatomic , assign)CGFloat blankWidth;
///代理
@property (nonatomic , assign)id<UtMultbleSegementDelegate>delegate;
///选中
@property (nonatomic , readonly)NSInteger selectedIndex;

-(void)setTitlesArr:(NSArray*)titleArr withDefaultIndex:(NSInteger)index;

/**
 *	@brief	选择index
 *
 *	@param 	index 	index
 */
-(void)changeClickedBtnWithIndex:(NSInteger)index;
- (void)requestedSetupArray:(NSArray *)array;
@end
