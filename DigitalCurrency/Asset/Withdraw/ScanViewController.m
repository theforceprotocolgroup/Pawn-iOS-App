//
//  ScanViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/9.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
//扫描框
@property (nonatomic, strong) UIView * view_bg;
//扫描线
@property (nonatomic, strong) CALayer * layer_scanLine;
//提示语
@property (nonatomic, strong) UILabel * lab_word;

@property (nonatomic, strong) NSTimer * timer;

//采集的设备
@property (strong,nonatomic) AVCaptureDevice * device;
//设备的输入
@property (strong,nonatomic) AVCaptureDeviceInput * input;
//输出
@property (strong,nonatomic) AVCaptureMetadataOutput * output;
//采集流
@property (strong,nonatomic) AVCaptureSession * session;
//窗口
@property (strong,nonatomic) AVCaptureVideoPreviewLayer * previewLayer;
#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation ScanViewController

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
    self.kkHairlineHidden = NO;
    self.kkBarColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = KKHexColor(F5F6F7);
    self.title = @"扫描二维码";
    [self addViews];
    [self startScan];
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
    [self.view addSubview:self.view_bg];
    
    [self.view addSubview:self.lab_word];
    
    [_view_bg.layer addSublayer:self.layer_scanLine];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_view_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(0.7 * SCREEN_WIDTH,  0.5 * (SCREEN_HEIGHT - 64)));
        make.left.mas_equalTo(@(0.15 * SCREEN_WIDTH));
        make.top.mas_equalTo(@(0.25 * (SCREEN_HEIGHT - 64) - 32));
    }];
    
    [_lab_word mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 21));
        make.left.mas_equalTo(@0);
        make.top.mas_equalTo(self.view_bg.mas_bottom).with.offset(20);
    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================

- (UIView *)view_bg {
    
    if (!_view_bg) {
        
        _view_bg = [[UIView alloc] init];
        
        _view_bg.layer.borderColor = [UIColor whiteColor].CGColor;
        
        _view_bg.layer.borderWidth = 1.0;
    }
    
    return _view_bg;
}

- (CALayer *)layer_scanLine {
    
    if (!_layer_scanLine) {
        
        CALayer * layer = [[CALayer alloc] init];
        
        layer.bounds = CGRectMake(0, 0, 0.7 * SCREEN_WIDTH, 1);
        
        layer.backgroundColor = [UIColor greenColor].CGColor;
        
        //起点
        layer.position = CGPointMake(0, 0);
        
        //定位点
        layer.anchorPoint = CGPointMake(0, 0);
        
        _layer_scanLine = layer;
    }
    
    return _layer_scanLine;
}

- (UILabel *)lab_word {
    
    if (!_lab_word) {
        
        _lab_word = [[UILabel alloc] init];
        
        _lab_word.textAlignment = NSTextAlignmentCenter;
        
        _lab_word.textColor = [UIColor whiteColor];
        
        _lab_word.font = KKCNBFont(13);
        
        _lab_word.text = @"将二维码/条码放入框内，即可进行扫描";
    }
    
    return _lab_word;
}

- (NSTimer *)timer {
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scanLineMove) userInfo:nil repeats:YES];
        
        [_timer fire];
    }
    return _timer;
}


#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    //得到解析到的结果
    NSString * stringValue;
    
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        
        stringValue = metadataObject.stringValue;
    }
    
    //停止扫描
    [_session stopRunning];
    
    self.timer.fireDate = [NSDate distantFuture];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"提现地址：%@", stringValue] preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self.previewLayer removeFromSuperlayer];
        
        [self.timer invalidate];
        
        self.timer = nil;
        
        [self.tcs trySetResult:stringValue];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction * actionReStart = [UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self.session startRunning];
        
        self.timer.fireDate = [NSDate distantPast];
        
    }];
    
    
    [alertController addAction:actionCancel];
    
    [alertController addAction:actionReStart];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}




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

- (void)startScan {
    
    // Device 实例化设备   //获取摄像设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input 设备输入     //创建输入流
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    // Output 设备的输出  //创建输出流
    _output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理   在主线程里刷新
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session         //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    // 二维码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
    
    // Preview 扫描窗口设置
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    _output.rectOfInterest = CGRectMake(0.15, 0.25, 0.7, 0.5);
    
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    
    // Start 开始扫描   //开始捕获
    [_session startRunning];
    
    self.timer.fireDate = [NSDate distantPast];
    
}

- (void)scanLineMove {
    
    CABasicAnimation * animation = [[CABasicAnimation alloc] init];
    
    //告诉系统要执行什么样的动画
    animation.keyPath = @"position";
    
    //设置通过动画  layer从哪到哪
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0.5 * (SCREEN_HEIGHT - 64))];
    
    //动画时间
    animation.duration = 4.0;
    
    //设置动画执行完毕之后不删除动画
    animation.removedOnCompletion = NO;
    
    //设置保存动画的最新动态
    animation.fillMode = kCAFillModeForwards;
    
    //添加动画到layer
    [self.layer_scanLine addAnimation:animation forKey:nil];
    
}


@end
