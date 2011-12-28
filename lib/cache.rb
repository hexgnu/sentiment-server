class NullStore
  def fetch(*args)
    yield
  end
end

if ENV['RACK_ENV'] =~ /production/i
  Guise::Cache = Dalli::Client.new
else
  Guise::Cache = NullStore.new
end