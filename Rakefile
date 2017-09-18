require 'opal'
require 'opal_hot_reloader'

task :build do
  mkdir 'build' unless File.directory?('build')
  Opal.append_path "app"

  puts "--> Building application.js"
  File.open("build/application.js", "w+") do |out|
   out << Opal::Builder.build("application").to_s
  end

  puts "--> Building opal.js"
  File.open("build/opal.js", "w+") do |out|
   out << Opal::Builder.build("opal").to_s
  end

  puts "--> Running webpack to build bundle.js"
  sh 'webpack'
  puts '--> all done'
end

# task :server do
#   Rake::Task['build'].execute
#   sh 'foreman start'
# end
