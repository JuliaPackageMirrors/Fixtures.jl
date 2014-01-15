module FactCheckSupportTests

using Fixtures
using FactCheck


facts("FactCheck support tests", using_fixtures) do
  context("Very basic example no fixtures defined", using_fixtures) do
    @fact 100 => 100
  end

  global x=0

  add_fixture(:context, function(fn::Function)
                          global x=100
                          try
                            fn()
                          finally
                            global x=0
                          end
                        end)

  @fact x => 0

  context("Example with fixtures set on a context level", using_fixtures) do
    @fact x => 100
  end

  @fact x => 0

  context("Example with fixtures set on a context level (again)", using_fixtures) do
    @fact x => 100
  end

  @fact x => 0

end

end