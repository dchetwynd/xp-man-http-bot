require 'rack/test'
require_relative '../xp_man_http_bot.rb'

include Rack::Test::Methods

def app
  XPManHTTPBot.new
end
