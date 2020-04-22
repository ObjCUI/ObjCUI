#
#  Be sure to run `pod spec lint ObjCUI.podspec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name = "ObjCUI"
  s.version = "0.0.1"
  s.summary = 'Objective-C declarative UI framework'
  s.homepage = 'https://github.com/ObjCUI/ObjCUI'
  s.author = { "stephenwzl" => "stephenwzlwork@gmail.com" }
  s.platform = :ios, "9.0"
  s.source = { :git => "https://github.com/ObjCUI/ObjCUI.git", :tag => s.version.to_s}

  s.subspec 'core' do |core|
    core.source_files = 'core/**/*.{h,m}'
  end

  s.subspec 'addons' do |addons|
    addons.source_files = 'addons/**/*.{h.m}'
    addons.dependency 'ObjCUI/core'
  end

  s.default_subspec = 'core'

  s.dependency 'YogaKit'

  s.description  = <<-DESC
  Objective-C declarative / data-driven UI framework
                   DESC


  s.license      = "MIT"

end
