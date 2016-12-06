Pod::Spec.new do |spec|
  spec.name = "Drift-SDK"
  spec.version = "1.0.0"
  spec.summary = "Drift Framework for customer communication"
  spec.homepage = "https://github.com/Driftt/drift-sdk-ios"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Eoin O'Connell" => 'eoin@8bytes.ie' }
  spec.social_media_url = "http://twitter.com/drift"

  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/Driftt/drift-sdk-ios.git", tag: "#{spec.version}", submodules: false }
  spec.source_files = "Drift/**/*.{h,swift}"
  spec.resources = ['Drift/**/*.xib','Drift/**/*.xcassets']

  spec.dependency 'LayerKit', '~> 0.17'
  spec.dependency 'ObjectMapper', '~> 2.0'
  spec.dependency 'SlackTextViewController', '~> 1.9.3'
  spec.dependency 'AlamofireImage', '~> 3.0'
  spec.dependency 'SVProgressHUD', '~> 2.0'

end