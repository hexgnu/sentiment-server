require 'hex-svm'
require 'yaml'
Dir[File.join(File.dirname(__FILE__), "./guise/*.rb")].each do |requirement|
  require requirement
end