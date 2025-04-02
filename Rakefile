# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/extensiontask"
require "rspec/core/rake_task"
require "rubocop/rake_task"

CLEAN.include ".rspec_status", "coverage", "lib/ioprio/ioprio.bundle", "lib/ioprio/ioprio.so", "pkg", "tmp"
Rake::ExtensionTask.new("ioprio", Gem::Specification.load("ioprio.gemspec")) do |ext|
  ext.lib_dir = "lib/ioprio"
end
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc ""
task build: :compile

task default: %i[clobber rubocop spec]

desc ""
task spec: :build
