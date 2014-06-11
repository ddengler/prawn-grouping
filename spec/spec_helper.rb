require "bundler"
Bundler.setup

require "prawn/grouping"

require "pdf/reader"
require "pdf/inspector"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
