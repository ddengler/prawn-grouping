require "bundler/gem_tasks"

desc "Run a console with the gem loaded"
task :console do
  require 'irb'
  require 'irb/completion'
  require_relative 'lib/prawn/grouping'

  ARGV.clear
  IRB.start
end