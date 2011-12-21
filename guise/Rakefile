require 'rubygems'
require 'rake'

require 'jeweler'
jeweler_tasks = Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "guise"
  gem.homepage = "http://github.com/hexgnu/guise"
  gem.license = "MIT"
  gem.summary = %Q{Guise is the SVM driven sentiment engine for SocialVolt}
  gem.description = gem.summary
  gem.email = "matt@matthewkirk.com"
  gem.authors = ["Matt Kirk (Modulus 7, LLC)"]
  # gem.extensions          = FileList['ext/**/extconf.rb']
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
  gem.add_runtime_dependency 'hexgnu-libsvm-ruby-swig', '0.1.3.1'
  gem.add_development_dependency "rspec", "~> 2.3.0"
  gem.add_development_dependency "yard", "~> 0.6.0"
  gem.add_development_dependency "bundler", "~> 1.0.0"
  gem.add_development_dependency "jeweler", "~> 1.5.2"
  gem.add_development_dependency "rcov", ">= 0"
  gem.add_development_dependency "reek", "~> 1.2.8"
  gem.add_development_dependency "roodi", "~> 2.1.0"
  gem.add_development_dependency "rake-compiler", "~> 0.7.7"
  gem.add_development_dependency "rake-tester", "0.0.1"
end
$gemspec         = jeweler_tasks.gemspec
$gemspec.version = jeweler_tasks.jeweler.version
Jeweler::RubygemsDotOrgTasks.new

require 'rake/extensiontask'
require 'rake/extensiontesttask'

# Rake::ExtensionTask.new('guise_native', $gemspec) do |ext|
#     ext.cross_compile   = true
#     ext.cross_platform  = 'x86-mswin32'
#     ext.test_files      = FileList['spec/c/*']
# end

# CLEAN.include 'lib/**/*.so'
# CLEAN.include 'lib/**/*.bundle'



require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

require 'reek/rake/task'
Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end

require 'roodi'
require 'roodi_task'
RoodiTask.new do |t|
  t.verbose = false
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
