require 'net/http'
require 'uri'
require 'json'

query = ARGV.first

query_url = URI.parse("http://www.reddit.com/subreddits/search.json?q=" + query)
default_url = "http://www.reddit.com"

resp = Net::HTTP.get_response(query_url)
resp = JSON.parse(resp.body)
subs = resp["data"]["children"]

xml = "<items>"

if query == "reddit"
  xml += "<item arg='#{default_url}' autocomplete='Reddit' valid='YES'>"
  xml += "<title>Reddit homepage</title>"
  xml += "<subtitle>#{default_url}</subtitle>"
  xml += "<icon>icon.png</icon>"
  xml += "</item>"
elsif subs.first == nil
  xml += "<item valid='no'>"
  xml += "<title>No Results. Keep Typing...</title>"
  xml += "<subtitle>The reddit API is a bit weird. Keep typing and your subreddit should show up.</subtitle>"
  xml += "<icon>icon.png</icon>"
  xml += "</item>"
else
  subs.each do |sub|
    data = sub["data"]
    xml += "<item arg='#{default_url + data["url"]}' autocomplete='#{data["display_name"]}' valid='YES'>"
    xml += "<title>#{data['display_name']}#{" (private)" if data["subreddit_type"] == "private" }</title>"
    # xml += "<subtitle>#{default_url + data["url"]}</subtitle>"
    xml += "<subtitle>#{data["public_description"]}</subtitle>"
    xml += "<icon>icon.png</icon>"
    xml += "</item>"
  end
end

xml += "</items>"

puts xml
