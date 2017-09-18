class HelloWorld < Hyperloop::Component
  render(DIV) do
    1000.times do
      SPAN { "Hello world " }
    end
  end
end
