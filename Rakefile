# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "rake/extensiontask"

desc ""
task build: :compile

desc ""
task spec: :build

GEMSPEC = Gem::Specification.load("ioprio.gemspec")

Rake::ExtensionTask.new("ioprio", GEMSPEC) do |ext|
  ext.lib_dir = "lib/ioprio"
end

task default: %i[clobber rubocop spec]
