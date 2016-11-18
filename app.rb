require 'json'
require "sinatra"
require 'shotgun'
require 'active_support/all'
require "active_support/core_ext"
require 'sinatra/activerecord'
require 'rake'
# require 'pg'

require 'twilio-ruby'
# require 'stock_quote'
# require 'giphy'

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end


# enable sessions for this project

enable :sessions


# CREATE A CLient
client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]


# Use this method to check if your ENV file is set up
get "/" do
  "Hello world!"
end

get "/from" do
  #401
  ENV["TWILIO_FROM"]
end


# Test sending an SMS
# change the to to your number 

get "/send_sms" do

  client.account.messages.create(
    :from => "+14152002424",
    :to => "+12067130783",
    :body => "Hey there. This is a test"
  )

  "Sent message"
  
end

