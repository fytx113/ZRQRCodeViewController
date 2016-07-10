//
//  ZRAudio.m
//  ZRQRCodeViewController
//
//  Created by Victor John on 7/9/16.
//  Copyright © 2016 XiaoRuiGeGe. All rights reserved.
//
//  https://github.com/VictorZhang2014/ZRQRCodeViewController
//  An open source library for iOS in Objective-C that is being compatible with iOS 7.0 and later.
//  Its main function that QR Code Scanning framework that are easier to call.
//

#import "ZRAudio.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation ZRAudio

- (SystemSoundID)getDictSystemSoundID:(NSString **)soundName
{
    NSString *filename = @"ZR_Scan_Success";
    if (soundName != NULL && !soundName)
        *soundName = filename;
    NSDictionary *soundDictionary = [[NSDictionary alloc] init];
    SystemSoundID soundID = [soundDictionary[filename] unsignedIntValue];
    return soundID;
}

- (void)playSoundWhenScanSuccess
{
    NSString *soundName = [[NSString alloc] init];
    SystemSoundID soundID = [self getDictSystemSoundID:&soundName];
    if(!soundID){
        NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:@".caf"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        AudioServicesPlayAlertSound(soundID);
    }
}

- (void)disposeSound
{
    SystemSoundID soundID = [self getDictSystemSoundID:nil];
    if(soundID){
        AudioServicesDisposeSystemSoundID(soundID);
    }
}

@end
