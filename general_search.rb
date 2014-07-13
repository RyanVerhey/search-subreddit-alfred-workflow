require 'net/http'
require 'uri'
require 'json'
require_relative 'alfred_helper'

query = ARGV.first.strip

default_url = "http://www.reddit.com"
query_url = URI.parse(default_url + "/search.json?q=" + query)
