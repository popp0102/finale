require_relative "lib/finale/version"

Gem::Specification.new do |spec|
  spec.name          = "finale"
  spec.version       = Finale::VERSION
  spec.authors       = ["Jason Poppler"]
  spec.email         = ["popp0102@getnotion.com"]

  spec.summary       = 'A client to interact with the Finale Inventory System.'
  spec.homepage      = "https://github.com/popp0102/finale"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.files         = Dir['CHANGELOG.md', 'README.md', 'LICENSE', 'lib/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json", "~> 1.8"
  spec.add_runtime_dependency "rest-client", "~> 2.0"
  spec.add_runtime_dependency "activesupport", "~> 4.2"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "webmock", "~> 3.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'pry-byebug', '~> 3'
  spec.add_development_dependency "factory_bot", "~> 4.10"
  spec.add_development_dependency "simplecov", "~> 0.16"
end
