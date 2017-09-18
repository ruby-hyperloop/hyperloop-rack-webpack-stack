class HelloWorld < Hyperloop::Component
  render(DIV) do
    100.times do
      SPAN { "Wello world! " }
    end
  end
end
