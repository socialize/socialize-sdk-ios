Pod::Spec.new do |s|
  s.name              = "Socialize"
  s.platform          = :ios, '6.1'
  s.version           = "3.0.6"
  s.summary           = "Socialize SDK for iOS devices."
  s.description       = "An iOS social sharing SDK for native apps. Learn more at http://getsocialize.com/"
  s.homepage          = "https://github.com/socialize/socialize-sdk-ios"
  s.documentation_url = 'http://socialize.github.io/socialize-sdk-ios/'
  s.license           = { :type => 'MIT', :file => 'LICENSE' }
  s.author            = { "David Jedeikin" => "djedeikin@sharethis.com" }
  s.source            = { :git => "https://github.com/socialize/socialize-sdk-ios.git", :tag => "3.0.6" }
  s.dependency        'Loopy'
  s.dependency        'Facebook-iOS-SDK', '~> 3.9.0'
  s.dependency        'SZOAuthConsumer'
  s.dependency        'SZJSONKit'
  s.dependency        'SZBlocksKit'
  s.resources         = 'Socialize/Resources/*.png','Socialize/Resources/*.xib','Socialize/Resources/*.plist'  
  s.subspec 'no-arc' do |ss1|
    ss1.source_files = 'Socialize-noarc/**/*.{h,m}'
    ss1.requires_arc = false
    ss1.compiler_flags = '-fno-objc-arc'
  end
  s.subspec 'arc' do |ss2|
    ss2.source_files = 'Socialize/**/*.{h,m}'
    ss2.dependency 'Socialize/no-arc'
    ss2.requires_arc = true
  end
end
