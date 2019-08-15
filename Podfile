# Uncomment the next line to define a global platform for your project
workspace 'DigitalCurrency'

xcodeproj 'DigitalCurrency/DigitalCurrency.xcodeproj'
xcodeproj 'KKPrivateLib/KKPrivateLib.xcodeproj'

target 'DigitalCurrency' do
  platform :ios, '8.0'

  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  pod 'Masonry'
  pod 'MJRefresh'
  pod 'SDWebImage'
  pod 'YYKit'
  pod 'MBProgressHUD'
  pod 'AFNetworking'
  pod 'DZNEmptyDataSet'
  pod 'pop'
  pod 'UITableView+FDTemplateLayoutCell'
  pod 'DateTools'
  pod 'ReactiveObjC'
  pod 'Aspects'
  pod 'MZTimerLabel'
  pod 'iCarousel'
  pod 'SMPageControl'
# 任务
  pod 'Bolts'
# UI优化
  pod 'Texture'
# 日志
  pod 'CocoaLumberjack'
  
  pod 'UMCCommon'
  pod 'UMCSecurityPlugins'
  pod 'UMCAnalytics'
  pod 'UMCCommonLog'
  # Pods for DigitalCurrency

  target 'DigitalCurrencyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DigitalCurrencyUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  xcodeproj './DigitalCurrency.xcodeproj'
end

target 'KKPrivateLib' do
    platform :ios, '8.0'
    pod 'AFNetworking'
    pod 'Bolts'
    pod 'MBProgressHUD'
    pod 'YYKit'
    pod 'ReactiveObjC'
    pod 'Aspects'
    xcodeproj './KKPrivateLib/KKPrivateLib.xcodeproj'
end
