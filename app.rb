require 'json'
require "sinatra"
require 'active_support/all'
require "active_support/core_ext"
require 'sinatra/activerecord'
require 'rake'

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

client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]

# Hook this up to your Webhook for SMS/MMS through the console

get '/incoming_sms' do
  
  session["last_context"] ||= nil
  
  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip
  
  if body == "hi" or body == "hello" or body == "hey"
    message = get_about_message
  elsif body == "play"
    session["last_context"] = "play"
    session["guess_it"] = rand(1...5)
    message = "Guess what number I'm thinking of. It's between 1 and 5"
  elsif session["last_context"] == "play"
    
    # if it's not a number 
    if not body.to_i.to_s == body
      message = "Cheater cheater that's not a number. Try again"
    elsif body.to_i == session["guess_it"]
      message = "Bingo! It was #{session["guess_it"]}"
      session["last_context"] = "correct_answer"
      session["guess_it"] = -1
    else
      message = "Wrong! Try again"
    end
    
  elsif body == "who"
    message = "I was made by Daragh."
  elsif body == "what"
    message = "I don't do much but I do it well. You can ask me who what when where or why."
  elsif body == "when"    
    message = Time.now.strftime( "It's %A %B %e, %Y")
  elsif body == "where"    
    message = "I'm in Pittsburgh right now."
  elsif body == "why"    
    message = "For educational purposes."
  else 
    message = error_response
    session["last_context"] = "error"
  end
  
  twiml = Twilio::TwiML::Response.new do |r|
    r.Message message
  end
  twiml.text
end



private 
