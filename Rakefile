# frozen_string_literal: false
# require 'bundler/gem_tasks'
require 'rake/testtask'

# Rake task to run all tests
Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/test_*.rb']
end
desc 'Run tests'

task default: :test
