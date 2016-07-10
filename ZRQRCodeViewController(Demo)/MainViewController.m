//
//  ViewController.m
//  ZRQRCodeViewController(Demo)
//
//  Created by Victor John on 7/3/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//

#import "MainViewController.h"
#import <ZRAlertController.h>
#import <ZRQRCodeViewController/ZRQRCodeViewController.h>

@interface MainViewController ()
- (IBAction)QRCodeScanning1:(UIButton *)sender;
- (IBAction)QRCodeScanning2:(UIButton *)sender;
- (IBAction)recognizationByPhotoLibrary:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIImageView *qrcodePicture;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"QR Code";
    
    [self recognizeByPhotoLib];
}

- (void)recognizeByPhotoLib
{
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeReturn];
    qrCode.cancelButton = @"Cancel";
    qrCode.actionSheets = @[];
    qrCode.extractQRCodeText = @"Extract QR Code";
    NSString *savedImageText = @"Save Image";
    qrCode.saveImaegText = savedImageText;
    [qrCode extractQRCodeByLongPressViewController:self Object:self.qrcodePicture actionSheetCompletion:^(int index, NSString * _Nonnull value) {
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


- (IBAction)QRCodeScanning1:(UIButton *)sender {
    
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

- (IBAction)QRCodeScanning2:(UIButton *)sender {
    
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
@end
