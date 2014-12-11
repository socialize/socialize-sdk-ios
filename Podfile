source 'https://github.com/socialize/SocializeCocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'
inhibit_all_warnings!
xcodeproj 'Socialize.xcodeproj'

link_with 'Socialize'
pod 'Loopy', '1.1.1'
pod 'Facebook-iOS-SDK', '3.20'
pod 'BlocksKit'
pod 'SZOAuthConsumer', :podspec => 'https://raw.github.com/socialize/OAuthConsumer/master/SZOAuthConsumer.podspec'
pod 'SZJSONKit', :podspec => 'https://raw.github.com/socialize/JSONKit/master/SZJSONKit.podspec'
pod 'Pinterest-iOS', '2.3'
pod 'STTwitter', '0.1.4'

target 'UIIntegrationAcceptanceTests', :exclusive => true do
  pod 'KIF', '2.0'
end

target 'UnitTests' , :exclusive => true do
  link_with ['UnitTests', 'IntegrationTests']
  pod 'Socialize', :path => './Socialize.podspec'
end

post_install do | installer |
  #copy resources from Loopy to include in framework
  require 'fileutils'
  FileUtils.cp_r(Dir['Pods/Loopy/Loopy/Resources/*'], 'Socialize/Resources', :remove_destination => true)
  FileUtils.cp_r('Pods/Loopy/Loopy/LoopyApiInfo.plist', 'Socialize/Resources', :remove_destination => true)

  #per http://stackoverflow.com/questions/19875166/ios-7-isa-is-deprecated
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DIRECT_OBJC_ISA_USAGE'] = 'NO'
        if target.name == "Pods-UnitTests-Socialize" then
            config.build_settings['GCC_GENERATE_TEST_COVERAGE_FILES'] = 'YES'
            config.build_settings['GCC_INSTRUMENT_PROGRAM_FLOW_ARCS'] = 'YES'
        end
    end
  end
end
