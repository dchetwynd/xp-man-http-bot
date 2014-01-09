require 'rubygems'
require 'bundler'

require 'sinatra'

require './xp_man_http_bot'

set :show_exceptions, true
run XPManHTTPBot
