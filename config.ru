require 'yaml'
require "rubygems"
require "bundler"
Bundler.require
require './guise/lib/guise'
require './lib/db'
require './lib/model'

require './guise-service'

run Guise::Service


EM.defer do
  SentimentEngine = Guise::Sentiment.new
end
