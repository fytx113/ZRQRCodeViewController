//
//  ViewController.m
//  ZRQRCodeViewController
//
//  Created by Victor John on 7/1/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//
//  https://github.com/VictorZhang2014/ZRQRCodeViewController
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that QR Code Scanning framework that are easier to call.
//

#import "ViewController.h"
#import "ZRQRCodeController.h"
#import "ZRTmpViewController.h"
#import "ZRQRCodeScanView.h"

@interface ViewController ()
- (IBAction)scanningQRCode1:(UIButton *)sender;
- (IBAction)scanningQRCode:(UIButton *)sender;
- (IBAction)recognizationByPhotoLibrary:(UIButton *)sender;
- (IBAction)scanningQRCodeByCustomView:(id)sender;


@property (nonatomic, strong) ZRTmpViewController *tmpViewController;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewExample;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBasis];
    
    [self recognizationByLongPressImage];

}

- (void)configBasis
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:38.0 / 255.0f green:169.0 / 255.0f blue:28.0f / 255.0f alpha:1];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)recognizationByLongPressImage
{
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeReturn];
    qrCode.cancelButton = @"Cancel";
    qrCode.actionSheets = @[];
    qrCode.extractQRCodeText = @"Extract QR Code";
    NSString *savedImageText = @"Save Image";
    qrCode.saveImaegText = savedImageText;
    [qrCode extractQRCodeByLongPressViewController:self Object:self.imageViewExample actionSheetCompletion:^(int index, NSString * _Nonnull value) {
        if ([value isEqualToString:savedImageText]) {
            [[ZRAlertController defaultAlert] alertShow:self title:@"" message:@"Saved Image Successfully!" okayButton:@"Ok" completion:^{ }];
        }
    } completion:^(NSString * _Nonnull strValue) {
        NSLog(@"strValue = %@ ", strValue);
        [[ZRAlertController defaultAlert] alertShow:self title:@"" message:[NSString stringWithFormat:@"Result: %@", strValue] okayButton:@"Ok" completion:^{
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strValue]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strValue]];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooooops!" message:[NSString stringWithFormat:@"The result is %@", strValue] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    }];
}

- (IBAction)scanningQRCode1:(UIButton *)sender {
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeReturn];
    qrCode.qrCodeNavigationTitle = @"QR Code Scanning";
    [qrCode QRCodeScanningWithViewController:self completion:^(NSString *strValue) {
        NSLog(@"strValue = %@ ", strValue);
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strValue]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strValue]];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooooops!" message:[NSString stringWithFormat:@"The result is %@", strValue] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (IBAction)scanningQRCode:(UIButton *)sender {
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeContinuation];
    [qrCode QRCodeScanningWithViewController:self completion:^(NSString *strValue) {
        NSLog(@"strValue = %@ ", strValue);
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strValue]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strValue]];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooooops!" message:[NSString stringWithFormat:@"The result is %@", strValue] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}


- (IBAction)recognizationByPhotoLibrary:(UIButton *)sender {
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeReturn];
    qrCode.textWhenNotRecognized = @"No any QR Code texture on the picture were found!";
    [qrCode recognizationByPhotoLibraryViewController:self completion:^(NSString *strValue) {
        NSLog(@"strValue = %@ ", strValue);
        [[ZRAlertController defaultAlert] alertShow:self title:@"" message:[NSString stringWithFormat:@"Result: %@", strValue] okayButton:@"Ok" completion:^{
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strValue]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strValue]];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooooops!" message:[NSString stringWithFormat:@"The result is %@", strValue] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    }];
}

- (IBAction)scanningQRCodeByCustomView:(id)sender {
    [[[ZRQRCodeScanView alloc] init] openQRCodeScan:self];
}



@end
