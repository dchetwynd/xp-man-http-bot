require 'rspec/core/rake_task'

task :default => %w(test)

task :test => ['test:all']

namespace :test do
  desc 'All tests'
  RSpec::Core::RakeTask.new(:all) do |t|
    t.pattern = Dir.glob('spec/*.rb')
  end
end
