Pod::Spec.new do |s|
  s.name              = "Socialize"
  s.platform          = :ios, '6.1'
  s.version           = "3.0.1"
  s.summary           = "Socialize SDK for iOS devices."
  s.description       = "An iOS social sharing SDK for native apps. Learn more at http://getsocialize.com/"
  s.homepage          = "https://github.com/socialize/socialize-sdk-ios"
  s.documentation_url = 'http://socialize.github.io/socialize-sdk-ios/'
  s.license           = { :type => 'MIT', :file => 'LICENSE' }
  s.author            = { "David Jedeikin" => "djedeikin@sharethis.com" }
  s.source            = { :git => "https://github.com/socialize/socialize-sdk-ios.git", :tag => "3.0.1" }
  s.source_files      = 'Loopy/**/*.{h,m}'
  s.resources         = 'Loopy/Resources/*.png','Loopy/LoopyApiInfo.plist'
  s.requires_arc      = false
 end
