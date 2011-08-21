require "rake"

begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "aq.rb"
    gem.summary = "Ruby library for interfacing with various aquarium controllers"
    gem.email = "chuck.collins@gmail.com"
    gem.homepage = "http://github.com/ccollins/aq.rb"
    gem.authors = ["Chuck Collins"]
    gem.files = Dir["*", "{lib}/**/*"]
    gem.add_dependency("json")
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end