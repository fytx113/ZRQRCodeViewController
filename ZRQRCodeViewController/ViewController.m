//
//  ViewController.m
//  ZRQRCodeViewController
//
//  Created by Victor John on 7/1/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//

#import "ViewController.h"
#import "ZRQRCodeViewController.h"
#import "ZRAlertController.h"

@interface ViewController ()
- (IBAction)scanningQRCode1:(UIButton *)sender;
- (IBAction)scanningQRCode:(UIButton *)sender;
- (IBAction)recognizationByPhotoLibrary:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewExample;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
