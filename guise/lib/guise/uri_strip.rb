require 'uri'
# This Strips all of the urls out of a block of text
# Utilizes built in URI regular expression
module Util
  extend self
  
  # Strips all of the urls out of a block of text
  def self.strip(str, schemes = nil)
    str.gsub(URI.regexp(schemes), '')
  end
end