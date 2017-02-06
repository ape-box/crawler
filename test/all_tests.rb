require "minitest/autorun"

# where are we ?
root = ::File.expand_path('../../', __FILE__)

# load source files
Dir.glob("#{root}/src/**/*.rb") {|f| require(f)}

# load test files
Dir.glob("#{root}/test/**/*_test.rb") {|f| require(f)}

# load mock files
Dir.glob("#{root}/test/**/*_mock.rb") {|f| require(f)}
