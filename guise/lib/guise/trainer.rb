#        NAME: Guise::Trainer
#      AUTHOR: Matthew Kirk
#     LICENSE: Proprietary 
#   COPYRIGHT: (c) 2011 Matthew Kirk
# DESCRIPTION: 
#             Guise::Trainer is where the SVM model exists
#             This is built up using a training set and the basic api is
#             Guise::Trainer#vote(sentiment, text)
module Guise
  class Trainer
    DIR = File.dirname(__FILE__)
    attr_reader :word_set, :rows
    
    
    # Can take in a dictionary of words stored in the database or wherever
    def initialize(word_set = [], load_data = true)
      @rows = []
      @word_set = word_set
      if load_data
        puts "Loading training data..."
        load_training_data! 
        puts "Loading positive training data..."
        load_positive_training_data!
        puts "Loading negative training data..."
        load_negative_training_data!
      end
    end
    
    
    # Deprecating this method call to use Guise::NLP.clean(text) instead
    def clean(text = "")
      warn "Deprecation Warning: Please use Guise::NLP.clean(text) instead"
      Guise::NLP.clean(text)
    end
    
    
    # The sentiment [-1, 0, 1] maps to [negative, neutral, positive] and the text is the features to regress on
    def vote(sentiment, text)
      terms = Guise::NLP.clean(text)
      @word_set |= terms
      unless terms.empty?
        @rows << {sentiment => indicies(terms)}
      end
    end
    
    
    # Builds an libsvm problem
    def problem
      rows = []
      indexes = []
      @rows.each do |row|
        rows << row.keys.first
        indexes << row.values.first
      end
      
      @problem = SVM::Problem.new(rows, *indexes)
    end
    
    
    # Based on cross validation we should be using a C of 2 and a gamma of 0.125
    # This will yield the best results for our current data set.
    # will need to be reviewed in the future to see if still relevant
    def params
      SVM::Parameter.new(:kernel_type => RBF, :C => 2, :gamma => 0.125)
    end
    
    # Returns libsvm model
    def model
      @model ||= SVM::Model.new(problem, params)
    end
    
    # Returns libsvm model and destroys older version
    def model!
      @model = SVM::Model.new(problem, params)
    end
    
    # Returns a prediction based on training data when fed in a block of text
    def predict(text)
      words = Guise::NLP.clean(text)
      if words.empty? || indicies(words).compact.empty?
        0
      else
        indexes = indicies(words).compact
        model.predict(indexes)
      end
    end
    
    # Helper function for finding indicies of words in word_set
    def indicies(words)
      words.map { |word| @word_set.index(word) }
    end
    
    # Kills the current model
    def flush!
      @word_set = []
      @rows = []
      @model = nil
    end
    
    # Will output a friendly format for libsvm for testing
    def output_file
      rows.map do |row|
        label = row.keys.first
        indexes = row.values.first.sort.map {|idx| [idx + 1, 1].join(":")}.join("\t")
        [label, indexes].join("\t")
      end.join("\n")
    end
    
    def to_s
      "< Guise::Trainer: Current size: #{@word_set.length} >"
    end
    
    private
    
    %w[positive negative].each do |sentiment|
      define_method("load_#{sentiment}_training_data!") do
        File.open(File.join(DIR, "../../data/#{sentiment}_words.txt")).each do |line|
          vote((sentiment == "positive") ? 1 : -1, line)
        end
      end
    end
    
    
    def load_training_data!
      YAML::load(File.open(File.join(DIR, "../../data/output.yml"))).each do |row|
        if row[:answer].values.first != "-2"
          vote(row[:answer].values.first.to_i, row[:question])
        end
      end
    end
  end
end