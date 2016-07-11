Pod::Spec.new do |spec|
spec.name         = 'ZRQRCodeViewController'
spec.version      = '2.2'
spec.license      = "MIT"
spec.homepage     = 'https://github.com/VictorZhang2014/ZRQRCodeViewController.git'
spec.author       = { "Victor Zhang" => "victorzhangq@gmail.com" }
spec.summary      = 'A delightful QR Code Scanning framework that being compatible with iOS 7.0 and later.'
spec.source       = { :git => 'https://github.com/VictorZhang2014/ZRQRCodeViewController.git', :tag => spec.version.to_s }
spec.platform = :ios
spec.source_files = 'Classes/*.{h,m}'
spec.resource = 'Classes/ZRQRCode.bundle'
spec.frameworks    = 'UIKit', 'WebKit'
spec.requires_arc = true
end
