//
//  HelpDetailViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/8.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "HelpDetailModel.h"
@interface HelpDetailViewController ()
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UITextView * textView;
//
@property (nonatomic, strong) NSString * issueID;
//
@property (nonatomic, strong) HelpDetailModel * model;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation HelpDetailViewController

#pragma mark - RouterDataDelegate
///=============================================================================
/// @name RouterDataDelegate
///=============================================================================

- (void)routerPassParamters:(id)tuple {
    self.issueID = tuple;
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
    self.kkHairlineHidden = NO;
    self.kkBarColor = [UIColor whiteColor];
    self.view.backgroundColor = KKHexColor(ffffff);
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;//默认是UIRectEdgeAll
    self.title = @"帮助中心";
    // Do any additional setup after loading the view.
    [self addViews];
    
    [self requestData];
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
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(22);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
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
        _titleLabel.font = KKCNFont(15);
        _titleLabel.textColor = KKHexColor(041E45);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = KKCNFont(14);
        _textView.textColor = KKHexColor(9197A7);
        _textView.editable = NO;
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
            self.model = [HelpDetailModel modelWithJSON:result.data];
            [self reloadData];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}

-(void)reloadData
{
    self.titleLabel.text = self.model.title;
    self.textView.text = self.model.content;
}

@end
