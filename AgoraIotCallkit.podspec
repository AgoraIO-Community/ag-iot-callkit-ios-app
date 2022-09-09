#
# Be sure to run `pod lib lint AgoraIotSdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AgoraIotCallkit'
  s.version          = '1.1.0.1'
  s.summary          = 'AgoraIotCallkit for iot development.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/AgoraIO-Community/ag-iot-callkit-ios-app.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'goooon' => 'support@agora.io' }
  s.source           = { :git => 'git@github.com:AgoraIO-Community/ag-iot-callkit-ios-app.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64, arm64e' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 arm64e x86_64 i386' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 arm64e x86_64 i386' }

#  s.xcconfig = { "USER_HEADER_SEARCH_PATHS" => "$(PODS_ROOT)" }
#  s.xcconfig = { 'USER_HEADER_SEARCH_PATHS' => '"${PODS_ROOT}"' }
  s.ios.deployment_target = '10.0'
  s.public_header_files = "AgoraIotCallkit-Swift.h"
  s.source_files = 'AgoraIotCallkit/Source/**/*.{swift,h,m}'
  s.swift_version = '5.5.6'
  
  # s.resource_bundles = {
  #   'AgoraIotSdk' => ['IotCallkit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Alamofire','5.6.0'
  s.dependency 'AWSMobileClient','2.27.6'
  s.dependency 'AWSIoT','2.27.6'
  s.dependency 'EMPush'
  s.dependency 'AgoraRtcEngine_iOS', '4.0.0-rc.1'
end

