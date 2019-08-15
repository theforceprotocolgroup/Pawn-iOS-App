//
//  KKWebViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/14.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "KKWebViewController.h"
#import "KKWebViewController+Utils.h"

@interface KKWebViewController ()<UIWebViewDelegate, POPAnimationDelegate ,KKWebViewBrigdeProtocol,BackButtonHandlerProtocol>

@property (nonatomic, assign, readwrite)LoadType loadType;

@property (nonatomic, strong, readwrite) NSURLRequest * lastRequest;

@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) JSContext * context;

@property (strong , nonatomic) UIButton * closebtn;

@end

@implementation KKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kkHairlineHidden = NO;
    self.kkDistanceToLeftEdge = 0.01f;
    self.kkBarColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
//    [self.navigationController.view addSubview:self.progress];
    [self setUpUserAgent];
    [self setUpWeixinShare];
    [self loadWebview];
    // Do any additional setup after loading the view.
//    if (![self needreloadByBack]) [self loadWeb
    // Do any additional setup after loading the view.
}

#pragma mark - Router
///=============================================================================
/// @name Router
///=============================================================================

- (void)routerPassParamters:(RACTuple *)data {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)data;
        NSArray *arr = [dict allKeys];
        if ([arr containsObject:@"htmlStr"]) self.htmlStr = dict[@"htmlStr"];
        if ([arr containsObject:@"hostUrl"]) self.hostUrl = dict[@"hostUrl"];
        return;
    }
    if ([data.first hasPrefix:@"http"]) {
        self.hostUrl = data.first;
    } else {
        self.htmlStr = data.first;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.progress remove];
//    self.progress = nil;
    [self.closebtn removeFromSuperview];
    self.closebtn = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self needreloadByBack]) [self loadWebview];
    if (!_closebtn) [self.navigationController.navigationBar addSubview:self.closebtn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - private setting

- (void)manualLoadPage {
    [self loadWebview];
}

-(void)setHtmlStr:(NSString *)htmlStr
{
    _htmlStr = htmlStr;
    _loadType = LoadTypeHTML;
}
-(void)setHostUrl:(NSString *)hostUrl
{
    _hostUrl = hostUrl;
    _loadType = LoadTypeURL;
}

-(void)setUpUserAgent
{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    KKLog(@"navigator.userAgent == %@",secretAgent);
    if ([secretAgent rangeOfString:@"_sudaixiong_ios"].location==NSNotFound) {
        NSString *newUagent = [NSString stringWithFormat:@"%@_sudaixiong_ios",secretAgent];
        NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:newUagent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }
}

-(void)setUpWeixinShare
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResp:) name:@"WXResponseNotification" object:nil];
}

-(void)setCookie:(NSURLRequest *)request
{
    NSString * urlhost = request.URL.host;
    if ([self isHostURLJDJK:urlhost]) {

    }
}
-(void)setUpHostURL
{
    if ([self.hostUrl rangeOfString:@"http"].location==NSNotFound) {
        self.hostUrl=[NSString stringWithFormat:@"http://%@",self.hostUrl];
    }
}

#pragma mark - action
-(void)rightButtonClicked:(id)sender
{
    
}
-(void)loadWebview
{
    if (_loadType == LoadTypeURL) {
        [self setUpHostURL];
        self.lastRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.hostUrl]];
        [_webView loadRequest:self.lastRequest];
        
    }else
    {
        [_webView loadHTMLString:self.htmlStr baseURL:nil];
    }
//    self.dataSet.isLoading = YES;
    
}

#pragma mark - webview delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    self.dataSet.hasData = NO;
//    self.dataSet.isLoading = NO;
    [self loadWebViewFailed:webView didFailLoadWithError:error];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.dataSet.hasData = YES;
//    self.dataSet.isLoading = NO;
    if ([webView canGoBack]) {
        self.closebtn.hidden = NO;
        _closebtn.enabled = YES;
    } else {
        self.closebtn.hidden = YES;
        _closebtn.enabled = NO;
    }
    [self loadWebViewFinished:webView];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return [self shouldLaodWebViewHandle:request];
}

#pragma mark - publice

-(void)loadWebViewFailed:(UIWebView *)webview didFailLoadWithError:(NSError *)error
{
//    [UFQProcessView stop];
    
    if ([error code]==NSURLErrorCancelled) {
        return;
    }
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) {
        return;
    }
    if ([[AFNetworkReachabilityManager sharedManager]isReachable]) {
        //        [self showRequestFailureView:YES withHasNetConnect:YES WithPerformSelector:@selector(reloadWebView)];
    }else
    {
        //        [self showRequestFailureView:YES withHasNetConnect:NO WithPerformSelector:@selector(reloadWebView)];
    }
    
}

-(void)loadWebViewFinished:(UIWebView *)webview
{
//    [UFQProcessView stop];
    if (self.navtitle.length) {
        self.navigationItem.title=self.navtitle;
    }else
    {
        NSString *title=[_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSString *status=[_webView stringByEvaluatingJavaScriptFromString:@"window.XMLHttpRequest.getAllResponseHeaders()"];
        KKLog(@"%@---",status);
        self.navigationItem.title=title;
    }
    
    //    [self showRequestFailureView:NO withHasNetConnect:YES WithPerformSelector:nil];
    
    //获取js上下文
    self.context = [webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [self.context setExceptionHandler:^(JSContext * context , JSValue *exceptionValue) {
        context.exception = exceptionValue;
        KKLog(@"%@",context.exception);
    }];
    
    //调用oc,设置协议
    self.context[kJSBridge] = self;
    self.context[kJSCamera] = self;
    //调用js方法
    JSValue * value =  [self.context evaluateScript:kToJSgetSupportedShareType];
    int32_t hiden = [value toInt32];
    if (hiden == 1) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareButton"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked:)];
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(BOOL)shouldLaodWebViewHandle:(NSURLRequest*)request;
{
    [self setCookie:request];
    
    if ([self jumpToOtherPage:request]) {
        
        return NO;
    }else
    {
        self.lastRequest = request;
        return YES;
    }
}

-(void)reloadWebView;
{
    [self.webView loadRequest:self.lastRequest];
}
-(BOOL)canGoBack;
{
    if ([self.webView canGoBack]) {
        return YES;
    }else
    {
        return NO;
    }
}

- (BOOL)navigationPopActiveForType:(KKBackType)type {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return NO;
    } else
    {
        return YES;
    }
}

- (void)clearCookies
{
    NSArray * cookArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@""]];
    for (NSHTTPCookie*cookie in cookArray) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    NSArray * cookArray1 = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@""]];
    for (NSHTTPCookie*cookie in cookArray1) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    NSArray * cookArray2 = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@""]];
    for (NSHTTPCookie*cookie in cookArray2) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

#pragma mark - private

- (void)clickedCloseBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - pop delegate
// POPanimation代理
- (void)pop_animationDidStart:(POPAnimation *)anim {
    
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    
    if ([[anim valueForKey:@"dismiss"] isEqualToString:@"dismiss"]) {
        [self.backView removeFromSuperview];
//        [self.shareView removeFromSuperview];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}

#pragma mark - Getter
-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.opaque = NO;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        _webView.scrollView.showsHorizontalScrollIndicator=NO;
        _webView.scrollView.showsVerticalScrollIndicator=YES;
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        adjustsScrollViewInsets(_webView);
//        self.dataSet = [PTSEmptyDataSet set](_webView.scrollView);
//        self.dataSet.hasBtn = YES;
        @weakify(self);
//        [self.dataSet setActionBlock:^(RACTuple *x){
//            @strongify(self);
//            [self loadWebview];
//        }];
        
    }
    return _webView;
}
//- (UFQProcessView *)progress {
//
//    if (!_progress) {
//        _progress = [[UFQProcessView alloc] initWithFrame:CGRectMake(0, TopHeight-3, SCREEN_WIDTH, 3)];
//    }
//    return _progress;
//
//}
- (UIView *)backView {
    
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = .7;
        
    }
    return _backView;
    
}

-(BOOL)needreloadByBack
{
    return NO;
}
#pragma mark - BrigdeProtocol
-(void)h5Share:(NSString *)url :(NSString *)title :(NSString *)description :(NSString *)iconUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.shareModel = [[SDBShareWeiXinModel alloc]init];
//        self.shareModel.url = url;
//        self.shareModel.title = title;
//        self.shareModel.desc = description;
//        self.shareModel.iconUrl = iconUrl;
//        [self showShareView];
    });
}
-(NSString*)getUserId:(NSString*)string
{
    
    return @"";
}
- (NSString *)getUserToken:(NSString *)string {
    return @"";
}
-(void)getLocation:(NSString *)string :(NSString *)callBack
{
//    [[SDBLocationManager shareManager]startLocationWithType:SDBLocationUpdateTypeDefault];
//
//    @weakify(self);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //        [selfWeak showProgressHud:YES];
//        [[SDBLocationManager shareManager] getLocationMessage:^(SDBLocationModel *model, NSString *errorMsg) {
//            @strongify(self);
//            NSDictionary * dic = nil;
//            if (errorMsg.length) {
//                dic = @{@"resultCode":@"0",
//                        @"result":@"OK",
//                        };
//
//                [self.view sdb_makeToast:errorMsg];
//            }else
//            {
//                dic = @{@"resultCode":@"200",
//                        @"result":@{@"latitude":model.latitude ,
//                                    @"longtitude":model.longitude
//                                    }
//                        };
//            }
//            NSString * str = [NSString stringWithFormat:@"%@('%@')",callBack,[dic jsonStringEncoded]];
//            [self.context evaluateScript:str];
//            //            [selfWeak showProgressHud:NO];
//
//        }];
//    });
}
-(void)getPicture:(NSString *)string :(NSString *)callBack
{
    
}
-(void)takePicture:(NSString *)string :(NSString *)callBack
{
    
}

- (UIButton *)closebtn {
    if (!_closebtn) {
        self.closebtn = [[UIButton alloc]init];
        [_closebtn setTitle:@"关闭" forState:UIControlStateNormal];
        _closebtn.titleLabel.textColor = KKHexColor(ffffff);
        [_closebtn addTarget:self action:@selector(clickedCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
        _closebtn.frame = CGRectMake(41, 3, 50, 35);
        _closebtn.hidden = YES;
        _closebtn.enabled = NO;
    }
    return _closebtn;
}

@end
