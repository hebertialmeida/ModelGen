platform :osx, '10.9'
use_frameworks!

def common_pods
  pod 'SwiftGenKit', '~> 2.0.0'
  pod 'PathKit', '~> 0.8.0', :inhibit_warnings => true
  pod 'Stencil', '~> 0.9.0', :inhibit_warnings => true
  pod 'StencilSwiftKit', '~> 2.0.0'
end

target 'modelgen' do
  pod 'Commander', '~> 0.6.0', :inhibit_warnings => true
  common_pods
end
