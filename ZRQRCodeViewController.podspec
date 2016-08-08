Pod::Spec.new do |spec|
spec.name         = 'ZRQRCodeViewController'
spec.version      = '2.7.2'
spec.license      = 'MIT'
spec.homepage     = 'https://github.com/VictorZhang2014/ZRQRCodeViewController'
spec.author       = { 'Victor Zhang' => 'victorzhangq@gmail.com' }
spec.summary      = 'A delightful QR Code Scanning framework that being compatible with iOS 7.0 and later.'
spec.source       = { :git => 'https://github.com/VictorZhang2014/ZRQRCodeViewController.git', :tag => spec.version }
spec.requires_arc = true
spec.platform = :ios
spec.ios.deployment_target = '7.0'

spec.public_header_files = 'Classes/*.{h}'
spec.source_files = 'Classes/*.{h,m}'
spec.resource = 'Classes/ZRQRCode.bundle'
spec.frameworks    = 'UIKit', 'WebKit','AVFoundation','AudioToolbox'
end
