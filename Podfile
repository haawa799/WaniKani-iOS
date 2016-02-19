source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
inhibit_all_warnings!

platform :ios, '8.0'

link_with 'WaniKani'

def shared_pods
  pod 'RealmSwift'
end

target 'WaniKani' do
  shared_pods
  pod 'Alamofire', '~> 2.0'
  pod 'PermissionScope'
  pod 'NJKScrollFullScreen'
  pod 'GCHelper', '~> 0.2'
  pod 'UICKeyChainStore'
  pod 'RESideMenu'
  pod 'ACEDrawingView'
  pod 'UIImageView-PlayGIF'
  
  #my pods
  pod "StrokeDrawingView", :git => 'https://github.com/haawa799/StrokeDrawingView.git', :branch => 'master'
  pod "KanjiBezierPaths", :git => 'https://github.com/haawa799/KanjiBezierPaths.git', :branch => 'master'
  pod 'WaniKit', :git => 'https://github.com/haawa799/WaniKit.git', :branch => 'master'
end

# target 'WaniTimie Extension' do
#  	shared_pods
# end