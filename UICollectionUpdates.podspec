#
# Be sure to run `pod lib lint UICollectionUpdates.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UICollectionUpdates'
  s.version          = '0.1.2'
  s.summary          = 'Wrapper for UITableView and UICollectionView updates with model-oriented behavior'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  The library provides an ability to send batch updates to UICollectionView/UITableView as a model.
  Suitable for MVVM, MVP, VIPER architectures and others
  
  *Important:* Supports safe batch updates (In case of throw you can perform reloadData())
                       DESC

  s.homepage         = 'https://github.com/konshin/UICollectionUpdates'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'konshin' => 'alexey@konshin.net' }
  s.source           = { :git => 'https://github.com/konshin/UICollectionUpdates.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_versions = '5.1'

  s.source_files = 'UICollectionUpdates/Classes/**/*'
  
   s.frameworks = 'UIKit'
end
