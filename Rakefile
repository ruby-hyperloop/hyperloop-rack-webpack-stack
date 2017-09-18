require 'opal'
require 'opal_hot_reloader'

task :build do
  puts "Building app.js..."
  mkdir 'build' unless File.directory?('build')
  Opal.append_path "app"
  File.open("build/application.js", "w+") do |out|
   out << Opal::Builder.build("application").to_s
  end
  puts "Running webpack"
  sh 'webpack'
  puts 'all done'
end

# task :server do
#   Rake::Task['build'].execute
#   sh 'foreman start'
# end
