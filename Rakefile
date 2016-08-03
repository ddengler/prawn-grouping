require "bundler/gem_tasks"
require "rspec/core/rake_task"

task default: [:spec]

desc "Run all rspec files"
RSpec::Core::RakeTask.new("spec") do |c|
  c.rspec_opts = "-t ~unresolved"
end

desc "Run a console with the gem loaded"
task :console do
  require "irb"
  require "irb/completion"
  require_relative "lib/prawn/grouping"

  ARGV.clear
  IRB.start
end
