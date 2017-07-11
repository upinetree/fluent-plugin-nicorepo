#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'fileutils'
require 'rake/testtask'

task test: [:base_test]

desc 'Run test_unit based test'
Rake::TestTask.new(:base_test) do |t|
  t.libs << "test"
  t.test_files = Dir["test/**/test_*.rb"].sort
  t.verbose = true
  t.warning = false
end

task :default => :test
