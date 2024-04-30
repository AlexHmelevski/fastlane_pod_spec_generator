lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/pod_spec_generator/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-pod_spec_generator'
  spec.version       = Fastlane::PodSpecGenerator::VERSION
  spec.author        = 'Alex Crowe'
  spec.email         = 'alexei.hmelevski@gmail.com'

  spec.summary       = 'Generate a simple pod spec for CI automation'
  spec.homepage      = "https://github.com/Swift-Gurus/fastlane_pod_spec_generator"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 3.0'
  spec.add_dependency('cocoapods')
end
