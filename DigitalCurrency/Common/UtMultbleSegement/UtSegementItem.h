//
//  UtSegementItem.h
//  UThing
//
//  Created by Michael on 15/7/13.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    UtSegementItemStyleDefult,
    UtSegementItemStyleCustom,
}UtSegementItemStyle;

@interface UtSegementItem : UIControl
@property (nonatomic , strong)UIColor * selectedColer;
@property (nonatomic , strong)UIColor * unSelectedColer;
@property (nonatomic , strong)UIImage * selectedImage;
@property (nonatomic , strong)UIImage * unSelectedIamge;
@property (nonatomic , strong)NSString * titleStr;
@property (nonatomic , assign)CGSize  iconSize;
@property (nonatomic , assign)BOOL isSelect;
@property (nonatomic , assign)NSInteger index;
-(instancetype)initWithFrame:(CGRect)frame withStyle:(UtSegementItemStyle)style;
@end
