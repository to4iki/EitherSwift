Pod::Spec.new do |s|
  s.name = "EitherSwift"
  s.version = "0.0.2"
  s.license = "MIT"
  s.summary = "Swift Either type like scala.util.Either"
  s.homepage = "https://github.com/to4iki/EitherSwift"
  s.social_media_url = 'http://twitter.com/to4iki'
  s.author = { "tsk takezawa" => "tsk.take815@gmail.com" }
  s.source  = { :git => "https://github.com/to4iki/EitherSwift.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files  = 'EitherSwift/**/*.swift'

  s.requires_arc = 'true'
end
