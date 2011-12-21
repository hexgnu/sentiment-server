require 'digest/sha1'

module Guise
  module NLP
    extend self
    
    def bloom_filter
      bloom_filter = BloominSimple.new(50_000) do |word|
        Digest::SHA1.digest(word.downcase.strip).unpack("VVV")
      end
      
      File.open(File.join(File.dirname(__FILE__), "../../data/stopwords.txt")).each do |line| 
        bloom_filter.add(line)
      end
      bloom_filter
    end
    
    STOPWORDS = bloom_filter
    
    # Using a bloom filter to load in the stop words and to kill all of them out of the file
    # Strips urls downcases text and takes out html_nuglets.  This tokenizes the text into 
    # a set of features to build our model on.
    def clean(text = "")
      extracted_terms = []
      non_alpha = /[^a-z\s]/
      html_nuglets = /&.+;/
      Util.strip(text).downcase.gsub(Regexp.union(html_nuglets, non_alpha), '').split(/\s+/).uniq.each do |word| 
        if not_stopword?(word)
          extracted_terms << word
        end
      end
      extracted_terms
    end
    
    
    # Helper function to determine whether we should keep the word or not
    def not_stopword?(word)
      !STOPWORDS.includes?(word)
    end
    
    
  end
end