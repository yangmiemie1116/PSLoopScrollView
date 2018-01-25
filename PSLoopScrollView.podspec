Pod::Spec.new do |s|
  s.name         = "PSLoopScrollView"
  s.version      = "0.0.7"
  s.summary      = "loop scrollview"
  s.description  = <<-DESC
                   loop scrollview
                   DESC
  s.homepage     = "https://github.com/yangmiemie1116/PSLoopScrollView.git"
  s.license      = "MIT"
  s.author             = { "杨志强" => "yangzhiqiang116@gmail.com" }
  s.social_media_url   = "http://www.jianshu.com/u/bd06a732c598"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/yangmiemie1116/PSLoopScrollView.git", :tag => "#{s.version}" }
  s.source_files = "PSLoopScrollView/*.{swift}"
  s.requires_arc = true
  s.dependency 'Kingfisher', '~> 4.0'
end
