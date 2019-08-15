//
//  UtMultbleSegement.m
//  UThing
//
//  Created by Michael on 15/7/11.
//  Copyright (c) 2015年 UThing. All rights reserved.
//

#import "UtMultbleSegement.h"
#import "UtSegementItem.h"

#define kBtnItemTag 1000
#define Min_Width_4_Button 80.0

@interface UtMultbleSegement ()
@property (nonatomic , strong)UIScrollView * scrollView;
@property (nonatomic , strong)NSMutableArray * itemsArr;
@property (nonatomic , readwrite)NSInteger selectedIndex;
@property (nonatomic , strong)UIView * moveIconView;
@property (nonatomic , assign)UtMultbleSegementStyle style;
@property (nonatomic , readwrite ,strong)NSArray * titlesArr;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation UtMultbleSegement

+(UtMultbleSegement *)createSegementWithStyle:(UtMultbleSegementStyle)style
{
    UtMultbleSegement * segement = [[UtMultbleSegement alloc]initWithStyle:style];
    return segement;
}
-(instancetype)initWithStyle:(UtMultbleSegementStyle)style
{
    self = [super init];
    if (self) {
        _itemsArr = [[NSMutableArray alloc]init];
        _style = style;

        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
        [self addSubview:self.bottomLine];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height-1, SCREEN_WIDTH, 0.5);

    if (self.itemsArr.count == 0) {
        NSArray *viewsToRemove = [self.scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        [self.itemsArr removeAllObjects];
        for (int i = 0; i<self.titlesArr.count; i++) {
            UIView * aview = [self itemViewWith:i];
            [self.scrollView addSubview:aview];
            [_itemsArr addObject:aview];
            
        }
        
        UIControl * selectControl = [self.itemsArr objectAtIndex:_selectedIndex];
        CGRect rect4boottomLine = self.moveIconView.frame;
        rect4boottomLine.origin.x = selectControl.frame.origin.x + (selectControl.frame.size.width - 40)/2.0f;
        rect4boottomLine.origin.y = self.frame.size.height-4;
//        rect4boottomLine.size = CGSizeMake([self btnWidth] - 50, 4);
        rect4boottomLine.size = CGSizeMake(40, 3);

        CGPoint pt = CGPointZero;
        BOOL canScrolle = NO;
        if (_selectedIndex >= 2 && [self.itemsArr count] > 4 && [self.itemsArr count] > (_selectedIndex + 2)) {
            pt.x = selectControl.frame.origin.x - Min_Width_4_Button*1.5f;
            canScrolle = YES;
        }else if ([self.itemsArr count] > 4 && (_selectedIndex + 2) >= [self.itemsArr count]){
            pt.x = (self.itemsArr.count - 4) * Min_Width_4_Button;
            canScrolle = YES;
        }else if (self.itemsArr.count > 4 && _selectedIndex < 2){
            pt.x = 0;
            canScrolle = YES;
        }
        
        if (canScrolle) {
            _scrollView.contentOffset = pt;
            self.moveIconView.frame = rect4boottomLine;

        }else{
//            _scrollView.contentOffset = CGPointMake(0, -self.frame.size.height);
            self.moveIconView.frame = rect4boottomLine;
        }

        
        self.scrollView.contentSize = CGSizeMake([self.titlesArr count]*[self btnWidth]+(self.titlesArr.count -1) *self.blankWidth, self.frame.size.height);
//        self.moveIconView.frame = CGRectMake(10.0f, self.frame.size.height-2, [self btnWidth]-20.0f, 2.0f);
        self.scrollView.frame = self.bounds;
        [self.scrollView addSubview:self.moveIconView];

    }else
    {
        for (UtSegementItem * item in self.itemsArr) {
            if (item.index == _selectedIndex) {
                item.isSelect = YES;
            }else
            {
                item.isSelect = NO;
            }
        }
    }
}
-(void)setTitlesArr:(NSArray *)titlesArr
{
    _titlesArr = titlesArr;
    [self setNeedsLayout];
}
-(UIView *)moveIconView
{
    if (!_moveIconView) {
        _moveIconView = [[UIView alloc] init];
        _moveIconView.backgroundColor = KKHexColor(4470E4);
    }
    return _moveIconView;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = KKHexColor(e0e0e0);
    }
    return _bottomLine;
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        adjustsScrollViewInsets(_scrollView);
    }
    return _scrollView;
}
-(UtSegementItem *)itemViewWith:(NSInteger)index
{
    UtSegementItem * childControl = [[UtSegementItem alloc]initWithFrame:CGRectMake(index * [self btnWidth]+ self.blankWidth * index, .0f, [self btnWidth], self.frame.size.height-2) withStyle:_style==UtMultbleSegementStyleDefault?UtSegementItemStyleDefult:UtSegementItemStyleCustom];
    [childControl addTarget:self action:@selector(changeSement:) forControlEvents:UIControlEventTouchUpInside];
    childControl.index = index;
    childControl.selectedColer = KKHexColor(0C1E48);
    childControl.unSelectedColer = KKHexColor(95A0AB);
    childControl.selectedImage = [UIImage imageNamed:[_selectedIconsArr objectAtIndex:index]];
    childControl.unSelectedIamge = [UIImage imageNamed:[_unSelectedIconsArr objectAtIndex:index]];
    childControl.iconSize = CGSizeMake(20, 20);
    childControl.titleStr = [self.titlesArr objectAtIndex:index];
    if (self.selectedIndex == index)
    {
        childControl.isSelect = YES;
    }else
    {
        childControl.isSelect = NO;
    }
    return childControl;
}
-(CGFloat)btnWidth
{
    CGFloat perWidth = self.frame.size.width/self.titlesArr.count - self.blankWidth * (self.titlesArr.count-1);
    return perWidth;
}
-(void)changeSement:(id)sender
{
    self.selectedIndex = [(UtSegementItem*)sender index] ;
}

-(void)changeClickedBtnWithIndex:(NSInteger)index
{
    _selectedIndex = index;
    UIControl * selectControl = [self.itemsArr objectAtIndex:_selectedIndex];
    CGRect rect4boottomLine = self.moveIconView.frame;
    rect4boottomLine.origin.x = selectControl.frame.origin.x + (selectControl.frame.size.width - 40)/2.0f;
    
    CGPoint pt = CGPointZero;
    BOOL canScrolle = NO;
    if (_selectedIndex >= 2 && [self.itemsArr count] > 4 && [self.itemsArr count] > (_selectedIndex + 2)) {
        pt.x = selectControl.frame.origin.x - Min_Width_4_Button*1.5f;
        canScrolle = YES;
    }else if ([self.itemsArr count] > 4 && (_selectedIndex + 2) >= [self.itemsArr count]){
        pt.x = (self.itemsArr.count - 4) * Min_Width_4_Button;
        canScrolle = YES;
    }else if (self.itemsArr.count > 4 && _selectedIndex < 2){
        pt.x = 0;
        canScrolle = YES;
    }
    
    if (canScrolle) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = pt;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.moveIconView.frame = rect4boottomLine;
            }];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.moveIconView.frame = rect4boottomLine;
        }];
    }
    [self setNeedsLayout];

}
-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    
    UIControl * selectControl = [self.itemsArr objectAtIndex:_selectedIndex];
    CGRect rect4boottomLine = self.moveIconView.frame;
    rect4boottomLine.origin.x = selectControl.frame.origin.x + (selectControl.frame.size.width - 40)/2.0f;
    
    CGPoint pt = CGPointZero;
    BOOL canScrolle = NO;
    if (_selectedIndex >= 2 && [self.itemsArr count] > 4 && [self.itemsArr count] > (_selectedIndex + 2)) {
        pt.x = selectControl.frame.origin.x - Min_Width_4_Button*1.5f;
        canScrolle = YES;
    }else if ([self.itemsArr count] > 4 && (_selectedIndex + 2) >= [self.itemsArr count]){
        pt.x = (self.itemsArr.count - 4) * Min_Width_4_Button;
        canScrolle = YES;
    }else if (self.itemsArr.count > 4 && _selectedIndex < 2){
        pt.x = 0;
        canScrolle = YES;
    }
    
    if (canScrolle) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = pt;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.moveIconView.frame = rect4boottomLine;
            }];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.moveIconView.frame = rect4boottomLine;
        }];
    }
    [self setNeedsLayout];
    if (_delegate && [_delegate respondsToSelector:@selector(ut_multbleSegement:clickedBtnWithIndex:)]) {
        [_delegate ut_multbleSegement:self clickedBtnWithIndex:_selectedIndex];
    }
    
}
-(void)setBlankWidth:(CGFloat)blankWidth
{
    if (_style != UtMultbleSegementStyleDefault) {
        _blankWidth = blankWidth;
    }
    [self setNeedsLayout];
}

-(void)setTitlesArr:(NSArray*)titleArr withDefaultIndex:(NSInteger)index;
{
    _titlesArr = titleArr;
    _selectedIndex = index;
    [self setNeedsLayout];
}
- (void)requestedSetupArray:(NSArray *)array {
    __block NSMutableArray *temp = [NSMutableArray array];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UtSegementItem class]]) {
            [temp addObject:obj];
            
        }
    }];
    [temp enumerateObjectsUsingBlock:^(UtSegementItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleStr = array[idx];
    }];
    [self setNeedsLayout];
}
@end
