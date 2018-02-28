require 'opal'
require 'hyperloop-config'
require 'rubygems'
require 'opal-rails'
require 'hyper-operation'
require 'hyper-store'
require 'hyper-router'
require 'opal-browser'
require 'opal-jquery'
require 'uglifier'


file 'build/bundle.js' => 'client.js' do
  puts '--> Running webpack to build bundle.js'
  sh 'webpack --progress'
  puts '--> all done'
end
task :build => 'build/bundle.js'

task :build_app => 'build/bundle.js' do
  Opal.append_path 'app'
  puts '--> Building application.js'
  File.binwrite 'build/application.js', Opal::Builder.build('application').to_s
end

file 'dist/app.min.js' => ['build/application.js', 'build/bundle.js'] do
  puts '--> Running webpack to build distribution app.min.js'
  sh 'webpack --config=dist.config.js --progress -p'
end
task :dist => 'dist/app.min.js'
