Pod::Spec.new do |s|
    s.name          = "sfunctional"
    s.version       = "0.7.0"
    s.summary       = "functional library for swift"
    s.homepage      = "https://github.com/rarnu/sfunctional"
    s.license       = "MIT"
    s.author        = { "rarnu" => "rarnu1985@gmail.com" }
    s.platform      = :ios, "8.0"
    s.source        = { :git => "https://github.com/rarnu/sfunctional.git", :tag => "#{s.version}" }
    s.source_files  = "sfunctional/*.swift", "sfunctional/**/*", "sfunctional/**/**/*"
    s.swift_version = "4.2"
    s.xcconfig = {
        'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++11',
        'CLANG_CXX_LIBRARY' => 'libc++'
    }
end
