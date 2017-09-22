require 'opal'

task :build do
  mkdir 'build' unless File.directory?('build')
  Opal.append_path "app"
  puts "--> Building application.js"
  File.open("build/application.js", "w+") do |out|
   out << Opal::Builder.build("application").to_s
  end
  puts "--> Running webpack to build bundle.js"
  sh 'webpack --progress'
  puts '--> all done'
end

task :dist do
  mkdir 'dist' unless File.directory?('dist')
  puts "--> Running webpack to build distribution app.min.js"
  sh 'webpack --config=dist.config.js --progress -p'
end
