require_tree './components'
require_tree './stores'

Document.ready? do
  Element['#site'].render { HelloWorld() }
end
