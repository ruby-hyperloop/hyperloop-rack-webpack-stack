require 'opal-sprockets'

require 'bundler'
Bundler.require

run Opal::Server.new { |server|

  server.main = 'application'
  server.append_path 'app'
  server.index_path = './app/index.html.erb'
}
