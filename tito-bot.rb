#!/usr/bin/env ruby
# Kent 'picat' Gruber
# A slack chat bot to give your team a little bit of Tito love and inspiration.
require 'slack-ruby-client'

# Configure the bot to work with a token
Slack.configure do |config|
	config.token = 'SLACK_BOT_TOKEN_HERE'
end

# Get all the quotes for Tito
quotes = File.foreach('tito-quotes.txt')

# Extract relevant quotes into their own sub-section
coconut_quotes = quotes.to_a.select { |elm| elm =~ /(C|c)oconut/ } 
pineapple_quotes = quotes.to_a.select  { |elm| elm =~ /(P|p)ineapple/ } 
fly_quotes = quotes.to_a.select { |elm| elm =~ /(F|f)ly/ }
ocean_quotes = quotes.to_a.select { |elm| elm =~ /(O|o)cean/ }

# Create a new client to monitor the messages in real time
client = Slack::RealTime::Client.new

# Check for when the text of the slack messages contain a regular expression
# Bot will message one relevant-ish quote for a match 
client.on :message do |data|
	case data.text
	when /(C|c)oconut/ then
		client.message channel: data.channel, text: "#{coconut_quotes.sample}"
   	
	when /(P|p)ineapple/ then
		client.message channel: data.channel, text: "#{pineapple_quotes.sample}"

	when /(O|o)cean/ then
		client.message channel: data.channel, text: "#{ocean.sample}"
	
	when /(F|f)ly/ then
		client.message channel: data.channel, text: "#{fly_quotes.sample}"
	
	when /(T|t)ito/ then
		client.message channel: data.channel, text: "#{quotes.sample}"	
	end
end

# Start the client
client.start!
