//
//  BorrowIntroductionBottomView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/12.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "BorrowIntroductionBottomView.h"

@interface BorrowIntroductionBottomView ()
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIImageView * titleIcon;
//
@property (nonatomic, strong) UIView * contentView;

//
@property (nonatomic, strong) NSMutableArray * contentArr;
//
@property (nonatomic, strong) NSMutableArray * contentItemArr;
#pragma mark - inherent
/*!  */
@property (nonatomic, copy) KKActionHandle actionHandle;
/*!  */
@property (nonatomic, strong) id model;

@end

@implementation BorrowIntroductionBottomView

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
    return ^(NSArray *tuple) {
        @strongify(self);
        [self.contentArr removeAllObjects];
        [self.contentArr addObjectsFromArray:tuple];
        [self setNeedsUpdateConstraints];
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
        [self addViews];
        _contentArr = [[NSMutableArray alloc]init];
        _contentItemArr = [[NSMutableArray alloc]init];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addViews {
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.titleIcon];
    [self.titleView addSubview:self.titleLabel];
    [self addSubview:self.contentView];
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
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    [_titleIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.titleView);
        make.left.equalTo(self.titleView).offset(15);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.self.titleIcon);
        make.left.equalTo(self.titleIcon.mas_right).offset(8);
    }];
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-33).priorityHigh();
    }];
    if (_contentArr.count) {
        [self setUpItem];
    }
}
-(void)setUpItem
{
    @weakify(self);
    [_contentItemArr enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_contentItemArr removeAllObjects];
    [_contentArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * itemView = [[UIView alloc]init];
        itemView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:itemView];
        UILabel * title = [[UILabel alloc]init];
        title.font = KKCNFont(13);
        title.textColor = KKHexColor(9197A7);
        title.textAlignment = NSTextAlignmentLeft;
        title.text = [NSString stringWithFormat:@"%@",obj[@"title"]];
        [itemView addSubview:title];
        
        UILabel * content = [[UILabel alloc]init];
        content.font = KKCNFont(13);
        content.textColor = KKHexColor(435061);
        content.textAlignment = NSTextAlignmentLeft;
        content.text = [NSString stringWithFormat:@"%@",obj[@"content"]];
        content.numberOfLines = 0;
        content.preferredMaxLayoutWidth = SCREEN_WIDTH - 95;
        [itemView addSubview:content];
        
        [title setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        [title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemView.mas_top);
            make.left.equalTo(itemView);
        }];
        [content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title);
            make.left.equalTo(title.mas_right).offset(15);
            make.right.equalTo(itemView);
            make.bottom.equalTo(itemView);
        }];
        [self.contentItemArr addObject:itemView];
    }];
    [self.contentItemArr kkEachWithPreAndIndex:^(UIView *  _Nonnull obj, UIView *  _Nonnull preObj, NSUInteger idx) {
        if (!preObj) {
            [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView).offset(15).priorityHigh();
                make.right.equalTo(self.contentView).offset(-15).priorityHigh();
                make.top.equalTo(self.contentView);
            }];
        }else if(preObj && idx != self.contentItemArr.count -1)
        {
            [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView).offset(15).priorityHigh();
                make.right.equalTo(self.contentView).offset(-15).priorityHigh();
                make.top.equalTo(preObj.mas_bottom).offset(33);
            }];
        }else
        {
            [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(self.contentView).offset(15).priorityHigh();
                make.right.equalTo(self.contentView).offset(-15).priorityHigh();
                make.top.equalTo(preObj.mas_bottom).offset(33);
                make.bottom.equalTo(self.contentView);
            }];
        }
        
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
        _titleLabel.font = KKCNBFont(15);
        _titleLabel.textColor = KKHexColor(0C1E48);
        _titleLabel.text = @"交易规则";
    }
    return _titleLabel;
}

-(UIImageView *)titleIcon
{
    if (!_titleIcon) {
        _titleIcon = [[UIImageView alloc]initWithImage:KKImage(@"titleIcon")];
    }
    return _titleIcon;
}
-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}
-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================





@end
