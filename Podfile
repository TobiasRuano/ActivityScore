# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ActivityScore' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ActivityScore
  pod 'Google-Mobile-Ads-SDK'
  pod 'Charts'
  pod 'SwiftyStoreKit'
  pod 'ProgressHUD'
  pod 'SwiftLint'
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
  end
 end
end