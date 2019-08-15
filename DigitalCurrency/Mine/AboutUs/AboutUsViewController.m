//
//  AboutUsViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/7.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
//
@property (nonatomic, strong) UIImageView * icon;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UITextView * textView;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation AboutUsViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(id)tuple {
    
}

#pragma mark - RouterTask
///=============================================================================
/// @name RouterTask
///=============================================================================

- (nullable BFTask *)delegateTask {
    return self.tcs.task;
}

- (BFTaskCompletionSource *)tcs {
    if (!_tcs) {
        _tcs = [BFTaskCompletionSource taskCompletionSource];
    }
    return _tcs;
}

#pragma mark - LifeCycle
///=============================================================================
/// @name LifeCycle
///=============================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.kkHairlineHidden = YES;
    self.kkBarColor = [UIColor whiteColor];
    self.kkLeftBarItemHidden= NO;
    self.title = @"关于我们";
    self.view.backgroundColor = KKHexColor(ffffff);
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;//默认是UIRectEdgeAll
    [self addViews];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - View
///=============================================================================
/// @name addViews
///=============================================================================
- (void)addViews {
    [self.view addSubview:self.icon];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.textView];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(47);
        make.height.width.mas_equalTo(60);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.icon.mas_bottom).offset(13);
    }];
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = KKCNFont(16);
        _titleLabel.textColor = KKHexColor(5170EB);
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _titleLabel.text = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    return _titleLabel;
}
-(UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.editable = NO;
        _textView.font = KKCNFont(14);
        _textView.textColor = KKHexColor(9197A7);
        _textView.text = @"       币币贷是一家全球知名的加密数字资产借贷平台，主要提供比特币、以太币、EOS等上百种加密数字资产的币币借贷，STO资产借贷及其他基于加密数字资产的衍生品交易平台。\n\n       币币贷基于去中心化数字资产借贷协议（原力协议）搭建，加入原力协议全球借贷网络，共享全球借贷订单。无论是有借款需求的用户，还是具有投资（出借）需求的用户，均可在币币贷快速达成交易。\n\n       币币贷平台由分布在全球多个国家的富有经验的人士运营管理，团队来自于全球知名高校，并且拥有大型互联网和金融资产交易公司的工作经验。";
    }
    return _textView;
}
-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        _icon.image = KKImage(icon);
    }
    return _icon;
}


#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================




#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================




#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================




#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================





@end
