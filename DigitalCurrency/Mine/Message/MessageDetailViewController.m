//
//  MessageDetailViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/16.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UITextView * textView;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation MessageDetailViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(id)tuple {
    self.noticeID = tuple;
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
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = KKHexColor(ffffff);
    self.title = @"消息中心";
    [self addViews];
    [self requestData];
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
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.right.bottom.equalTo(self.view).offset(-15);
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
        _titleLabel.textColor = KKHexColor(041E45);
        _titleLabel.font = KKCNBFont(15);
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-30;
    }
    return _titleLabel;
}
-(UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.editable = NO;
        _textView.textColor = KKHexColor(9197A7);
        _textView.font = KKCNFont(14);
    }
    return _textView;
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
-(void)requestData
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code==1000) {
            self.titleLabel.text = result.data[@""];
            self.textView.text = result.data[@""];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}

-(void)test
{
    NSDictionary * data =  @{
        @"id": @"1",
        @"title": @"notice111",
        @"content": @"您于2018年12月15日23点32分到款3.25.00000BTC，请查收",
        @"isRead": @(YES),
        @"sentTime": @"2018-07-29 15:14:28",
        @"lastReadTime": @"2018-07-29 15:14:28"
        };
    
    
    self.titleLabel.text = data[@""];
    self.textView.text = data[@""];
}


@end
