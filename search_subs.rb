require 'net/http'
require 'uri'
require 'json'
require_relative 'alfred_helper'

query = ARGV.first.strip

query_url = URI.parse("http://www.reddit.com/subreddits/search.json?q=" + query)
default_url = "http://www.reddit.com"

resp = Net::HTTP.get_response(query_url)
resp = JSON.parse(resp.body)
subs = resp["data"]["children"]

xml = Alfred::Workflow.new

if subs.first == nil
  invalid = Alfred::Item.new({
    valid: "no",
    title: "No results yet. Keep Typing...",
    subtitle: "The reddit API is a bit weird. Keep typing and your subreddit should show up." })
  xml << invalid
else
  subs.each do |sub|
    data = sub["data"]
    subreddit = Alfred::Item.new({
      arg: default_url + data["url"],
      autocomplete: data["display_name"],
      title: "#{data['display_name']}#{" (private)" if data["subreddit_type"] == "private" }",
      subtitle: data["public_description"] })
    xml << subreddit
  end
end

puts xml
