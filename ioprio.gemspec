# frozen_string_literal: true

require_relative "lib/ioprio/version"

Gem::Specification.new do |spec|
  spec.name = "ioprio"
  spec.version = Ioprio::VERSION
  spec.authors = ["benmelz"]
  spec.email = ["ben@melz.me"]

  spec.summary = "Simple wrappers for linux ioprio syscalls."
  spec.homepage = "https://github.com/benmelz/io_priority"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/v#{Ioprio::VERSION}/CHANGELOG.md" 

  spec.files = Dir['lib/**/*', 'CHANGELOG.md', 'LICENSE.md', 'README.rdoc']
  spec.require_paths = ["lib"]
  spec.extensions = ["ext/ioprio/extconf.rb"]
end
