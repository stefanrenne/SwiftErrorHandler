Pod::Spec.new do |spec|
  spec.name                   = 'SwiftErrorHandler'
  spec.version                = '5.0.0'
  spec.license                = { :type => 'Apache-2.0' }
  spec.homepage               = 'https://github.com/stefanrenne/SwiftErrorHandler'
  spec.authors                = { 'Stefan Renne' => 'info@stefanrenne.nl' }
  spec.summary                = 'Flexible library for handling Swift Errors'
  spec.source                 = { :git => 'https://github.com/stefanrenne/SwiftErrorHandler.git', :tag => spec.version.to_s }
  spec.swift_version          = '5.0'
  spec.ios.deployment_target  = '8.0'
  spec.tvos.deployment_target = '9.0'
  spec.requires_arc           = true
  spec.source_files           = 'Sources/**/*.swift'
  spec.ios.framework          = 'UIKit'
  spec.tvos.framework         = 'UIKit'
end
