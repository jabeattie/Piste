# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Piste' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Piste
  pod 'Fuse'
  pod 'SwiftGen'
  pod 'ReactiveSwift'
  pod 'ReactiveCocoa'
  pod 'RealmSwift'
  pod 'JLSwiftRouter', :git => 'https://github.com/skyline75489/SwiftRouter.git', :tag => '2.0.0'


  target 'PisteTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PisteUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = 3.2
        end
    end
end
