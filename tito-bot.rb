#!/usr/bin/env ruby
# Kent 'picat' Gruber
# A slack chat bot to give you team a little bit of Tito love.
require 'slack-ruby-client'
require 'optparse'

# Configure the bot to work with a token
Slack.configure do |config|
	config.token = 'SLACK_BOT_TOKEN_HERE'
end

# A nice, simple banner.
def banner
	puts "TITO-BOT\n"
end

# Set the version number because I like to have it around
def version
	puts "Version 1.1"
end

# Get all the quotes for Tito
quotes = File.foreach('tito-quotes.txt').to_a

# Extract relevant quotes into their own sub-sections
coconut_quotes = quotes.select { |elm| elm =~ /(C|c)oconut/ } 
pineapple_quotes = quotes.select  { |elm| elm =~ /(P|p)ineapple/ } 
fly_quotes = quotes.select { |elm| elm =~ /(F|f)ly/ }
ocean_quotes = quotes.select { |elm| elm =~ /(O|o)cean/ }

# Create a new client to monitor the messages in real time
client = Slack::RealTime::Client.new

options = {}
optparse = OptionParser.new do |opts|
	opts.banner = "Usage: #{$0} [OPTIONS]"
	opts.separator ""
	opts.separator "Example to start the slack bot:"
	opts.separator "EX: #{$0} -s"
	opts.separator ""
	opts.separator "Options:"
	opts.on('-s', '--start', "Start Tito-Bot") do
		options[:method] = 0
	end
	opts.on('-l', '--lol', "Rainbow support, because we need it.") do
		require 'lolize/auto'
	end
	opts.on('-v', '--version', "Show version number.") do
		banner
		version
		exit
	end
	opts.on('-h', '--help', "Help menu.") do
		banner
		puts
		puts opts
		puts
		exit
	end
end

begin
	if ARGV.size == 0   
		ARGV << "-h"
		optparse.parse!
	else
		mandatory = [:method]
		optparse.parse!
	end
	missing = mandatory.select{ |param| options[param].nil? }
	unless missing.empty?
		banner
		puts
		puts "Missing options; #{missing.join(', ')}"
		puts optparse
		puts
		exit
	end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
	banner
	puts
	puts $!.to_s
	puts
	puts optparse
	puts
	exit
end

trap("SIGINT") { puts "\n\n CTRL+C Detected!\n Tito-Bot is Kill."; exit;}

# Start the client
case options[:method].to_i
when 0
 	# Logging is a good thing
	logger = Logger.new('tito-bot.log')
end

# Check for when the text of the slack messages contain a regular expression
# Bot will message one relevant-ish quote for a match 
client.on :message do |data|

	matched_quote = false

	unless client.self.name.to_s == data.user 
		case data.text
		when /(C|c)oconut/ then
			unless matched_quote == true
				client.message channel: data.channel, text: "#{coconut_quotes.sample}"
   			matched_quote = true
		end
		when /(P|p)ineapple/ then
			unless matched_quote == true
				client.message channel: data.channel, text: "#{pineapple_quotes.sample}"
   			matched_quote = true
			end
		when /(O|o)cean/ then
			unless matched_quote == true
				client.message channel: data.channel, text: "#{ocean.sample}"
   			matched_quote = true
			end
		when /(F|f)ly/ then
			unless matched_quote == true
				client.message channel: data.channel, text: "#{fly_quotes.sample}"
   			matched_quote = true
			end
		when /(T|t)ito/ then
			unless matched_quote == true
				client.message channel: data.channel, text: "#{quotes.sample}"	
   			matched_quote = true
			end
		end
	end
end

# Start the client
client.start!
