require 'git'
namespace :build do
  desc 'Builds the guise gem into private_gems'
  task :guise do
    
    
    g = Git.clone('git@github.com:hexgnu/guise.git', 'guise')
    pwd = Dir.pwd
    Dir.chdir(g.working_directory)
    spec = Gem::Specification.load("./guise/guise.gemspec")
    file = Gem::Builder.new(spec).build
    
  end
end