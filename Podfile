# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!

def commons_libraries
  pod 'SwiftLint', :inhibit_warnings => true
end

target 'PicsumPreview' do
  # Pods for PicsumPreview
  commons_libraries
  pod 'Kingfisher', :inhibit_warnings => true
  pod 'lottie-ios', :inhibit_warnings => true
  
  target 'PicsumPreviewTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
