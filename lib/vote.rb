class Vote < Sequel::Model
  plugin :validation_helpers
  plugin :timestamps
  def validate
    super
    validates_presence [:sentiment, :text]
    validates_unique(:text) {|ds| ds.filter(:sentiment => self.sentiment)}
    if ![0,1,-1].include?(sentiment.to_i)
      errors.add(:sentiment, "Must be -1 1 or 0")
    end
  end
end
