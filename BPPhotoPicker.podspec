Pod::Spec.new do |s|
  s.name = 'BPPhotoPicker'
  s.module_name = 'BPPhotoPicker'
  s.version = '0.0.3'
  s.license = { :type => 'MIT License' }
  s.homepage = 'https://github.com/PH9/BPPhotoPicker'
  s.authors = { 'Wasith Theerapattrathamrong' => 'wastiht.@gmail.com' }
  s.summary = 'Just a native Photo Picker, and native camera caller'
  s.source = { :git => 'https://github.com/PH9/BPPhotoPicker.git', :tag => s.version }
  s.swift_version = '5.2.4'

  s.ios.deployment_target  = '8.0'

  s.source_files = "BPPhotoPicker/PickingMethodController.swift"

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = [
      'BPPhotoPicker/PickingMethodControllerTests.swift',
      'BPPhotoPicker/PickingMethodControllerSpy.swift'
    ]
  end  
end
