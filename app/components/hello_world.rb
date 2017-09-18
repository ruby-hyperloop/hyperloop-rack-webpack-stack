class HelloWorld < Hyperloop::Component
  render(DIV) do
    100.times do
      SPAN { "Hello world " }
    end
  end
end
