require_relative "lib/ioprio/version"

Gem::Specification.new do |spec|
  spec.name = "ioprio"
  spec.version = Ioprio::VERSION
  spec.authors = ["benmelz"]
  spec.email = ["ben@melz.me"]

  spec.summary = "A simple ruby API for the linux ioprio system."
  spec.homepage = "https://github.com/benmelz/ioprio"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"

  spec.files = Dir[
    "lib/**/*.rb", "ext/**/*", "sig/**/*", "Cargo.lock", "Cargo.toml", "CHANGELOG.md", "LICENSE.md", "README.md"
  ]
  spec.require_paths = ["lib"]
  spec.extensions = ["ext/ioprio/Cargo.toml"]

  spec.metadata["rubygems_mfa_required"] = "true"
end
