//
//  MyBorrowMergeView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/17.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MyBorrowMergeView.h"
#import "MyBorrowDetailCell.h"
#import "MyBorrowDetailModel.h"
@interface MyBorrowMergeView ()
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIImageView * arrowIcon;
//
@property (nonatomic, strong) UILabel * statusLabel;
//
@property (nonatomic, strong) UIControl * control;
//
@property (nonatomic, strong) UIView * contentView;
//
@property (nonatomic, strong) NSMutableArray * mrgeArr;
//
@property (nonatomic, strong) NSMutableArray * mrgeItemArr;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

//
@property (nonatomic, assign) BOOL isDeploy;
@end

@implementation MyBorrowMergeView

#pragma mark - ViewDelegate
///=============================================================================
/// @name ViewDelegate
///=============================================================================

+ (instancetype)viewWithModel:(id)model action:(KKActionHandle)action {
    return [[self alloc] initWithFrame:CGRectZero model:model action:action];
}
//更新
- (KKActionHandle)viewAction {
    @weakify(self);
    return ^(RACTuple *tuple) {
        @strongify(self);
        //刷新内容
        if ([tuple.first isKindOfClass:[MyBorrowDetailModel class]]) {
            RACTupleUnpack(MyBorrowDetailModel* model)=tuple;
            
            [self.mrgeArr removeAllObjects];
            [self.mrgeItemArr enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [self.mrgeItemArr removeAllObjects];
            [self.mrgeArr addObjectsFromArray:model.mortgageInfo];
            [self.mrgeArr enumerateObjectsUsingBlock:^(NSDictionary  *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MyBorrowDetailCell * cell = [MyBorrowDetailCell viewWithModel:obj[@"title"] action:nil];
                [self.contentView addSubview:cell];
                [self.mrgeItemArr addObject:cell];
                [cell viewAction](obj[@"content"]);
            }];
            self.contentView.hidden = YES;
            if (model.reachPreCautiousLine) {
                self.statusLabel.text = @"质押币价值已达到预警线";
            }else
            {
                self.statusLabel.text = @"";
            }

            [self setNeedsUpdateConstraints];
        }
    };
}

#pragma mark - View
///=============================================================================
/// @name View
///=============================================================================

- (instancetype)initWithFrame:(CGRect)frame model:(id)model action:(KKActionHandle)action {
    if (self = [super initWithFrame:frame]) {
        self.actionHandle = action;
        self.model = model;
        self.backgroundColor = [UIColor whiteColor];
        self.mrgeItemArr = [[NSMutableArray alloc]init];
        self.mrgeArr = [[NSMutableArray alloc]init];
        [self addViews];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.contentView];
    [self addSubview:self.control];
    [self.control addSubview:self.titleLabel];
    [self.control addSubview:self.statusLabel];
    [self.control addSubview:self.arrowIcon];
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
    [_control mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.control).offset(15);
        make.top.equalTo(self.control).offset(18);
    }];
    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.arrowIcon.mas_left).offset(-15);
    }];
    [_arrowIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.control.mas_right).offset(-9);
        make.height.width.mas_equalTo(25);
    }];
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.control);
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
        _titleLabel.font = KKCNFont(15);
        _titleLabel.text = @"质押信息";
    }
    return _titleLabel;
}
-(UIImageView *)arrowIcon
{
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc]initWithImage:KKImage(@"up_arrow")];
    }
    return _arrowIcon;
}
-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = KKHexColor(E84A55);
        _statusLabel.font = KKCNFont(11);
    }
    return _statusLabel;
}
-(UIControl *)control
{
    if (!_control) {
        _control = [[UIControl alloc]init];
        _control.backgroundColor = [UIColor whiteColor];
        [_control addTarget:self action:@selector(clickControl) forControlEvents:UIControlEventTouchUpInside];
    }
    return _control;
}
-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}
#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)clickControl
{
    if (!_isDeploy) {
        _isDeploy = YES;
    }else
    {
        _isDeploy = NO;
    }
    if (self.actionHandle) {
        self.actionHandle(@(_isDeploy));
    }
}
-(void)deploy;
{
    @weakify(self);
//    [self.mrgeItemArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:22 leadSpacing:0 tailSpacing:0];
//    [self.mrgeItemArr mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.left.equalTo(self.contentView).offset(15).priorityHigh();
//        make.right.equalTo(self.contentView).offset(-15).priorityHigh();
//    }];
//    
    [self.mrgeItemArr kkEachWithPreAndIndex:^(UIView *  _Nonnull obj, UIView *  _Nonnull preObj, NSUInteger idx) {
        if (!preObj) {
            [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView).offset(15).priorityHigh();
                make.right.equalTo(self.contentView).offset(-15).priorityHigh();
                make.top.equalTo(self.contentView);
            }];
        }else if(preObj && idx != self.mrgeItemArr.count -1)
        {
            [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView).offset(15).priorityHigh();
                make.right.equalTo(self.contentView).offset(-15).priorityHigh();
                make.top.equalTo(preObj.mas_bottom).offset(22).priorityHigh();
            }];
        }else
        {
            [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView).offset(15).priorityHigh();
                make.right.equalTo(self.contentView).offset(-15).priorityHigh();
                make.top.equalTo(preObj.mas_bottom).offset(22);
                make.bottom.equalTo(self.contentView);
            }];
        }
            
    }];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.control).offset(50);
        make.left.right.equalTo(self.control);
        make.bottom.equalTo(self).offset(-20).priorityHigh();
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.arrowIcon.image = KKImage(@"down_arrow");
        self.contentView.hidden = NO;
        [self layoutSubviews];
    } completion:^(BOOL finished) {
       
    }];
}
-(void)retract;
{
    @weakify(self);
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.control);
        make.bottom.equalTo(self);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.arrowIcon.image = KKImage(@"up_arrow");
        self.contentView.hidden = YES;
        //动画使用layoutSubviews，如果使用layoutifneed，动画出现跳动
        [self layoutSubviews];
    } completion:^(BOOL finished) {
    }];
}



@end
