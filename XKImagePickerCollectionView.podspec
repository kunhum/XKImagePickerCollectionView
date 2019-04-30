#
# Be sure to run `pod lib lint XKImagePickerCollectionView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XKImagePickerCollectionView'
  s.version          = '1.1.2'
  s.summary          = 'XKImagePickerCollectionView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'TZImagePickerController封装的选图片视图'

  s.homepage         = 'https://github.com/kunhum/XKImagePickerCollectionView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kunhum' => 'kunhum@163.com' }
  s.source           = { :git => 'https://github.com/kunhum/XKImagePickerCollectionView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'XKImagePickerCollectionView/Classes/XKImagePickerCollectionView/*.{h,m}'
  s.resource = 'XKImagePickerCollectionView/Classes/XKImagePickerCollectionView/*.{xib}'
  
  # s.resource_bundles = {
  #   'XKImagePickerCollectionView' => ['XKImagePickerCollectionView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'TZImagePickerController'
  s.dependency 'IQKeyboardManager'
  s.dependency 'SDWebImage'
end
