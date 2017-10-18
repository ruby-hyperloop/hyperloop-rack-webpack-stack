class HelloWorld < Hyperloop::Component
  render(DIV) do
    1000.times do
      SPAN(class: 'red-text') { 'Hello World ' }
    end
  end
end
