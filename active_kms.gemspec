require_relative "lib/active_kms/version"

Gem::Specification.new do |spec|
  spec.name          = "active_kms"
  spec.version       = ActiveKms::VERSION
  spec.summary       = "Simple, secure key management for Active Record encryption"
  spec.homepage      = "https://github.com/ankane/active_kms"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.6"

  spec.add_dependency "activerecord", ">= 7"
end
