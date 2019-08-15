//
//  IndentifyViewController.m
//  DigitalCurrency
//
//  Created by Michael on 2018/12/21.
//  Copyright © 2018年 bibidai. All rights reserved.
//

#import "IndentifyViewController.h"
#import "IndentifyModel.h"
@interface IndentifyViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//
@property (nonatomic, strong) UIView * titleView;
//
@property (nonatomic, strong) UILabel * titleLabel;
//
@property (nonatomic, strong) UIView * contentView;
//
@property (nonatomic, strong) UIView * hline;
//
@property (nonatomic, strong) UILabel * nameLabel;
//
@property (nonatomic, strong) UITextField * nameTextField;
//
@property (nonatomic, strong) UILabel * idcardLabel;
//
@property (nonatomic, strong) UITextField * idcardTextField;
////
//@property (nonatomic, strong) UILabel * photoTitleLabel;
////
//@property (nonatomic, strong) UIImageView * frontView;
////
//@property (nonatomic, strong) UIImageView * backView;
//
@property (nonatomic, strong) UIButton * rightBtn;
////
//@property (nonatomic, strong) UIImageView * frontIcon;
////
//@property (nonatomic, strong) UIImageView * backIcon;
////
//@property (nonatomic, strong) UILabel * frontLabel;
////
//@property (nonatomic, strong) UILabel * backLabel;

//
@property (nonatomic, assign) BOOL takeFrontPhoto;
//
@property (nonatomic, assign) BOOL takeBackPhoto;

//
@property (nonatomic, strong) UIImage * frontImage;
//
@property (nonatomic, strong) UIImage * backImage;
//
@property (nonatomic, strong) IndentifyModel * model;

//
@property (nonatomic, assign) BOOL nameInput;
//
@property (nonatomic, assign) BOOL idcardInput;

#pragma mark - inherent
/*! */
@property (nonatomic, strong) BFTaskCompletionSource *tcs;


@end

@implementation IndentifyViewController

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
    self.kkLeftBarItemHidden= NO;
    self.view.backgroundColor = KKHexColor(F5F6F7);
    self.navigationController.navigationBar.translucent = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;//默认是UIRectEdgeAll
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,15)];
    _rightBtn.enabled = NO;
    _rightBtn.titleLabel.font = KKCNFont(14);
    [_rightBtn setTitleColor:KKHexColor(1084F9) forState:UIControlStateNormal];
    [_rightBtn setTitleColor:KKHexColor(A6A6AB) forState:UIControlStateDisabled];
    [_rightBtn setTitle:@"全部提交" forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(submitInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    self.title = @"身份信息";
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
    [self.view addSubview:self.titleView];
    [self.titleView addSubview:self.titleLabel];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.hline];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.nameTextField];
    [self.contentView addSubview:self.idcardLabel];
    [self.contentView addSubview:self.idcardTextField];
//    [self.view addSubview:self.photoTitleLabel];
//    [self.view addSubview:self.frontView];
//    [self.view addSubview:self.backView];
//    [self.frontView addSubview:self.frontIcon];
//    [self.frontView addSubview:self.frontLabel];
//    [self.backView addSubview:self.backIcon];
//    [self.backView addSubview:self.backLabel];
    [self updateLayout];
}

#pragma mark - Layout
///=============================================================================
/// @name Layout
///=============================================================================
- (void)updateLayout {
    @weakify(self);
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleView).offset(15);
        make.centerY.equalTo(self.titleView);
    }];
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(100);
    }];
    [_hline mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView).multipliedBy(0.5);
        make.left.equalTo(self.contentView).offset(15);
        make.width.priorityHigh();
    }];
    [_nameTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(18);
        make.right.equalTo(self.contentView);
    }];
    [_idcardLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView).multipliedBy(1.5);
        make.left.equalTo(self.contentView).offset(15);
        make.width.priorityHigh();
    }];
    [_idcardTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.idcardLabel);
        make.left.equalTo(self.idcardLabel.mas_right).offset(18);
        make.right.equalTo(self.contentView);
    }];
//    [_photoTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.left.equalTo(self.view).offset(20);
//        make.top.equalTo(self.contentView.mas_bottom).offset(32);
//    }];
//    [_frontView mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.photoTitleLabel.mas_bottom).offset(20);
//        make.width.mas_equalTo(230);
//        make.height.mas_equalTo(145);
//    }];
//    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.frontView.mas_bottom).offset(16);
//        make.width.mas_equalTo(230);
//        make.height.mas_equalTo(145);
//    }];
//    [_frontIcon mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.centerX.centerY.equalTo(self.frontView);
//        make.height.width.mas_equalTo(40);
//    }];
//    [_backIcon mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.centerX.centerY.equalTo(self.backView);
//        make.height.width.mas_equalTo(40);
//    }];
//    [_frontLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.centerX.equalTo(self.frontIcon);
//        make.top.equalTo(self.frontIcon.mas_bottom).offset(16);
//    }];
//    [_backLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.centerX.equalTo(self.backIcon);
//        make.top.equalTo(self.backIcon.mas_bottom).offset(16);
//    }];
}

#pragma mark - Lazy
///=============================================================================
/// @name Lazy
///=============================================================================
-(UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    return _titleView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:@"*基本认证（必填）"];
        [attstr addAttribute:NSFontAttributeName value:KKCNFont(15) range:NSMakeRange(0, 9)];
        [attstr addAttribute:NSForegroundColorAttributeName value:KKHexColor(FF0606) range:NSMakeRange(0, 1)];
        [attstr addAttribute:NSForegroundColorAttributeName value:KKHexColor(646873) range:NSMakeRange(1, 8)];
        _titleLabel.attributedText = attstr;
    }
    return _titleLabel;
}
-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
-(UIView *)hline
{
    if (!_hline) {
        _hline = [[UIView alloc]init];
        _hline.backgroundColor = KKHexColor(E0E0E0);
    }
    return _hline;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:@"*真实姓名："];
        [attstr addAttribute:NSFontAttributeName value:KKCNFont(15) range:NSMakeRange(0, 6)];
        [attstr addAttribute:NSForegroundColorAttributeName value:KKHexColor(FF0606) range:NSMakeRange(0, 1)];
        [attstr addAttribute:NSForegroundColorAttributeName value:KKHexColor(9197a7) range:NSMakeRange(1, 5)];
        _nameLabel.attributedText = attstr;
    }
    return _nameLabel;
}
-(UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc]init];
        _nameTextField.textColor = KKHexColor(5D667A);
        _nameTextField.font = KKCNFont(15);
        @weakify(self);
        [_nameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.nameInput = x.length>0;
            self.rightBtn.enabled = self.idcardInput && self.nameInput;
            self.model.realName = x;
        }];
    }
    return _nameTextField;
}
-(UILabel *)idcardLabel
{
    if (!_idcardLabel) {
        _idcardLabel = [[UILabel alloc]init];
        NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:@"*身份证号："];
        [attstr addAttribute:NSFontAttributeName value:KKCNFont(15) range:NSMakeRange(0, 6)];
        [attstr addAttribute:NSForegroundColorAttributeName value:KKHexColor(FF0606) range:NSMakeRange(0, 1)];
        [attstr addAttribute:NSForegroundColorAttributeName value:KKHexColor(9197a7) range:NSMakeRange(1, 5)];
        _idcardLabel.attributedText = attstr;
    }
    return _idcardLabel;
}
-(UITextField *)idcardTextField
{
    if (!_idcardTextField) {
        _idcardTextField = [[UITextField alloc]init];
        _idcardTextField.textColor = KKHexColor(5D667A);
        _idcardTextField.font = KKCNFont(15);
        @weakify(self);
        [_idcardTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.idcardInput = x.length>0;
            self.rightBtn.enabled = self.idcardInput && self.nameInput;
            self.model.IDcardNumber = x;
        }];
    }
    return _idcardTextField;
}
//-(UILabel *)photoTitleLabel
//{
//    if (!_photoTitleLabel) {
//        _photoTitleLabel = [[UILabel alloc]init];
//        _photoTitleLabel.textColor = KKHexColor(646873);
//        _photoTitleLabel.font = KKCNFont(15);
//        _photoTitleLabel.text = @"高级认证（选填）";
//    }
//    return _photoTitleLabel;
//}
//-(UIImageView *)frontView
//{
//    if (!_frontView) {
//        _frontView = [[UIImageView alloc]initWithImage:KKImage(@"front_idcard")];
//        _frontView.userInteractionEnabled = YES;
//        @weakify(self);
//        [_frontView kkAddTapAction:^(id  _Nullable x) {
//            @strongify(self);
//            self.takeFrontPhoto = YES;
//            [self takePhotos];
//        }];
//    }
//    return _frontView;
//}
//-(UIImageView *)backView
//{
//    if (!_backView) {
//        _backView = [[UIImageView alloc]initWithImage:KKImage(@"back_idcard")];
//        _backView.userInteractionEnabled = YES;
//        @weakify(self);
//        [_backView kkAddTapAction:^(id  _Nullable x) {
//            @strongify(self);
//            self.takeBackPhoto = YES;
//            [self takePhotos];
//        }];
//    }
//    return _backView;
//}
//-(UILabel *)backLabel
//{
//    if (!_backLabel) {
//        _backLabel = [[UILabel alloc]init];
//        _backLabel.font = KKCNFont(11);
//        _backLabel.textColor = KKHexColor(1084F9);
//        _backLabel.text = @"点击拍摄身份证国徽面";
//    }
//    return _backLabel;
//}
//-(UILabel *)frontLabel
//{
//    if (!_frontLabel) {
//        _frontLabel = [[UILabel alloc]init];
//        _frontLabel.font = KKCNFont(11);
//        _frontLabel.textColor = KKHexColor(1084F9);
//        _frontLabel.text = @"点击拍摄身份证人像面";
//    }
//    return _frontLabel;
//}
//-(UIImageView *)frontIcon
//{
//    if (!_frontIcon) {
//        _frontIcon = [[UIImageView alloc]initWithImage:KKImage(@"icon_idcard")];
//    }
//    return _frontIcon;
//}
//-(UIImageView *)backIcon
//{
//    if (!_backIcon) {
//        _backIcon = [[UIImageView alloc]initWithImage:KKImage(@"icon_idcard")];
//    }
//    return _backIcon;
//}
#pragma mark - Delegate
///=============================================================================
/// @name Delegate
///=============================================================================
// 完成图片的选取后调用的方法
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    // 选取完图片后跳转回原控制器
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
//     * UIImagePickerControllerMediaType; // 媒体类型
//     * UIImagePickerControllerOriginalImage; // 原始图片
//     * UIImagePickerControllerEditedImage; // 裁剪后图片
//     * UIImagePickerControllerCropRect; // 图片裁剪区域（CGRect）
//     * UIImagePickerControllerMediaURL; // 媒体的URL
//     * UIImagePickerControllerReferenceURL // 原件的URL
//     * UIImagePickerControllerMediaMetadata // 当数据来源是相机时，此值才有效
//     */
//    // 从info中将图片取出，并加载到imageView当中
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    if (self.takeFrontPhoto) {
//        _frontImage = image;
//        self.frontView.image = image;
//        self.takeFrontPhoto = NO;
//    }
//    if (self.takeBackPhoto) {
//        _backImage = image;
//        self.backView.image = image;
//        self.takeBackPhoto = NO;
//    }
//    //    // 创建保存图像时需要传入的选择器对象（回调方法格式固定）
//    //    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
//    //    // 将图像保存到相册（第三个参数需要传入上面格式的选择器对象）
//    //    UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
//}
//
//// 取消选取调用的方法
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    self.takeBackPhoto = NO;
//    self.takeFrontPhoto = NO;
//    [self dismissViewControllerAnimated:YES completion:nil];
//}



#pragma mark - Action
///=============================================================================
/// @name Action
///=============================================================================
-(void)submitInfo
{
//    if (!self.frontImage && !self.backImage) {
        [self requestSubmit];
//    }else
//    {
//        [self requestUpLoad];
//    }

}

-(void)takePhotos
{
    // 创建UIImagePickerController实例
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePickerController.delegate = self;
    // 是否显示裁剪框编辑（默认为NO），等于YES的时候，照片拍摄完成可以进行裁剪
    imagePickerController.allowsEditing = YES;
    // 设置照片来源为相机
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 设置进入相机时使用前置或后置摄像头
    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    // 展示选取照片控制器
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - Public
///=============================================================================
/// @name Public
///=============================================================================




#pragma mark - Private
///=============================================================================
/// @name Private
///=============================================================================

-(void)requestUpLoad
{
    if (!self.frontImage && !self.backImage) {
        return;
    }
    NSData * frontdata;
    if (self.frontImage) {
        frontdata = [NSData zipNSDataWithImage:self.frontImage];
    }
    NSData * backdata;
    if (self.backImage) {
        backdata = [NSData zipNSDataWithImage:self.backImage];
    }
    NSDictionary * dic = @{
                           @"uuid":[UserManager manager].userid,
                           };
    @weakify(self);
    [[KKRequest request].urlString(@"").paramaters() {
        [formData appendPartWithFileData:frontdata name:@"front" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:backdata name:@"back" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:backdata name:@"inhand" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
    }).needCustomFormat(YES).view(self.view).kkTask kkContinueBlock:^id _Nullable(BFTask * _Nonnull t, JSONModel * _Nonnull result) {
        @strongify(self);
        if (result.code==1000) {
            self.model.IDcardBackURI = result.data[@""];
            self.model.IDcardFrontURI = result.data[@""];
            self.model.IDcardInHandURI = result.data[@""];
            [self requestSubmit];
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)requestSubmit
{
   
    NSDictionary * dic = @{
                           @"realName":self.nameTextField.text,
                           @"IDCardNumber":self.idcardTextField.text,
//                           @"backUrl":self.model.IDcardBackURI.length ? self.model.IDcardBackURI : @"",
//                           @"frontUrl":self.model.IDcardFrontURI.length ? self.model.IDcardFrontURI : @"",
//                           @"inhandUrl":self.model.IDcardFrontURI.length ? self.model.IDcardInHandURI : @""
                           };
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code==1000) {
            [self.view kk_makeToast:result.message];
            [self.tcs trySetResult:@(YES)];
            [self.navigationController popViewControllerAnimated:YES];
        
        }else
        {
            [self.view kk_makeToast:result.message];
        }
        return nil;
    }];
}
-(void)requestData
{
    @weakify(self);
    [[KKRequest jsonRequest].urlString(@"").paramaters() {
        @strongify(self);
        if (result.code==1000) {
            self.model = [IndentifyModel modelWithJSON:result.data];
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
    self.nameTextField.text = self.model.realName;
    self.nameTextField.enabled = self.idcardTextField.enabled = (self.model.identified == 0 ||self.model.identified == 3 )? YES : NO;
//    self.frontView.userInteractionEnabled = self.backView.userInteractionEnabled = (self.model.identified == 0 ||self.model.identified == 1 ||self.model.identified == 3 )? YES : NO;
    self.idcardTextField.text = self.model.IDcardNumber;
    self.nameInput = self.model.realName.length ? YES : NO;
    self.idcardInput = self.model.IDcardNumber.length ? YES : NO;
    self.rightBtn.enabled = self.nameInput && self.idcardInput;
//    [self.frontView sd_setImageWithURL:[NSURL URLWithString:self.model.IDcardFrontURI] placeholderImage:KKImage(@"front_idcard")];
//    [self.backView sd_setImageWithURL:[NSURL URLWithString:self.model.IDcardBackURI] placeholderImage:KKImage(@"back_idcard")];
//    self.rightBtn.hidden = (self.model.identified == 2||self.model.identified == 4)  ? YES : NO;
    self.rightBtn.hidden = self.model.identified == 1  ? YES : NO;

}
@end
