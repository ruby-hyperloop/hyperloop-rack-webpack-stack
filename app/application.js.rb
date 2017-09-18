require_tree './components'
require_tree './stores'

# next two lines only needed for development (adds approx. 600k to output)
require 'opal_hot_reloader'
OpalHotReloader.listen(25222, false, 1)

Document.ready? do
  Element['#site'].render{ HelloWorld() }
end
