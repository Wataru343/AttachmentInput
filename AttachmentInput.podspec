Pod::Spec.new do |s|
  s.name         = "AttachmentInput"
  s.version      = "0.0.4"
  s.swift_version = "5.0.0"
  s.ios.deployment_target = "12.0"
  s.license      = "MIT"
  s.summary      = "AttachmentInput is a photo attachment keyboard."
  s.description  = "You can easily select photos, compress photos and videos, launch UIImagePickerController, and take pictures on the keyboard."
  s.homepage     = "https://github.com/mobile-davinder/AttachmentInput.git"
  s.screenshots  = "https://github.com/mobile-davinder/AttachmentInput/raw/master/AttachmentInput.png"
  s.author       = { "mobile-davinder" => "mobile.davinder.11@gmail.com" }
  s.source       = { :git => "https://github.com/mobile-davinder/AttachmentInput.git", :tag => s.version }
  s.source_files = "AttachmentInput/**/*.{generated.swift,swift}"
  s.resources    = "AttachmentInput/**/*.{xib,xcassets,strings}"
  s.dependency "RxSwift" "5.1.1"
  s.dependency "RxCocoa" "5.1.1"
  s.dependency "RxDataSources" "4.0.1"
end
