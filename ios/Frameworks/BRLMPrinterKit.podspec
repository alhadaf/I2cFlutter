Pod::Spec.new do |spec|
  spec.name         = "BRLMPrinterKit"
  spec.version      = "4.6.4"
  spec.summary      = "Brother Label and Mobile Printer SDK"
  spec.description  = "Brother SDK for iOS label and mobile printers with simulator support"
  spec.homepage     = "https://support.brother.com"
  spec.license      = { :type => "Commercial" }
  spec.author       = { "Brother Industries" => "support@brother.com" }
  
  spec.platform     = :ios, '11.0'
  spec.source       = { :path => '.' }
  
  # Use the XCFramework which includes simulator support
  spec.vendored_frameworks = 'BRLMPrinterKit.xcframework'
  
  # Framework dependencies
  spec.frameworks = 'Foundation', 'UIKit', 'CoreBluetooth', 'ExternalAccessory'
  
  # Build settings
  spec.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => '',  # Allow simulator builds
    'VALID_ARCHS[sdk=iphonesimulator*]' => 'arm64 x86_64'
  }
end