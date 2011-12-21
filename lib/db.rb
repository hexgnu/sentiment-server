DB = Sequel.connect("sqlite://guise.db")

unless DB.table_exists? :votes
  puts 'creating table'
  DB.create_table :votes do
    primary_key :id
    Text :text
    Integer :sentiment
  end
end

require File.expand_path('../vote', __FILE__)