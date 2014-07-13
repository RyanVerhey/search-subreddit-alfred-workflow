require 'net/http'
require 'uri'
require 'json'
require_relative 'alfred_helper'

query = ARGV.first.strip

default_url = "http://www.reddit.com"
query_url = URI.parse(default_url + "/search.json?q=author%3A" + query)

resp = Net::HTTP.get_response(query_url)
resp = JSON.parse(resp.body)
posts = resp["data"]["children"]

xml = Alfred::Workflow.new

if posts.first == nil
  invalid = Alfred::Item.new({
    valid: "no",
    title: "Invalid user or user hasn't posted anything",
    subtitle: "This isn't a valid username or they haven't posted." })
  xml << invalid
else
  posts.each do |post|
    data = post["data"]
    new_post = Alfred::Item.new({
      arg: default_url + data["permalink"],
      autocomplete: data["title"],
      title: data["title"],
      subtitle: "Sub: #{data['subreddit']} | Score: #{data['score']} | Comments: #{data['num_comments']} | Domain: #{data['domain']}" })
    xml << new_post
  end
end

puts xml
