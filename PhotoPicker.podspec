Pod::Spec.new do |s|
  s.name = 'PhotoPicker'
  s.version = '0.0.1'
  s.license = { :type => 'MIT License' }
  s.homepage = 'https://github.com/PH9/BPPhotoPicker'
  s.authors = { 'Wasith Theerapattrathamrong' => 'wastiht.@gmail.com' }
  s.summary = 'Just a native Photo Picker, and native camera caller'
  s.source = { :git => 'https://github.com/PH9/BPPhotoPicker.git', :tag => s.version }
  s.swift_version = '5.2.4'

  s.ios.deployment_target  = '10.0'

  s.source_files = "PhotoPicker/PickingMethodController.swift"

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'PhotoPicker/PickingMethodControllerTests.swift'
  end  
end