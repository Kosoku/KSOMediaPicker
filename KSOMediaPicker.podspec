#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSOMediaPicker'
  s.version          = '1.4.5'
  s.summary          = 'KSOMediaPicker is an iOS/tvOS framework that provides UI to access the Photos framework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
KSOMediaPicker is an iOS/tvOS framework that provides UI to access the Photos framework. It provides similar functionality to UIImagePickerController on iOS and a custom implementation on tvOS. On iOS it uses FLAnimatedImage to support playback of GIFs within the asset collection view. It also supports playback of video assets while selected in the asset collection view.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/KSOMediaPicker'
  s.screenshots      = ['https://github.com/Kosoku/KSOMediaPicker/raw/master/screenshots/iOS-1.png','https://github.com/Kosoku/KSOMediaPicker/raw/master/screenshots/iOS-2.png','https://github.com/Kosoku/KSOMediaPicker/raw/master/screenshots/iOS-3.png']
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/KSOMediaPicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.source_files = 'KSOMediaPicker/**/*.{h,m}'
  s.exclude_files = 'KSOMediaPicker/KSOMediaPicker-Info.h'
  s.private_header_files = 'KSOMediaPicker/Private/*.h'
  
  s.ios.resource_bundles = {
    'KSOMediaPicker' => ['KSOMediaPicker/**/*.{xib,lproj}']
  }
  s.tvos.resource_bundles = {
    'KSOMediaPicker' => ['KSOMediaPicker/**/*.{lproj}']
  }

  s.frameworks = 'Photos', 'AVFoundation'
  
  s.dependency 'Agamotto'
  s.dependency 'Ditko'
  s.dependency 'Quicksilver'
  s.dependency 'Shield/Photos'
  s.dependency 'KSOFontAwesomeExtensions'
  s.ios.dependency 'FLAnimatedImage', '~> 1.0'
end
