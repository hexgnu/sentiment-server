# module Guise
#   TRANSFORMER = lambda do |env|
#     if env[:node_name] == "text"
#       puts env[:node]
#       return if env[:node] =~ URI
#     end
#   end
#   class << self
#     attr_accessor :configuration
#   end
#   
#   def self.configure
#     self.configuration ||= Configuration.new
#     yield(configuration)
#   end
#   
#   class Configuration
#     attr_accessor :stopwords
#     attr_reader
#     def initialize
#       @stopwords = File.open(File.expand_path(File.dirname(__FILE__), "../../data/stopwords.txt"), "r").read.scan(/\w+/)
#     end
#   end
# end