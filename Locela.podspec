#
#  Be sure to run `pod spec lint Locela.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Locela"
  s.version      = "0.0.1"
  s.summary      = "A new approach to localization."
  s.homepage     = "https://github.com/stevenreinisch/locela-api-ios"
  s.description  = <<-DESC
                   An implementation of the [locela-api-java](https://github.com/echocat/locela-api-java) for iOS.
                   DESC

  s.license      = "MPL 2.0"

  s.author       = { "Steven Reinisch" => "steven.reinisch@teufel.de" }

  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/stevenreinisch/locela-api-ios.git", :tag => "0.0.1" }

  s.source_files  = "Locela/Locela/**/*.{h,m}"
  
  s.requires_arc = true
  
  s.dependency "BNFParser", "~> 1.0"

end
