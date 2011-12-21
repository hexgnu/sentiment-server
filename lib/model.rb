require 'forwardable'
module Guise
  class Sentiment
    extend Forwardable
    def_delegators :@trainer, :model!, :model, :vote
    
    def initialize
      puts 'bootstrapping'
      @trainer = Guise::Trainer.new
      puts 'loading votes from db'
      Vote.each do |v|
        @trainer.vote(v.sentiment, v.text)
      end
      
      @trainer.model!
      puts 'done.'
      
      EM.defer do
        background_job!
      end
    end
    
    def background_job!
      EM.add_periodic_timer(43_200) do
        self.model!
      end
    rescue Exception => e
      puts "CRAP #{e.message}"
      retry
    end
    
    def predict(text)
      Guise::Cache.fetch(text) do
        @trainer.predict(text)
      end
    end
    
    def vote(sentiment, text)
      if Vote.where(:sentiment => sentiment.to_i, :text => text).count == 0
        Vote.create(:sentiment => sentiment, :text => text)
        @trainer.vote(sentiment, text)
        "Success"
      else
        "Exists"
      end
    end
    
    def predict_many(texts)
      texts.map do |t|
        predict(t)
      end
    rescue => e
      puts e.message
    end
  end
end