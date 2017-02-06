#!/usr/bin/env ruby
require 'json'

root = ::File.expand_path('../', __FILE__)
Dir.glob("#{root}/src/**/*.rb").each {|f| require(f)}

crawler = WebsiteCrawler.new ARGV.first
map = crawler.get_pages_and_assets
puts map.to_json
