# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
inhibit_all_warnings!
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

def shared_pods
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxAlamofire', '~> 5.0'
    
    pod 'RealmSwift', '~> 5.0'
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireImage', '~> 3.0'
    pod 'SwiftyJSON'
    pod 'ISO8601'
end

target 'SMV-iper' do
    shared_pods
    
    pod 'SwiftLint', '0.40.0'
    pod 'SwiftGen', '6.4.0'
    pod 'SDWebImage', '~> 5.0'
    pod 'SwiftDate', '6.1.0'
    pod 'SVProgressHUD', '2.2.5'
    pod 'SVPullToRefresh', :git => 'https://github.com/supermnemonic/SVPullToRefresh.git'
    pod 'TPKeyboardAvoiding', '~> 1.0'
    pod 'ActionSheetPicker-3.0', '~> 2.0'
    pod 'DZNEmptyDataSet', :git => 'https://github.com/supermnemonic/DZNEmptyDataSet.git'
    pod 'Popover'
    pod 'KeychainSwift'
    
    # Pods for SMV-iper
    
end

target 'SMV-iperTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'SwiftDate', '6.1.0'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
end
