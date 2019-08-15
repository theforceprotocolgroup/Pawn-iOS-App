//
//  BorrowIntroductionHeaderView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/12.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "BorrowIntroductionHeaderView.h"

@interface BorrowIntroductionHeaderView ()

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

@implementation BorrowIntroductionHeaderView

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
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom).offset(26);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    if (_contentArr.count) {
        [self setUpItem];
    }
}
-(void)setUpItem
{
    __weak typeof(self) weakSelf = self;
    [_contentItemArr enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_contentItemArr removeAllObjects];
    [_contentArr enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * itemView = [[UIView alloc]init];
        itemView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:itemView];
        UILabel * title = [[UILabel alloc]init];
        title.font = KKCNFont(12);
        title.textColor = KKHexColor(5D667A);
        title.textAlignment = NSTextAlignmentCenter;
        title.numberOfLines = 2;
        title.text = [NSString stringWithFormat:@"%@",obj[@"title"]];
        [itemView addSubview:title];
        
        
        UIImageView * image = [[UIImageView alloc]initWithImage:KKImage(obj[@"icon"])];
        [itemView addSubview:image];
        
        UIView * rightLineView = [[UIView alloc]init];
        rightLineView.backgroundColor = KKHexColor(1084F9);
        [itemView addSubview:rightLineView];
        
        __block CGFloat imageLeft = 0;
        __block CGFloat itemwidth = 0;
        imageLeft = idx == 0 ? 32 : 0;
        if (idx == 0) {
            itemwidth = 32 + 17 + [self lineWidth];
        }else if (idx == self.contentArr.count-1)
        {
            itemwidth = 32 +17;
            rightLineView.hidden = YES;
        }else
        {
            itemwidth = 17 + [self lineWidth];
        }
        
        [image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(12);
            make.bottom.equalTo(itemView);
            make.height.width.mas_equalTo(17).priorityHigh();
            make.left.equalTo(itemView).offset(imageLeft).priorityHigh();
        }];
        [title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemView.mas_top);
            make.centerX.equalTo(image);
        }];
        [rightLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(image);
            make.height.mas_equalTo(2);
            make.left.equalTo(image.mas_right);
            make.right.equalTo(itemView);
        }];
        [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(self.contentView);
            make.width.mas_equalTo(itemwidth);
            make.top.equalTo(self.contentView);
        }];
        [self.contentItemArr addObject:itemView];
    }];
    [self.contentItemArr kkEachWithPreAndIndex:^(UIView*  _Nonnull obj, UIView*  _Nonnull preObj, NSUInteger idx) {
        [obj mas_updateConstraints:^(MASConstraintMaker *make) {
            if (preObj) {
                make.left.equalTo(preObj.mas_right);
            }else
            {
                make.left.mas_equalTo(0);
            }
        }];
    }];
}
-(CGFloat)lineWidth
{
    return (SCREEN_WIDTH - 64 - 17 * _contentArr.count)/(_contentArr.count-1);
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
        _titleLabel.text = @"流程说明";
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
