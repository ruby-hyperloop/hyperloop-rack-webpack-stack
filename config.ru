require 'bundler'
Bundler.require

run Opal::Server.new {|server|
  server.main = 'application'
  server.append_path 'app'
  # ./app/index.html.erb is only used for development.
  server.index_path = './app/index.html.erb'
}
