//
//  ZRQRCodeViewController.m
//  ZRQRCodeViewController
//
//  Created by Victor John on 7/1/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//

#import "ZRQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZRAlertController.h"

static MyBlockCompletion recognizeCompletion;
static MyActionSheetCompletion actionSheetCompletion;

#define ScanMenuHeight 45

@interface ZRQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    AVCaptureSession * session;   //输入输出的中间桥梁
    UIButton * torchBtn;          //开灯关灯
}

@property (nonatomic, strong) NSTimer *scanTimer;
@property (nonatomic, strong) UIImageView *scanImage0;
@property (nonatomic, strong) UIImageView *scanImage1;
@property (nonatomic, assign) CGRect captureRectArea;
@property (nonatomic, strong) CIDetector *detector;
@property (nonatomic, strong) NSArray *qrCodeActionSheets;

@property (nonatomic, strong) UIViewController *lastController;//The last controller
@end

@implementation ZRQRCodeViewController

- (NSArray *)qrCodeActionSheets
{
    if (!_qrCodeActionSheets) {
        _qrCodeActionSheets = [[NSArray alloc] init];
    }
    return _qrCodeActionSheets;
}

- (CIDetector *)detector
{
    if (!_detector) {
        _detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    }
    return _detector;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (instancetype)initWithScanType:(ZRQRCodeScanType)scanType
{
    if (self = [super init]) {
        self.scanType = scanType;
    }
    return self;
}

/*
 * QR Code Scanning immediately
 **/
- (void)QRCodeScanningWithViewController:(UIViewController *)viewController completion:(MyBlockCompletion)completion
{
    if (!viewController) {
        NSLog(@"Parameter viewController can not nil!");
        return;
    }
    
    if (completion) {
        recognizeCompletion = completion;
    }

    [viewController presentViewController:self animated:YES completion:nil];
}

/*
 * Recogize a QR Code picture through the Photo Library
 **/
- (void)recognizationByPhotoLibraryViewController:(UIViewController *)viewController completion:(MyBlockCompletion)completion
{
    if (!viewController) {
        NSLog(@"Parameter viewController can not nil!");
        return;
    }
    
    if (completion) {
        recognizeCompletion = completion;
    }
    
    [viewController addChildViewController:self];
    self.lastController = viewController;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

/*
 * Extract QR Code by Long press object , which maybe is UIImageView, UILabel, UIButton, UIWebView, WKWebView, UIView, UIViewController , all of them , but that's okay for this method to extract.
 **/
- (void)extractQRCodeByLongPressViewController:(UIViewController *)viewController Object:(id)object completion:(MyBlockCompletion)completion
{
    if (!viewController) {
        NSLog(@"Parameter viewController can not nil!");
        return;
    }
    
    if (!object) {
        NSLog(@"Parameter object can not nil!");
        return;
    }
    
    if (completion) {
        recognizeCompletion = completion;
    }
    
    [self bindLongPressGesture:viewController Object:object];
}

- (void)extractQRCodeByLongPressViewController:(UIViewController *)viewController Object:(id)object actionSheetCompletion:(MyActionSheetCompletion)actionSheetsCompletion completion:(MyBlockCompletion)completion
{
    if (!viewController) {
        NSLog(@"Parameter viewController can not nil!");
        return;
    }
    
    if (!object) {
        NSLog(@"Parameter object can not nil!");
        return;
    }
    
    if (completion) {
        recognizeCompletion = completion;
    }
    
    if (actionSheetsCompletion) {
        actionSheetCompletion = actionSheetsCompletion;
    }
    
    [self bindLongPressGesture:viewController Object:object];
}

- (void)setActionSheets:(NSArray *)actionSheets
{
    _actionSheets = actionSheets;
    if (_actionSheets && _actionSheets.count > 0) {
        self.qrCodeActionSheets = _actionSheets;
    }
}

- (void)bindLongPressGesture:(UIViewController *)viewController Object:(id)object
{
    [viewController addChildViewController:self];
    self.lastController = viewController;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(extractQRCodeByLongPress:)];
    if ([object isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView *)object;
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:longPressGesture];
    }
}

- (void)extractQRCodeByLongPress:(UIGestureRecognizer *)gesture
{
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    if (self.qrCodeActionSheets.count > 0) {
        for (NSString *str in self.qrCodeActionSheets) {
            [tmpArr addObject:str];
        }
    }
    
    NSString *tExtractTxt = [[NSString alloc] init];
    if (self.extractQRCodeText && self.extractQRCodeText.length > 0) {
        [tmpArr addObject:self.extractQRCodeText];
    } else {
        tExtractTxt = @"Extract QR Code";
        [tmpArr addObject:tExtractTxt];
    }
    
    NSString *tSaveImg = [[NSString alloc] init];
    if (self.saveImaegText && self.saveImaegText.length > 0) {
        [tmpArr addObject:self.saveImaegText];
    } else {
        tSaveImg = @"Save Image";
        [tmpArr addObject:tSaveImg];
    }
    
    NSString *tmpCancel = @"Cancel";
    if (self.cancelButton && self.cancelButton.length > 0) {
        tmpCancel = self.cancelButton;
    }
    [[ZRAlertController defaultAlert] actionView:self.lastController title:nil cancel:tmpCancel others:tmpArr handler:^(int index, NSString * _Nonnull item) {
        if ((tExtractTxt.length > 0 || self.extractQRCodeText.length > 0) &&
            ([tExtractTxt isEqualToString:item] || [self.extractQRCodeText isEqualToString:item])) {
            UIImage *image = [self screenShotImageByView:self.lastController.view];
            [self detectQRCodeFromImage:image];
        } else if ((tSaveImg.length > 0 || self.saveImaegText.length > 0) &&
                   ([tSaveImg isEqualToString:item] || [self.saveImaegText isEqualToString:item])) {
            UIImage *image = [self screenShotImageByView:self.lastController.view];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }

        if (actionSheetCompletion) {
            actionSheetCompletion(index, item);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.配置头部和底部
    [self configMenus];
    
    //2.配置摄像头
    [self configDevice];
    
    //3.配置扫描图片
    [self configScanPic];
}

#pragma mark - UIImagePickerControllerDelegate event
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[self.lastController.childViewControllers lastObject] removeFromParentViewController];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self detectQRCodeFromImage:image];
}

#pragma mark - 1.配置头部和底部
- (void)configMenus
{
    //头部
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScanMenuHeight + 10)];
    [topView setBackgroundColor:[UIColor blackColor]];
    topView.alpha = 0.5;
    [self.view addSubview:topView];
    
    CGFloat titleW = 200;
    CGFloat titleH = 30;
    CGFloat titleY = 20;
    CGFloat titleX = (self.view.frame.size.width - titleW) / 2;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
    [title setTextAlignment:NSTextAlignmentCenter];
    if (self.qrCodeNavigationTitle && self.qrCodeNavigationTitle.length > 0) {
        title.text = self.qrCodeNavigationTitle;
    } else {
        title.text = @"QR Code Scanning";
    }
    
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    
    //关闭按钮
    CGFloat btnW = 25;
    CGFloat btnH = 20;
    CGFloat btnX = 10;
    CGFloat btnY = 23;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ZR_Backward"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeQRCodeScan) forControlEvents:UIControlEventTouchUpInside];
    [backBtn.imageView setTintColor:[UIColor whiteColor]];
    [backBtn setTintColor:[UIColor whiteColor]];
    [self.view addSubview:backBtn];
    
    //底部
    CGFloat bottomY = self.view.frame.size.height - ScanMenuHeight;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, self.view.frame.size.width, ScanMenuHeight)];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    bottomView.alpha = 0.5;
    [self.view addSubview:bottomView];
    
    //开灯
    CGFloat openW = 28;
    CGFloat openH = 28;
    CGFloat openX = 11;
    CGFloat openY = 8;
    UIButton *openlight = [[UIButton alloc] initWithFrame:CGRectMake(openX, openY, openW, openH)];
    [openlight setBackgroundImage:[UIImage imageNamed:@"ZR_qrcode_torch_btn"] forState:UIControlStateNormal];
    [openlight setBackgroundImage:[UIImage imageNamed:@"ZR_qrcode_torch_btn_selected"] forState:UIControlStateSelected];
    [openlight addTarget:self action:@selector(torchOnOrOff) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:openlight];
    torchBtn = openlight;
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    [tipsLabel setText:@"Alignment"];
    [tipsLabel setTextColor:[UIColor whiteColor]];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLabel];
    tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //宽度    给自己添加
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width - 50];
    [tipsLabel addConstraint:width];
    
    //高度    给自己添加
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100];
    [tipsLabel addConstraint:height];
    
    //X值     添加到父容器
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.view addConstraint:centerX];
    
    //Y值     添加到父容器
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:tipsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self.view addConstraint:centerY];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - 2.配置摄像头
- (void)configDevice
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(device){
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [session addInput:input];
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        layer.videoGravity = AVLayerVideoGravityResize;
        layer.frame = self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        
        //Capture Area
        CGRect rect = self.view.frame;
        int width = rect.size.width * 0.65;
        rect.origin.x = (rect.size.width - width) / 2;
        rect.origin.y = (rect.size.height - width) / 2;
        rect.size.height = width;
        rect.size.width = width;
        self.captureRectArea = rect;
        
        CGFloat screenHeight = self.view.frame.size.height;
        CGFloat screenWidth = self.view.frame.size.width;
        [output setRectOfInterest:CGRectMake(rect.origin.x / screenWidth, rect.origin.y / screenHeight, rect.size.width / screenWidth, rect.size.height / screenHeight)];
        
        //开始捕获
        [session startRunning];
        
        //开始动画扫描
        [self scanningTimer];
    }
}

#pragma mark - 3.配置扫描图片
- (void)configScanPic
{
    //添加扫描图片
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[self stretchImage:@"ZR_ScanFrame"]];
    imgView.frame = self.captureRectArea; 
    [self.view addSubview:imgView];
    self.scanImage0 = imgView;
    
    //添加扫描的扫描条
    CGRect sImgRect = CGRectMake(10, 5, self.captureRectArea.size.width - 20, 10);
    UIImageView *scanImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ZR_ScanLine"]];
    scanImg.frame = sImgRect;
    [imgView addSubview:scanImg];
    self.scanImage1 = scanImg;
}

#pragma mark - 扫描定时器
- (void)scanningTimer
{
    if(!self.scanTimer){
        self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scanning) userInfo:nil repeats:YES];
    }
}
- (void)scanning
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = self.scanImage0.frame;
        CGRect rect1 = self.scanImage1.frame;
        rect1.origin.y = rect.size.height - rect1.size.height * 2;
        self.scanImage1.frame = rect1;
    } completion:^(BOOL finished) {
        if(finished){
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect = self.scanImage1.frame;
                rect.origin.y = 5;
                self.scanImage1.frame = rect;
            }];
        }
    }];
}

#pragma mark 停止扫描
- (void)stopScanning
{
    [self.scanTimer invalidate];
    self.scanTimer = nil;
}

#pragma mark 关闭扫描
- (void)closeQRCodeScan
{
    [session stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 开灯与关灯
- (void)torchOnOrOff
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (device.torchMode == AVCaptureTorchModeOff) {
        [device setTorchMode: AVCaptureTorchModeOn];
        [torchBtn setSelected:YES];
    }else{
        [device setTorchMode: AVCaptureTorchModeOff];
        [torchBtn setSelected:NO];
    }
    [device unlockForConfiguration];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        NSString *svalue = metadataObject.stringValue;
        if (recognizeCompletion) {
            recognizeCompletion(svalue);
        }
        if (self.scanType == ZRQRCodeScanTypeReturn) {
            [session stopRunning];
            [self stopScanning];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (UIImage *)stretchImage:(NSString *)imgPath
{
    UIImage *img = [UIImage imageNamed:imgPath];
    return [img stretchableImageWithLeftCapWidth:img.size.width * 0.5f topCapHeight:img.size.height * 0.5f];
}

- (UIImage *)screenShotImageByView:(UIView *)view
{
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)detectQRCodeFromImage:(UIImage *)image
{
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *strValue = feature.messageString;
        if (recognizeCompletion) {
            recognizeCompletion(strValue);
        }
    }
}

- (void)dealloc{
    [self stopScanning];

    if (recognizeCompletion) {
        recognizeCompletion = nil;
    }
    
    if (actionSheetCompletion) {
        actionSheetCompletion = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"ZRQRCodeController have received memory warning, so program kill this controller immediately.");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end


