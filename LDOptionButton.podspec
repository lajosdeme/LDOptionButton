#
#  Be sure to run `pod spec lint LDOptionButton.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "LDOptionButton"
  spec.version      = "0.1.0"
  spec.summary      = "Clean and beautiful menu option button written in Swift."

  # This description is used to generate tags and improve search results.
  spec.description  = "Clean and beautiful menu option button written in Swift."

  spec.homepage     = "https://github.com/lajosdeme/LDOptionButton"
  spec.screenshots  = "https://user-images.githubusercontent.com/44027725/113474138-521edd80-946e-11eb-90dc-86a3dd105b4e.gif", "https://user-images.githubusercontent.com/44027725/113474170-8c887a80-946e-11eb-9201-36040a7e246b.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author             = { "lajosdeme" => "lajosd@protonmail.ch" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios, "14.2"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://github.com/lajosdeme/LDOptionButton.git", :tag => "#{spec.version}" }
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source_files  = "LDOptionButton/**/*.{h,m}"
end
