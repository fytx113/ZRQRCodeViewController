//
//  ZRQRCodeViewController.h
//  ZRQRCodeViewController
//
//  Created by Victor John on 7/1/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//
//  https://github.com/VictorZhang2014/ZRQRCodeViewController
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that QR Code Scanning framework that are easier to call.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlockCompletion)(NSString * strValue);
typedef void(^MyActionSheetCompletion)(int index, NSString * value);

typedef NS_ENUM(NSInteger) {
    ZRQRCodeScanTypeReturn       = 0, // Return a result after scanned and dismiss current controller
    ZRQRCodeScanTypeContinuation = 1  // Return a result after scanned ,but does not dismiss current controller
}ZRQRCodeScanType;

@interface ZRQRCodeViewController : UIViewController

@property (nonatomic, assign) ZRQRCodeScanType scanType;// Default is ZRQRCodeScanTypeReturn

@property (nonatomic, copy) NSString *qrCodeNavigationTitle;

- (instancetype)initWithScanType:(ZRQRCodeScanType)scanType;

@property (nonatomic, assign) BOOL enabledLight;
@property (nonatomic, strong) UIColor *VCTintColor;
- (instancetype)initWithScanType:(ZRQRCodeScanType)scanType customView:(UIView *)customView navigationBarTitle:(NSString *)title;

/*
 * QR Code Scanning immediately
 * @param viewController , is current controller
 * @param completion , it is a callback block with a NSString parameter
 **/
- (void)QRCodeScanningWithViewController:(UIViewController *)viewController completion:(MyBlockCompletion)completion;


@property (nonatomic, copy) NSString *textWhenNotRecognized;
/*
 * Recogize a QR Code picture through the Photo Library
 * @param viewController , is current controller
 * @param completion , it is a callback block with a NSString parameter
 **/
- (void)recognizationByPhotoLibraryViewController:(UIViewController *)viewController completion:(MyBlockCompletion)completion;



@property (nonatomic, strong) NSArray *actionSheets;
@property (nonatomic, copy) NSString *cancelButton;
@property (nonatomic, copy) NSString *extractQRCodeText;
@property (nonatomic, copy) NSString *saveImaegText;
/*
 * Extract QR Code by Long press object , which maybe is UIImageView, UIButton, UIWebView, WKWebView, UIView , all of them , but that's okay for this method to extract.
 * @param viewController , is current controller
 * @param object , it is an object that show an image on any type of object , in which is a two dimensional code picture
 **/
- (void)extractQRCodeByLongPressViewController:(UIViewController *)viewController Object:(id)object completion:(MyBlockCompletion)completion;

/*
 * Extract QR Code by Long press object , which maybe is UIImageView, UIButton, UIWebView, WKWebView, UIView, UIViewController , all of them , but that's okay for this method to extract.
 * @param viewController , is current controller
 * @param actions , is an array for action sheet
 * @param actionSheetsCompletion, is a completion block for action sheet
 * @param object , it is an object that show an image on any type of object , in which is a two dimensional code picture
 **/
- (void)extractQRCodeByLongPressViewController:(UIViewController *)viewController Object:(id)object actionSheetCompletion:(MyActionSheetCompletion)actionSheetsCompletion completion:(MyBlockCompletion)completion;

@end


