#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSOMediaPicker'
  s.version          = '0.3.0'
  s.summary          = 'KSOMediaPicker is an iOS/tvOS framework that provides UI to access the Photos framework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
KSOMediaPicker is an iOS/tvOS framework that provides UI to access the Photos framework. It provides similar functionality to UIImagePickerController on iOS and a custom implementation on tvOS.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/KSOMediaPicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/KSOMediaPicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.source_files = 'KSOMediaPicker/**/*.{h,m}'
  s.exclude_files = 'KSOMediaPicker/KSOMediaPicker-Info.h'
  s.private_header_files = 'KSOMediaPicker/Private/*.h'
  
  s.resource_bundles = {
    'KSOMediaPicker' => ['KSOMediaPicker/**/*.{xcassets,lproj}']
  }

  s.frameworks = 'Foundation', 'UIKit', 'Photos'
  
  s.dependency 'Agamotto'
  s.dependency 'Ditko'
  s.dependency 'Loki'
  s.dependency 'Stanley'
  s.dependency 'Quicksilver'
  s.dependency 'Shield/Photos'
end
