# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mail/sanitizer/version"

Gem::Specification.new do |spec|
  spec.name          = "mail-sanitizer"
  spec.version       = Mail::Sanitizer::VERSION
  spec.authors       = ["MasatoMiyoshi"]
  spec.email         = ["miyoshi@sitebridge.co.jp"]

  spec.summary       = %q{A simple sanitizer for mail bodies}
  spec.description   = %q{A simple sanitizer for mail bodies}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end