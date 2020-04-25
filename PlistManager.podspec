#
# Be sure to run `pod lib lint PlistManager.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'PlistManager'
  s.version          = '1.1.1'
  s.summary          = 'Lightweight plist data management framework, leveraging Codable in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Easily CRUD anything that conforms to Codable to locally stored Plist files, leveraging the latest native Swift features.
                       DESC
  s.homepage         = 'https://github.com/janakmshah/PlistManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Janak Shah' => 'janak.shah@cuvva.com' }
  s.source           = { :git => 'https://github.com/janakmshah/PlistManager.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'PlistManager/Classes/**/*'
  s.frameworks = 'Foundation'
  if s.respond_to? 'swift_version'
    s.swift_version = '5.0'
  end
end
