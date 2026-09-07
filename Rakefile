require "bundler/gem_tasks"
require "ioprio/version"
require "rb_sys/extensiontask"
require "rspec/core/rake_task"
require "rubocop/rake_task"

PLATFORMS = %w[
  aarch64-linux-gnu
  aarch64-linux-musl
  arm64-darwin
  x86_64-darwin
  x86_64-linux-gnu
  x86_64-linux-musl
].freeze

CLEAN.include "registry", "tmp"

RbSys::ExtensionTask.new("ioprio", Gem::Specification.load("ioprio.gemspec")) do |ext|
  ext.lib_dir = "lib/ioprio"
  ext.cross_compile = true
  ext.cross_platform = PLATFORMS
end

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new

namespace :build do
  desc "Build ioprio-#{Ioprio::VERSION}-platform.gem into the pkg directory for all supported platforms"
  task :native do
    PLATFORMS.each do |platform|
      sh("bundle", "exec", "rb-sys-dock", "--platform=#{platform}", "--",
         "bundle install && bin/rake native:#{platform} gem")
    end
  end
end

task default: %i[clobber rubocop spec]

desc ""
task spec: :compile
