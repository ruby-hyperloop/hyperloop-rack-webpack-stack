# this is included in the sprockets build (via index.html.erb) but not the Rake build process
require 'opal_hot_reloader'
OpalHotReloader.listen
