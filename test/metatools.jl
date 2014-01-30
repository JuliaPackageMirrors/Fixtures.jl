module MetaTests

using Fixtures
using Fixtures.MetaTools
using FactCheck

const ANY_LINE_NUMBER = redescribe(anything_of_type(LineNumberNode) | (anything_of_type(Expr) & Matcher(v->v.head==:line, "expr.head==:line")), "Any line number")

module MetaTestModule1
  module MetaTestModule2
    module MetaTestModule3
      function hello()
      end
    end
    function hello()
    end
  end
  function hello()
  end
  function baz()
  end
  function boo()
  end
end


facts("MetaTools.ParsedFunction tests") do
  context("Empty method with no args") do
    func = ParsedFunction(:(function hello() end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with no args and bracketed name") do
    func = ParsedFunction(:(function (hello)() end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with one untyped arg") do
    func = ParsedFunction(:(function hello(x) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty method with two untyped args") do
    func = ParsedFunction(:(function hello(x,y) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty method with one typed arg") do
    func = ParsedFunction(:(function hello(x::Integer) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty method with two typed args") do
    func = ParsedFunction(:(function hello(x::Integer, y::FloatingPoint) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty method with one union typed arg") do
    func = ParsedFunction(:(function hello(x::Union(Integer,FloatingPoint)) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty method with one untyped default arg") do
    func = ParsedFunction(:(function hello(x=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
  end

  context("Empty method with two untyped default args") do
    func = ParsedFunction(:(function hello(x=100,y=200) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact func.args[2].default => 200
  end

  context("Empty method with one typed default arg") do
    func = ParsedFunction(:(function hello(x::Integer=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
  end

  context("Empty method with two typed default args") do
    func = ParsedFunction(:(function hello(x::Integer=100, y::FloatingPoint=200.0) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact func.args[2].default => 200.0
  end

  context("Empty method with one untyped vararg") do
    func = ParsedFunction(:(function hello(x...) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty method with one typed vararg") do
    func = ParsedFunction(:(function hello(x::Integer...) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty method with one untyped default vararg") do
    func = ParsedFunction(:(function hello(x...=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact func.args[1].default => 100
  end

  context("Empty method with one typed default vararg") do
    func = ParsedFunction(:(function hello(x::Integer...=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact func.args[1].default => 100
  end

  context("Empty method with one untyped kwarg") do
    func = ParsedFunction(:(function hello(;x=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty method with two untyped kwargs") do
    func = ParsedFunction(:(function hello(;x=100,y=200) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 2
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :y
    @fact func.kwargs[2].typ => :Any
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200
  end

  context("Empty method with one typed kwarg") do
    func = ParsedFunction(:(function hello(;x::Integer=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty method with two typed kwargs") do
    func = ParsedFunction(:(function hello(;x::Integer=100, y::FloatingPoint=200.0) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 2
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :y
    @fact func.kwargs[2].typ => :FloatingPoint
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200.0
  end

  context("Empty method with one union typed kwarg") do
    func = ParsedFunction(:(function hello(;x::Union(Integer, FloatingPoint)=100) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty method with one untyped varkwarg") do
    func = ParsedFunction(:(function hello(;x...) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => true
    @fact isdefined(func.kwargs[1], :default) => false
  end

  context("Empty method with one typed varkwarg") do
    func = ParsedFunction(:(function hello(;x::Array...) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Array
    @fact func.kwargs[1].varargs => true
    @fact isdefined(func.kwargs[1], :default) => false
  end

  context("Empty method with a mix of args and kwargs") do
    func = ParsedFunction(:(function hello(x,y::Integer,z=99,rest...;a::Integer=100,b=200,c...) end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.body => quote end

    @fact length(func.args) => 4
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Integer
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
    @fact func.args[3].name => :z
    @fact func.args[3].typ => :Any
    @fact func.args[3].varargs => false
    @fact func.args[3].default => 99
    @fact func.args[4].name => :rest
    @fact func.args[4].typ => :Any
    @fact func.args[4].varargs => true
    @fact isdefined(func.args[4], :default) => false

    @fact length(func.kwargs) => 3
    @fact func.kwargs[1].name => :a
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :b
    @fact func.kwargs[2].typ => :Any
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200
    @fact func.kwargs[3].name => :c
    @fact func.kwargs[3].typ => :Any
    @fact func.kwargs[3].varargs => true
    @fact isdefined(func.kwargs[3], :default) => false
  end

  context("Empty method with namespace 1 deep") do
    func = ParsedFunction(:(function MetaTestModule1.hello() end))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with namespace 2 deep") do
    func = ParsedFunction(:(function MetaTestModule1.MetaTestModule2.hello() end))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with namespace 3 deep") do
    func = ParsedFunction(:(function MetaTestModule1.MetaTestModule2.MetaTestModule3.hello() end))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2, :MetaTestModule3]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with no type parameter") do
    func = ParsedFunction(:(function hello() end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with one type parameter") do
    func = ParsedFunction(:(function hello{T}() end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact func.types => [:T]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with two type parameters") do
    func = ParsedFunction(:(function hello{T1, T2}() end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact func.types => [:T1, :T2]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with namespace 3 deep and a type parameter") do
    func = ParsedFunction(:(function MetaTestModule1.MetaTestModule2.MetaTestModule3.hello{T}() end))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2, :MetaTestModule3]
    @fact func.types => [:T]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  #############################################################################

  context("Empty shorthand method with no args") do
    func = ParsedFunction(:(hello() = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with no args and bracketed name") do
    func = ParsedFunction(:((hello)() = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with one untyped arg") do
    func = ParsedFunction(:(hello(x) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty shorthand method with two untyped args") do
    func = ParsedFunction(:(hello(x,y) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty shorthand method with one typed arg") do
    func = ParsedFunction(:(hello(x::Integer) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty shorthand method with two typed args") do
    func = ParsedFunction(:(hello(x::Integer, y::FloatingPoint) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty shorthand method with one union typed arg") do
    func = ParsedFunction(:(hello(x::Union(Integer,FloatingPoint)) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty shorthand method with one untyped default arg") do
    func = ParsedFunction(:(hello(x=100) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
  end

  context("Empty shorthand method with two untyped default args") do
    func = ParsedFunction(:(hello(x=100,y=200) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact func.args[2].default => 200
  end

  context("Empty shorthand method with one typed default arg") do
    func = ParsedFunction(:(hello(x::Integer=100) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
  end

  context("Empty shorthand method with two typed default args") do
    func = ParsedFunction(:(hello(x::Integer=100, y::FloatingPoint=200.0) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact func.args[2].default => 200.0
  end

  context("Empty shorthand method with one untyped vararg") do
    func = ParsedFunction(:(hello(x...) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty shorthand method with one typed vararg") do
    func = ParsedFunction(:(hello(x::Integer...) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty shorthand method with one untyped default vararg") do
    func = ParsedFunction(:(hello(x...=100) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact func.args[1].default => 100
  end

  context("Empty shorthand method with one typed default vararg") do
    func = ParsedFunction(:(hello(x::Integer...=100) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact func.args[1].default => 100
  end

  context("Empty shorthand method with one untyped kwarg") do
    func = ParsedFunction(:(hello(;x=100) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty shorthand method with two untyped kwargs") do
    func = ParsedFunction(:(hello(;x=100,y=200) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 2
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :y
    @fact func.kwargs[2].typ => :Any
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200
  end

  context("Empty shorthand method with one typed kwarg") do
    func = ParsedFunction(:(hello(;x::Integer=100) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty shorthand method with two typed kwargs") do
    func = ParsedFunction(:(hello(;x::Integer=100, y::FloatingPoint=200.0) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 2
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :y
    @fact func.kwargs[2].typ => :FloatingPoint
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200.0
  end

  context("Empty shorthand method with one union typed kwarg") do
    func = ParsedFunction(:(hello(;x::Union(Integer, FloatingPoint)=100) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty shorthand method with one untyped varkwarg") do
    func = ParsedFunction(:(hello(;x...) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => true
    @fact isdefined(func.kwargs[1], :default) => false
  end

  context("Empty shorthand method with one typed varkwarg") do
    func = ParsedFunction(:(hello(;x::Integer...) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => true
    @fact isdefined(func.kwargs[1], :default) => false
  end

  context("Empty shorthand method with a mix of args and kwargs") do
    func = ParsedFunction(:(hello(x,y::Integer,z=99,rest...;a::Integer=100,b=200,c...) = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.body => quote end

    @fact length(func.args) => 4
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Integer
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
    @fact func.args[3].name => :z
    @fact func.args[3].typ => :Any
    @fact func.args[3].varargs => false
    @fact func.args[3].default => 99
    @fact func.args[4].name => :rest
    @fact func.args[4].typ => :Any
    @fact func.args[4].varargs => true
    @fact isdefined(func.args[4], :default) => false

    @fact length(func.kwargs) => 3
    @fact func.kwargs[1].name => :a
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :b
    @fact func.kwargs[2].typ => :Any
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200
    @fact func.kwargs[3].name => :c
    @fact func.kwargs[3].typ => :Any
    @fact func.kwargs[3].varargs => true
    @fact isdefined(func.kwargs[3], :default) => false
  end

  context("Empty shorthand method with namespace 1 deep") do
    func = ParsedFunction(:(MetaTestModule1.hello() = begin end))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with namespace 2 deep") do
    func = ParsedFunction(:(MetaTestModule1.MetaTestModule2.hello() = begin end))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with namespace 3 deep") do
    func = ParsedFunction(:(MetaTestModule1.MetaTestModule2.MetaTestModule3.hello() = begin end))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2, :MetaTestModule3]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with no type parameter") do
    func = ParsedFunction(:(hello() = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with one type parameter") do
    func = ParsedFunction(:(hello{T}() = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact func.types => [:T]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with two type parameters") do
    func = ParsedFunction(:(hello{T1, T2}() = begin end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact func.types => [:T1, :T2]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with namespace 3 deep and a type parameter") do
    func = ParsedFunction(:(MetaTestModule1.MetaTestModule2.MetaTestModule3.hello{T}() = begin end))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2, :MetaTestModule3]
    @fact func.types => [:T]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  #############################################################################

  context("Empty lambda with no args") do
    func = ParsedFunction(:(() -> begin end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty lambda with one untyped arg") do
    func = ParsedFunction(:((x) -> begin end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty lambda with two untyped args") do
    func = ParsedFunction(:((x,y) -> begin end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty lambda with one typed arg") do
    func = ParsedFunction(:((x::Integer) -> begin end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty lambda with two typed args") do
    func = ParsedFunction(:((x::Integer, y::FloatingPoint) -> begin end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty lambda with one union typed arg") do
    func = ParsedFunction(:((x::Union(Integer,FloatingPoint)) -> begin end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty lambda with one untyped vararg") do
    func = ParsedFunction(:((x...) -> begin end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty lambda with one typed vararg") do
    func = ParsedFunction(:((x::Integer...) -> begin end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty lambda with a mix of args") do
    func = ParsedFunction(:((x,y::Integer,z...) -> begin end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact func.body => quote end

    @fact length(func.args) => 3
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Integer
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
    @fact func.args[3].name => :z
    @fact func.args[3].typ => :Any
    @fact func.args[3].varargs => true
    @fact isdefined(func.args[3], :default) => false

    @fact isdefined(func, :kwargs) => false
  end

  #############################################################################

  context("Empty anonymous function with no args") do
    func = ParsedFunction(:(function() end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty anonymous function with one untyped arg") do
    func = ParsedFunction(:(function(x) end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty anonymous function with two untyped args") do
    func = ParsedFunction(:(function(x,y) end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty anonymous function with one typed arg") do
    func = ParsedFunction(:(function(x::Integer) end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty anonymous function with two typed args") do
    func = ParsedFunction(:(function(x::Integer, y::FloatingPoint) end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty anonymous function with one union typed arg") do
    func = ParsedFunction(:(function(x::Union(Integer,FloatingPoint)) end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty anonymous function with one untyped vararg") do
    func = ParsedFunction(:(function(x...) end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty anonymous function with one typed vararg") do
    func = ParsedFunction(:(function(x::Integer...) end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty anonymous function with a mix of args") do
    func = ParsedFunction(:(function(x,y::Integer,z...) end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact func.body => quote end

    @fact length(func.args) => 3
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Integer
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
    @fact func.args[3].name => :z
    @fact func.args[3].typ => :Any
    @fact func.args[3].varargs => true
    @fact isdefined(func.args[3], :default) => false

    @fact isdefined(func, :kwargs) => false
  end

  #############################################################################

  context("Method with a numeric literal body") do
    func = ParsedFunction(:(function hello() 10 end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, 10)
    @fact func.args => []
  end

  context("Shorthand method with a numeric literal body") do
    func = ParsedFunction(:(hello() = 10))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, 10)
    @fact func.args => []
  end

  context("Lambda with a numeric literal body") do
    func = ParsedFunction(:(() -> 10))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, 10)
    @fact func.args => []
  end

  context("Anonymous function with a numeric literal body") do
    func = ParsedFunction(:(function() 10 end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, 10)
    @fact func.args => []
  end

  #----------------------------------------------------------------------------

  context("Method with a symbol body") do
    func = ParsedFunction(:(function hello() x end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, :x)
    @fact func.args => []
  end

  context("Shorthand method with a symbol body") do
    func = ParsedFunction(:(hello() = x))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, :x)
    @fact func.args => []
  end

  context("Lambda with a symbol body") do
    func = ParsedFunction(:(() -> x))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, :x)
    @fact func.args => []
  end

  context("Anonymous function with a symbol body") do
    func = ParsedFunction(:(function() x end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, :x)
    @fact func.args => []
  end

  #----------------------------------------------------------------------------

  context("Method with a expression body") do
    func = ParsedFunction(:(function hello() x + 10 end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, Expr(:call, :+, :x, 10))
    @fact func.args => []
  end

  context("Shorthand method with a expression body") do
    func = ParsedFunction(:(hello() = x + 10))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:call, :+, :x, 10)
    @fact func.args => []
  end

  context("Lambda with a expression body") do
    func = ParsedFunction(:(() -> x + 10))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, Expr(:call, :+, :x, 10))
    @fact func.args => []
  end

  context("Anonymous function with a expression body") do
    func = ParsedFunction(:(function() x + 10 end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, Expr(:call, :+, :x, 10))
    @fact func.args => []
  end

  #----------------------------------------------------------------------------

  context("Method with a multiline body") do
    func = ParsedFunction(:(function hello()
                              y = x + 10
                              y += some_func(z)
                              return y
                            end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            ANY_LINE_NUMBER,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            ANY_LINE_NUMBER,
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            ANY_LINE_NUMBER,
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end

  context("Shorthand method with a multiline body with begin end") do
    func = ParsedFunction(:(hello() = begin
                              y = x + 10
                              y += some_func(z)
                              return y
                            end))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            ANY_LINE_NUMBER,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            ANY_LINE_NUMBER,
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            ANY_LINE_NUMBER,
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end

  context("Shorthand method with a multiline body with brackets") do
    func = ParsedFunction(:(hello() = (y = x + 10;
                                       y += some_func(z);
                                       return y)))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end

  context("Lambda with a multiline body with begin end") do
    func = ParsedFunction(:(() -> begin
                              y = x + 10
                              y += some_func(z)
                              return y
                            end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            ANY_LINE_NUMBER,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            ANY_LINE_NUMBER,
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            ANY_LINE_NUMBER,
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end

  context("Lambda with a multiline body with brackets") do
    func = ParsedFunction(:(() -> (y = x + 10;
                                   y += some_func(z);
                                   return y)))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end

  context("Anonymous function with a multiline body") do
    func = ParsedFunction(:(function()
                              y = x + 10
                              y += some_func(z)
                              return y
                            end))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            ANY_LINE_NUMBER,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            ANY_LINE_NUMBER,
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            ANY_LINE_NUMBER,
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end
end

###############################################################################
###############################################################################

facts("MetaTools.emit tests") do
  context("Empty method with no args") do
    pfunc = ParsedFunction(name=:hello1)
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello1
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  context("Empty method with one untyped arg") do
    pfunc = ParsedFunction(name=:hello2,
                           args=[ParsedArgument(name=:x)])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello2
    @fact func.env.max_args => 1
    @fact func(10) => nothing
  end

  context("Empty method with two untyped args") do
    pfunc = ParsedFunction(name=:hello3,
                           args=[ParsedArgument(name=:x),
                                 ParsedArgument(name=:y)])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello3
    @fact func.env.max_args => 2
    @fact func(10, 20) => nothing
  end

  context("Empty method with one typed arg") do
    pfunc = ParsedFunction(name=:hello4,
                           args=[ParsedArgument(name=:x, typ=:Integer)])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello4
    @fact func.env.max_args => 1
    @fact func(10) => nothing
  end

  context("Empty method with two typed args") do
    pfunc = ParsedFunction(name=:hello5,
                           args=[ParsedArgument(name=:x, typ=:Integer),
                                 ParsedArgument(name=:y, typ=:Integer)])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello5
    @fact func.env.max_args => 2
    @fact func(10, 20) => nothing
  end

  context("Empty method with one union typed arg") do
    pfunc = ParsedFunction(name=:hello6,
                           args=[ParsedArgument(:(x::Union(FloatingPoint, Integer)))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello6
    @fact func.env.max_args => 1
    @fact func(10) => nothing
  end

  context("Empty method with one untyped default arg") do
    pfunc = ParsedFunction(name=:hello7,
                           args=[ParsedArgument(:(x=100))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello7
    @fact func.env.max_args => 1
    @fact func() => nothing
    @fact func(100) => nothing
  end

  context("Empty method with two untyped default args") do
    pfunc = ParsedFunction(name=:hello8,
                           args=[ParsedArgument(:(x=100)),
                                 ParsedArgument(:(y=100))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello8
    @fact func.env.max_args => 2
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
  end

  context("Empty method with one typed default arg") do
    pfunc = ParsedFunction(name=:hello9,
                           args=[ParsedArgument(:(x::Integer=100))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello9
    @fact func.env.max_args => 1
    @fact func() => nothing
    @fact func(100) => nothing
  end

  context("Empty method with two typed default args") do
    pfunc = ParsedFunction(name=:hello10,
                           args=[ParsedArgument(:(x::Integer=100)),
                                 ParsedArgument(:(y::Integer=100))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello10
    @fact func.env.max_args => 2
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
  end

  context("Empty method with one untyped vararg") do
    pfunc = ParsedFunction(name=:hello11,
                           args=[ParsedArgument(:(x...))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello11
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty method with one typed vararg") do
    pfunc = ParsedFunction(name=:hello12,
                           args=[ParsedArgument(:(x::Integer...))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello12
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty method with one untyped default vararg") do
    pfunc = ParsedFunction(name=:hello13,
                           args=[ParsedArgument(:(x...=1))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello13
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty method with one typed default vararg") do
    pfunc = ParsedFunction(name=:hello14,
                           args=[ParsedArgument(:(x::Integer...=1))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello14
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty method with one untyped kwarg") do
    pfunc = ParsedFunction(name=:hello15,
                           kwargs=[ParsedArgument(:(x=10))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello15
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
  end

  context("Empty method with two untyped kwargs") do
    pfunc = ParsedFunction(name=:hello16,
                           kwargs=[ParsedArgument(:(x=10)),
                                   ParsedArgument(:(y=20))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello16
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
    @fact func(y=200) => nothing
    @fact func(x=100, y=200) => nothing
  end

  context("Empty method with one typed kwarg") do
    pfunc = ParsedFunction(name=:hello17,
                           kwargs=[ParsedArgument(:(x::Integer=10))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello17
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
  end

  context("Empty method with two typed kwargs") do
    pfunc = ParsedFunction(name=:hello18,
                           kwargs=[ParsedArgument(:(x::Integer=10)),
                                   ParsedArgument(:(y::Integer=20))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello18
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
    @fact func(y=200) => nothing
    @fact func(x=100, y=200) => nothing
  end

  context("Empty method with one union typed kwarg") do
    pfunc = ParsedFunction(name=:hello19,
                           kwargs=[ParsedArgument(:(x::Union(FloatingPoint, Integer)=10))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello19
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
  end

  context("Empty method with one untyped varkwarg") do
    pfunc = ParsedFunction(name=:hello20,
                           kwargs=[ParsedArgument(:(x...))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello20
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
    @fact func(y=200) => nothing
    @fact func(x=100, y=200) => nothing
  end

  context("Empty method with one typed varkwarg") do
    pfunc = ParsedFunction(name=:hello21,
                           kwargs=[ParsedArgument(:(x::Array...))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello21
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
    @fact func(y=200) => nothing
    @fact func(x=100, y=200) => nothing
  end

  context("Empty method with a mix of args and kwargs") do
    pfunc = ParsedFunction(name=:hello22,
                           args=[ParsedArgument(:x),
                                 ParsedArgument(:(y::Integer)),
                                 ParsedArgument(:(z=99))],
                           kwargs=[ParsedArgument(:(a::Integer=100)),
                                   ParsedArgument(:(b=200)),
                                   ParsedArgument(:(c...))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello22
    @fact func.env.max_args => 3
    @fact func(10, 20) => nothing
    @fact func(10, 20, 30) => nothing
    @fact func(10, 20, a=99) => nothing
    @fact func(10, 20, 30, b=99, foobar=100) => nothing
  end

  context("Empty method with namespace 1 deep") do
    pfunc = ParsedFunction(name=:hello,
                           namespace=[:MetaTestModule1])
    func = eval(emit(pfunc))
    @fact (func === MetaTestModule1.hello) => true
    @fact isgeneric(func) => true
    @fact func.env.name => :hello
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  context("Empty method with namespace 2 deep") do
    pfunc = ParsedFunction(name=:hello,
                           namespace=[:MetaTestModule1, :MetaTestModule2])
    func = eval(emit(pfunc))
    @fact (func === MetaTestModule1.MetaTestModule2.hello) => true
    @fact isgeneric(func) => true
    @fact func.env.name => :hello
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  context("Empty method with namespace 3 deep") do
    pfunc = ParsedFunction(name=:hello,
                           namespace=[:MetaTestModule1, :MetaTestModule2, :MetaTestModule3])
    func = eval(emit(pfunc))
    @fact (func === MetaTestModule1.MetaTestModule2.MetaTestModule3.hello) => true
    @fact isgeneric(func) => true
    @fact func.env.name => :hello
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  context("Empty method with no type parameter") do
    pfunc = ParsedFunction(name=:hello23,
                           types=Symbol[])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello23
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  context("Empty method with one type parameter") do
    pfunc = ParsedFunction(name=:hello24,
                           types=[:T],
                           args=[ParsedArgument(:(x::T))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello24
    @fact func.env.max_args => 1
    @fact func(10) => nothing
  end

  context("Empty method with two type parameters") do
    pfunc = ParsedFunction(name=:hello25,
                           types=[:T1, :T2],
                           args=[ParsedArgument(:(x::T1)),
                                 ParsedArgument(:(y::T2))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello25
    @fact func.env.max_args => 2
    @fact func(10, 20) => nothing
  end

  context("Empty method with namespace 3 deep and one type parameter") do
    pfunc = ParsedFunction(name=:hello,
                           types=[:T],
                           namespace=[:MetaTestModule1, :MetaTestModule2, :MetaTestModule3])
    func = eval(emit(pfunc))
    @fact (func === MetaTestModule1.MetaTestModule2.MetaTestModule3.hello) => true
    @fact isgeneric(func) => true
    @fact func.env.name => :hello
    @fact func.env.max_args => 0
    @fact func() => nothing
  end
  #############################################################################

  context("Empty anonymous function with no args") do
    pfunc = ParsedFunction()
    func = eval(emit(pfunc))
    @fact func() => nothing
  end

  context("Empty anonymous function with one untyped arg") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x)])
    func = eval(emit(pfunc))
    @fact func(10) => nothing
  end

  context("Empty anonymous function with two untyped args") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x),
                                 ParsedArgument(:y)])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func(10, 20) => nothing
  end

  context("Empty anonymous function with one typed arg") do
    pfunc = ParsedFunction(args=[ParsedArgument(:(x::Integer))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func(10) => nothing
  end

  context("Empty anonymous function with two typed args") do
    pfunc = ParsedFunction(args=[ParsedArgument(:(x::Integer)),
                                 ParsedArgument(:(y::Integer))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func(10, 20) => nothing
  end

  context("Empty anonymous function with one union typed arg") do
    pfunc = ParsedFunction(args=[ParsedArgument(:(x::Union(FloatingPoint, Integer)))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func(10) => nothing
  end

  context("Empty anonymous function with one untyped vararg") do
    pfunc = ParsedFunction(args=[ParsedArgument(:(x...))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty anonymous function with one typed vararg") do
    pfunc = ParsedFunction(args=[ParsedArgument(:(x::Integer...))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty anonymous function with a mix of args") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x),
                                 ParsedArgument(:(y::Integer)),
                                 ParsedArgument(:(z...))])
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func(10, 20) => nothing
    @fact func(10, 20, 30) => nothing
    @fact func(10, 20, 30, 40) => nothing
  end


  #############################################################################

  context("Method with a numeric literal body") do
    pfunc = ParsedFunction(name=:hello100,
                           body=Expr(:block, 10))
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello100
    @fact func.env.max_args => 0
    @fact func() => 10
  end

  context("Anonymous function with a numeric literal body") do
    pfunc = ParsedFunction(body=Expr(:block, 10))
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func() => 10
  end
  #----------------------------------------------------------------------------

  context("Method with a symbol body") do
    pfunc = ParsedFunction(name=:hello101,
                           args=[ParsedArgument(:x)],
                           body=Expr(:block, :x))
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello101
    @fact func.env.max_args => 1
    @fact func(10) => 10
    @fact func(100) => 100
  end

  context("Anonymous function with a symbol body") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x)],
                           body=Expr(:block, :x))
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func(10) => 10
    @fact func(100) => 100
  end
  #----------------------------------------------------------------------------

  context("Method with a expression body") do
    pfunc = ParsedFunction(name=:hello102,
                           args=[ParsedArgument(:x)],
                           body=:(x + 10))
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello102
    @fact func.env.max_args => 1
    @fact func(10) => 20
    @fact func(100) => 110
  end

  context("Anonymous function with a expression body") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x)],
                           body=:(x + 10))
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func(10) => 20
    @fact func(100) => 110
  end
  #----------------------------------------------------------------------------

  context("Method with a multiline body") do
    pfunc = ParsedFunction(name=:hello103,
                           args=[ParsedArgument(:x)],
                           body=quote
                             y = x + 10
                             z = x - 10
                             return z//y
                           end)
    func = eval(emit(pfunc))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello103
    @fact func.env.max_args => 1
    @fact func(100) => 9//11
  end

  context("Anonymous function with a multiline body") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x)],
                           body=quote
                             y = x + 10
                             z = x - 10
                             return z//y
                           end)
    func = eval(emit(pfunc))
    @fact isgeneric(func) => false
    @fact func(100) => 9//11
  end
end

###############################################################################
###############################################################################

facts("MetaTools.ParsedFunction->MetaTools.emit->MetaTools.ParsedFunction roundtrip tests") do
  context("Empty method with no args") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello() end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with no args and bracketed name") do
    func = ParsedFunction(emit(ParsedFunction(:(function (hello)() end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with one untyped arg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty method with two untyped args") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x,y) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty method with one typed arg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x::Integer) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty method with two typed args") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x::Integer, y::FloatingPoint) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty method with one union typed arg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x::Union(Integer,FloatingPoint)) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty method with one untyped default arg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x=100) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
  end

  context("Empty method with two untyped default args") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x=100,y=200) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact func.args[2].default => 200
  end

  context("Empty method with one typed default arg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x::Integer=100) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
  end

  context("Empty method with two typed default args") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x::Integer=100, y::FloatingPoint=200.0) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact func.args[2].default => 200.0
  end

  context("Empty method with one untyped vararg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x...) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty method with one typed vararg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x::Integer...) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty method with one untyped default vararg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x...=100) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact func.args[1].default => 100
  end

  context("Empty method with one typed default vararg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x::Integer...=100) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact func.args[1].default => 100
  end

  context("Empty method with one untyped kwarg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(;x=100) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty method with two untyped kwargs") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(;x=100,y=200) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 2
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :y
    @fact func.kwargs[2].typ => :Any
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200
  end

  context("Empty method with one typed kwarg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(;x::Integer=100) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty method with two typed kwargs") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(;x::Integer=100, y::FloatingPoint=200.0) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 2
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :y
    @fact func.kwargs[2].typ => :FloatingPoint
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200.0
  end

  context("Empty method with one union typed kwarg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(;x::Union(Integer, FloatingPoint)=100) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty method with one untyped varkwarg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(;x...) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => true
    @fact isdefined(func.kwargs[1], :default) => false
  end

  context("Empty method with one typed varkwarg") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(;x::Integer...) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => true
    @fact isdefined(func.kwargs[1], :default) => false
  end

  context("Empty method with a mix of args and kwargs") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello(x,y::Integer,z=99,rest...;a::Integer=100,b=200,c...) end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.body => quote end

    @fact length(func.args) => 4
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Integer
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
    @fact func.args[3].name => :z
    @fact func.args[3].typ => :Any
    @fact func.args[3].varargs => false
    @fact func.args[3].default => 99
    @fact func.args[4].name => :rest
    @fact func.args[4].typ => :Any
    @fact func.args[4].varargs => true
    @fact isdefined(func.args[4], :default) => false

    @fact length(func.kwargs) => 3
    @fact func.kwargs[1].name => :a
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :b
    @fact func.kwargs[2].typ => :Any
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200
    @fact func.kwargs[3].name => :c
    @fact func.kwargs[3].typ => :Any
    @fact func.kwargs[3].varargs => true
    @fact isdefined(func.kwargs[3], :default) => false
  end

  context("Empty method with namespace 1 deep") do
    func = ParsedFunction(emit(ParsedFunction(:(function MetaTestModule1.hello() end))))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with namespace 2 deep") do
    func = ParsedFunction(emit(ParsedFunction(:(function MetaTestModule1.MetaTestModule2.hello() end))))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with namespace 3 deep") do
    func = ParsedFunction(emit(ParsedFunction(:(function MetaTestModule1.MetaTestModule2.MetaTestModule3.hello() end))))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2, :MetaTestModule3]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with no type parameter") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello() end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with one type parameter") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello{T}() end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact func.types => [:T]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with two type parameters") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello{T1, T2}() end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact func.types => [:T1, :T2]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty method with namespace 3 deep and a type parameter") do
    func = ParsedFunction(emit(ParsedFunction(:(function MetaTestModule1.MetaTestModule2.MetaTestModule3.hello{T}() end))))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2, :MetaTestModule3]
    @fact func.types => [:T]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  #############################################################################

  context("Empty shorthand method with no args") do
    func = ParsedFunction(emit(ParsedFunction(:(hello() = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with no args and bracketed name") do
    func = ParsedFunction(emit(ParsedFunction(:((hello)() = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with one untyped arg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty shorthand method with two untyped args") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x,y) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty shorthand method with one typed arg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x::Integer) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty shorthand method with two typed args") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x::Integer, y::FloatingPoint) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty shorthand method with one union typed arg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x::Union(Integer,FloatingPoint)) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty shorthand method with one untyped default arg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x=100) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
  end

  context("Empty shorthand method with two untyped default args") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x=100,y=200) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact func.args[2].default => 200
  end

  context("Empty shorthand method with one typed default arg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x::Integer=100) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
  end

  context("Empty shorthand method with two typed default args") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x::Integer=100, y::FloatingPoint=200.0) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact func.args[1].default => 100
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact func.args[2].default => 200.0
  end

  context("Empty shorthand method with one untyped vararg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x...) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty shorthand method with one typed vararg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x::Integer...) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty shorthand method with one untyped default vararg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x...=100) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact func.args[1].default => 100
  end

  context("Empty shorthand method with one typed default vararg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x::Integer...=100) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact func.args[1].default => 100
  end

  context("Empty shorthand method with one untyped kwarg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(;x=100) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty shorthand method with two untyped kwargs") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(;x=100,y=200) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 2
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :y
    @fact func.kwargs[2].typ => :Any
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200
  end

  context("Empty shorthand method with one typed kwarg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(;x::Integer=100) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty shorthand method with two typed kwargs") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(;x::Integer=100, y::FloatingPoint=200.0) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 2
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :y
    @fact func.kwargs[2].typ => :FloatingPoint
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200.0
  end

  context("Empty shorthand method with one union typed kwarg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(;x::Union(Integer, FloatingPoint)=100) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
  end

  context("Empty shorthand method with one untyped varkwarg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(;x...) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Any
    @fact func.kwargs[1].varargs => true
    @fact isdefined(func.kwargs[1], :default) => false
  end

  context("Empty shorthand method with one typed varkwarg") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(;x::Integer...) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.args => []
    @fact func.body => quote end

    @fact length(func.kwargs) => 1
    @fact func.kwargs[1].name => :x
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => true
    @fact isdefined(func.kwargs[1], :default) => false
  end

  context("Empty shorthand method with a mix of args and kwargs") do
    func = ParsedFunction(emit(ParsedFunction(:(hello(x,y::Integer,z=99,rest...;a::Integer=100,b=200,c...) = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact func.body => quote end

    @fact length(func.args) => 4
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Integer
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
    @fact func.args[3].name => :z
    @fact func.args[3].typ => :Any
    @fact func.args[3].varargs => false
    @fact func.args[3].default => 99
    @fact func.args[4].name => :rest
    @fact func.args[4].typ => :Any
    @fact func.args[4].varargs => true
    @fact isdefined(func.args[4], :default) => false

    @fact length(func.kwargs) => 3
    @fact func.kwargs[1].name => :a
    @fact func.kwargs[1].typ => :Integer
    @fact func.kwargs[1].varargs => false
    @fact func.kwargs[1].default => 100
    @fact func.kwargs[2].name => :b
    @fact func.kwargs[2].typ => :Any
    @fact func.kwargs[2].varargs => false
    @fact func.kwargs[2].default => 200
    @fact func.kwargs[3].name => :c
    @fact func.kwargs[3].typ => :Any
    @fact func.kwargs[3].varargs => true
    @fact isdefined(func.kwargs[3], :default) => false
  end

  context("Empty shorthand method with namespace 1 deep") do
    func = ParsedFunction(emit(ParsedFunction(:(MetaTestModule1.hello() = begin end))))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with namespace 2 deep") do
    func = ParsedFunction(emit(ParsedFunction(:(MetaTestModule1.MetaTestModule2.hello() = begin end))))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with namespace 3 deep") do
    func = ParsedFunction(emit(ParsedFunction(:(MetaTestModule1.MetaTestModule2.MetaTestModule3.hello() = begin end))))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2, :MetaTestModule3]
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with no type parameter") do
    func = ParsedFunction(emit(ParsedFunction(:(hello() = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with one type parameter") do
    func = ParsedFunction(emit(ParsedFunction(:(hello{T}() = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact func.types => [:T]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with two type parameters") do
    func = ParsedFunction(emit(ParsedFunction(:(hello{T1, T2}() = begin end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact func.types => [:T1, :T2]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty shorthand method with namespace 3 deep and a type parameter") do
    func = ParsedFunction(emit(ParsedFunction(:(MetaTestModule1.MetaTestModule2.MetaTestModule3.hello{T}() = begin end))))
    @fact func.name => :hello
    @fact func.namespace => [:MetaTestModule1, :MetaTestModule2, :MetaTestModule3]
    @fact func.types => [:T]
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  #############################################################################

  context("Empty lambda with no args") do
    func = ParsedFunction(emit(ParsedFunction(:(() -> begin end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty lambda with one untyped arg") do
    func = ParsedFunction(emit(ParsedFunction(:((x) -> begin end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty lambda with two untyped args") do
    func = ParsedFunction(emit(ParsedFunction(:((x,y) -> begin end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty lambda with one typed arg") do
    func = ParsedFunction(emit(ParsedFunction(:((x::Integer) -> begin end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty lambda with two typed args") do
    func = ParsedFunction(emit(ParsedFunction(:((x::Integer, y::FloatingPoint) -> begin end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty lambda with one union typed arg") do
    func = ParsedFunction(emit(ParsedFunction(:((x::Union(Integer,FloatingPoint)) -> begin end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty lambda with one untyped vararg") do
    func = ParsedFunction(emit(ParsedFunction(:((x...) -> begin end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty lambda with one typed vararg") do
    func = ParsedFunction(emit(ParsedFunction(:((x::Integer...) -> begin end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty lambda with a mix of args") do
    func = ParsedFunction(emit(ParsedFunction(:((x,y::Integer,z...) -> begin end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact func.body => quote end

    @fact length(func.args) => 3
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Integer
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
    @fact func.args[3].name => :z
    @fact func.args[3].typ => :Any
    @fact func.args[3].varargs => true
    @fact isdefined(func.args[3], :default) => false

    @fact isdefined(func, :kwargs) => false
  end

  #############################################################################

  context("Empty anonymous function with no args") do
    func = ParsedFunction(emit(ParsedFunction(:(function() end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end
    @fact func.args => []
  end

  context("Empty anonymous function with one untyped arg") do
    func = ParsedFunction(emit(ParsedFunction(:(function(x) end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty anonymous function with two untyped args") do
    func = ParsedFunction(emit(ParsedFunction(:(function(x,y) end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Any
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty anonymous function with one typed arg") do
    func = ParsedFunction(emit(ParsedFunction(:(function(x::Integer) end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty anonymous function with two typed args") do
    func = ParsedFunction(emit(ParsedFunction(:(function(x::Integer, y::FloatingPoint) end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 2
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :FloatingPoint
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
  end

  context("Empty anonymous function with one union typed arg") do
    func = ParsedFunction(emit(ParsedFunction(:(function(x::Union(Integer,FloatingPoint)) end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :(Union(Integer, FloatingPoint))
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty anonymous function with one untyped vararg") do
    func = ParsedFunction(emit(ParsedFunction(:(function(x...) end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty anonymous function with one typed vararg") do
    func = ParsedFunction(emit(ParsedFunction(:(function(x::Integer...) end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => quote end

    @fact length(func.args) => 1
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Integer
    @fact func.args[1].varargs => true
    @fact isdefined(func.args[1], :default) => false
  end

  context("Empty anonymous function with a mix of args") do
    func = ParsedFunction(emit(ParsedFunction(:(function(x,y::Integer,z...) end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact func.body => quote end

    @fact length(func.args) => 3
    @fact func.args[1].name => :x
    @fact func.args[1].typ => :Any
    @fact func.args[1].varargs => false
    @fact isdefined(func.args[1], :default) => false
    @fact func.args[2].name => :y
    @fact func.args[2].typ => :Integer
    @fact func.args[2].varargs => false
    @fact isdefined(func.args[2], :default) => false
    @fact func.args[3].name => :z
    @fact func.args[3].typ => :Any
    @fact func.args[3].varargs => true
    @fact isdefined(func.args[3], :default) => false

    @fact isdefined(func, :kwargs) => false
  end

  #############################################################################

  context("Method with a numeric literal body") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello() 10 end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, 10)
    @fact func.args => []
  end

  context("Shorthand method with a numeric literal body") do
    func = ParsedFunction(emit(ParsedFunction(:(hello() = 10))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, 10)
    @fact func.args => []
  end

  context("Lambda with a numeric literal body") do
    func = ParsedFunction(emit(ParsedFunction(:(() -> 10))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, 10)
    @fact func.args => []
  end

  context("Anonymous function with a numeric literal body") do
    func = ParsedFunction(emit(ParsedFunction(:(function() 10 end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, 10)
    @fact func.args => []
  end

  #----------------------------------------------------------------------------

  context("Method with a symbol body") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello() x end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, :x)
    @fact func.args => []
  end

  context("Shorthand method with a symbol body") do
    func = ParsedFunction(emit(ParsedFunction(:(hello() = x))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, :x)
    @fact func.args => []
  end

  context("Lambda with a symbol body") do
    func = ParsedFunction(emit(ParsedFunction(:(() -> x))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, :x)
    @fact func.args => []
  end

  context("Anonymous function with a symbol body") do
    func = ParsedFunction(emit(ParsedFunction(:(function() x end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, :x)
    @fact func.args => []
  end

  #----------------------------------------------------------------------------

  context("Method with a expression body") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello() x + 10 end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, Expr(:call, :+, :x, 10))
    @fact func.args => []
  end

  context("Shorthand method with a expression body") do
    func = ParsedFunction(emit(ParsedFunction(:(hello() = x + 10))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:call, :+, :x, 10)
    @fact func.args => []
  end

  context("Lambda with a expression body") do
    func = ParsedFunction(emit(ParsedFunction(:(() -> x + 10))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, Expr(:call, :+, :x, 10))
    @fact func.args => []
  end

  context("Anonymous function with a expression body") do
    func = ParsedFunction(emit(ParsedFunction(:(function() x + 10 end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block, ANY_LINE_NUMBER, Expr(:call, :+, :x, 10))
    @fact func.args => []
  end

  #----------------------------------------------------------------------------

  context("Method with a multiline body") do
    func = ParsedFunction(emit(ParsedFunction(:(function hello()
                              y = x + 10
                              y += some_func(z)
                              return y
                            end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            ANY_LINE_NUMBER,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            ANY_LINE_NUMBER,
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            ANY_LINE_NUMBER,
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end

  context("Shorthand method with a multiline body with begin end") do
    func = ParsedFunction(emit(ParsedFunction(:(hello() = begin
                              y = x + 10
                              y += some_func(z)
                              return y
                            end))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            ANY_LINE_NUMBER,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            ANY_LINE_NUMBER,
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            ANY_LINE_NUMBER,
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end

  context("Shorthand method with a multiline body with brackets") do
    func = ParsedFunction(emit(ParsedFunction(:(hello() = (y = x + 10;
                                       y += some_func(z);
                                       return y)))))
    @fact func.name => :hello
    @fact isdefined(func, :namespace) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end

  context("Lambda with a multiline body with begin end") do
    func = ParsedFunction(emit(ParsedFunction(:(() -> begin
                              y = x + 10
                              y += some_func(z)
                              return y
                            end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            ANY_LINE_NUMBER,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            ANY_LINE_NUMBER,
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            ANY_LINE_NUMBER,
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end

  context("Lambda with a multiline body with brackets") do
    func = ParsedFunction(emit(ParsedFunction(:(() -> (y = x + 10;
                                   y += some_func(z);
                                   return y)))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end

  context("Anonymous function with a multiline body") do
    func = ParsedFunction(emit(ParsedFunction(:(function()
                              y = x + 10
                              y += some_func(z)
                              return y
                            end))))
    @fact isdefined(func, :name) => false
    @fact isdefined(func, :types) => false
    @fact isdefined(func, :kwargs) => false
    @fact func.body => Expr(:block,
                            ANY_LINE_NUMBER,
                            Expr(:(=), :y, Expr(:call, :+, :x, 10)),
                            ANY_LINE_NUMBER,
                            Expr(:(+=), :y, Expr(:call, :some_func, :z)),
                            ANY_LINE_NUMBER,
                            Expr(:return, :y),
                            )
    @fact func.args => []
  end
end

###############################################################################
###############################################################################

facts("MetaTools.emit->MetaTools.ParsedFunction->MetaTools.emit roundtrip tests") do
  context("Empty method with no args") do
    pfunc = ParsedFunction(name=:hello1)
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello1
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  context("Empty method with one untyped arg") do
    pfunc = ParsedFunction(name=:hello2,
                           args=[ParsedArgument(:x)])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello2
    @fact func.env.max_args => 1
    @fact func(10) => nothing
  end

  context("Empty method with two untyped args") do
    pfunc = ParsedFunction(name=:hello3,
                           args=[ParsedArgument(:x),
                                 ParsedArgument(:y)])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello3
    @fact func.env.max_args => 2
    @fact func(10, 20) => nothing
  end

  context("Empty method with one typed arg") do
    pfunc = ParsedFunction(name=:hello4,
                           args=[ParsedArgument(:(x::Integer))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello4
    @fact func.env.max_args => 1
    @fact func(10) => nothing
  end

  context("Empty method with two typed args") do
    pfunc = ParsedFunction(name=:hello5,
                           args=[ParsedArgument(:(x::Integer)),
                                 ParsedArgument(:(y::Integer))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello5
    @fact func.env.max_args => 2
    @fact func(10, 20) => nothing
  end

  context("Empty method with one union typed arg") do
    pfunc = ParsedFunction(name=:hello6,
                           args=[ParsedArgument(:(x::Union(FloatingPoint, Integer)))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello6
    @fact func.env.max_args => 1
    @fact func(10) => nothing
  end

  context("Empty method with one untyped default arg") do
    pfunc = ParsedFunction(name=:hello7,
                           args=[ParsedArgument(:(x=100))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello7
    @fact func.env.max_args => 1
    @fact func() => nothing
    @fact func(100) => nothing
  end

  context("Empty method with two untyped default args") do
    pfunc = ParsedFunction(name=:hello8,
                           args=[ParsedArgument(:(x=100)),
                                 ParsedArgument(:(y=100))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello8
    @fact func.env.max_args => 2
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
  end

  context("Empty method with one typed default arg") do
    pfunc = ParsedFunction(name=:hello9,
                           args=[ParsedArgument(:(x::Integer=100))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello9
    @fact func.env.max_args => 1
    @fact func() => nothing
    @fact func(100) => nothing
  end

  context("Empty method with two typed default args") do
    pfunc = ParsedFunction(name=:hello10,
                           args=[ParsedArgument(:(x::Integer=100)),
                                 ParsedArgument(:(y::Integer=100))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello10
    @fact func.env.max_args => 2
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
  end

  context("Empty method with one untyped vararg") do
    pfunc = ParsedFunction(name=:hello11,
                           args=[ParsedArgument(:(x...))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello11
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty method with one typed vararg") do
    pfunc = ParsedFunction(name=:hello12,
                           args=[ParsedArgument(:(x::Integer...))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello12
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty method with one untyped default vararg") do
    pfunc = ParsedFunction(name=:hello13,
                           args=[ParsedArgument(:(x...=1))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello13
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty method with one typed default vararg") do
    pfunc = ParsedFunction(name=:hello14,
                           args=[ParsedArgument(:(x::Integer...=1))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello14
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty method with one untyped kwarg") do
    pfunc = ParsedFunction(name=:hello15,
                           kwargs=[ParsedArgument(:(x=10))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello15
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
  end

  context("Empty method with two untyped kwargs") do
    pfunc = ParsedFunction(name=:hello16,
                           kwargs=[ParsedArgument(:(x=10)),
                                   ParsedArgument(:(y=20))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello16
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
    @fact func(y=200) => nothing
    @fact func(x=100, y=200) => nothing
  end

  context("Empty method with one typed kwarg") do
    pfunc = ParsedFunction(name=:hello17,
                           kwargs=[ParsedArgument(:(x::Integer=10))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello17
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
  end

  context("Empty method with two typed kwargs") do
    pfunc = ParsedFunction(name=:hello18,
                           kwargs=[ParsedArgument(:(x::Integer=10)),
                                   ParsedArgument(:(y::Integer=20))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello18
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
    @fact func(y=200) => nothing
    @fact func(x=100, y=200) => nothing
  end

  context("Empty method with one union typed kwarg") do
    pfunc = ParsedFunction(name=:hello19,
                           kwargs=[ParsedArgument(:(x::Union(FloatingPoint, Integer)=10))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello19
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
  end

  context("Empty method with one untyped varkwarg") do
    pfunc = ParsedFunction(name=:hello20,
                           kwargs=[ParsedArgument(:(x...))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello20
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
    @fact func(y=200) => nothing
    @fact func(x=100, y=200) => nothing
  end

  context("Empty method with one typed varkwarg") do
    pfunc = ParsedFunction(name=:hello21,
                           kwargs=[ParsedArgument(:(x::Array...))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello21
    @fact func.env.max_args => 0
    @fact func() => nothing
    @fact func(x=100) => nothing
    @fact func(y=200) => nothing
    @fact func(x=100, y=200) => nothing
  end

  context("Empty method with a mix of args and kwargs") do
    pfunc = ParsedFunction(name=:hello22,
                           args=[ParsedArgument(:x),
                                 ParsedArgument(:(y::Integer)),
                                 ParsedArgument(:(z=99))],
                           kwargs=[ParsedArgument(:(a::Integer=100)),
                                   ParsedArgument(:(b=200)),
                                   ParsedArgument(:(c...))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello22
    @fact func.env.max_args => 3
    @fact func(10, 20) => nothing
    @fact func(10, 20, 30) => nothing
    @fact func(10, 20, a=99) => nothing
    @fact func(10, 20, 30, b=99, foobar=100) => nothing
  end

  context("Empty method with namespace 1 deep") do
    pfunc = ParsedFunction(name=:hello,
                           namespace=[:MetaTestModule1])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact (func === MetaTestModule1.hello) => true
    @fact isgeneric(func) => true
    @fact func.env.name => :hello
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  context("Empty method with namespace 2 deep") do
    pfunc = ParsedFunction(name=:hello,
                           namespace=[:MetaTestModule1, :MetaTestModule2])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact (func === MetaTestModule1.MetaTestModule2.hello) => true
    @fact isgeneric(func) => true
    @fact func.env.name => :hello
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  context("Empty method with namespace 3 deep") do
    pfunc = ParsedFunction(name=:hello,
                           namespace=[:MetaTestModule1, :MetaTestModule2, :MetaTestModule3])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact (func === MetaTestModule1.MetaTestModule2.MetaTestModule3.hello) => true
    @fact isgeneric(func) => true
    @fact func.env.name => :hello
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  context("Empty method with no type parameter") do
    pfunc = ParsedFunction(name=:hello23,
                           types=Symbol[])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello23
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  context("Empty method with one type parameter") do
    pfunc = ParsedFunction(name=:hello24,
                           types=[:T],
                           args=[ParsedArgument(:(x::T))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello24
    @fact func.env.max_args => 1
    @fact func(10) => nothing
  end

  context("Empty method with two type parameters") do
    pfunc = ParsedFunction(name=:hello25,
                           types=[:T1, :T2],
                           args=[ParsedArgument(:(x::T1)),
                                 ParsedArgument(:(y::T2))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello25
    @fact func.env.max_args => 2
    @fact func(10, 20) => nothing
  end

  context("Empty method with namespace 3 deep and one type parameter") do
    pfunc = ParsedFunction(name=:hello,
                           types=[:T],
                           namespace=[:MetaTestModule1, :MetaTestModule2, :MetaTestModule3])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact (func === MetaTestModule1.MetaTestModule2.MetaTestModule3.hello) => true
    @fact isgeneric(func) => true
    @fact func.env.name => :hello
    @fact func.env.max_args => 0
    @fact func() => nothing
  end

  #############################################################################

  context("Empty anonymous function with no args") do
    pfunc = ParsedFunction()
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact func() => nothing
  end

  context("Empty anonymous function with one untyped arg") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x)])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact func(10) => nothing
  end

  context("Empty anonymous function with two untyped args") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x),
                                 ParsedArgument(:y)])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func(10, 20) => nothing
  end

  context("Empty anonymous function with one typed arg") do
    pfunc = ParsedFunction(args=[ParsedArgument(:(x::Integer))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func(10) => nothing
  end

  context("Empty anonymous function with two typed args") do
    pfunc = ParsedFunction(args=[ParsedArgument(:(x::Integer)),
                                 ParsedArgument(:(y::Integer))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func(10, 20) => nothing
  end

  context("Empty anonymous function with one union typed arg") do
    pfunc = ParsedFunction(args=[ParsedArgument(:(x::Union(FloatingPoint, Integer)))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func(10) => nothing
  end

  context("Empty anonymous function with one untyped vararg") do
    pfunc = ParsedFunction(args=[ParsedArgument(:(x...))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty anonymous function with one typed vararg") do
    pfunc = ParsedFunction(args=[ParsedArgument(:(x::Integer...))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func() => nothing
    @fact func(100) => nothing
    @fact func(100, 200) => nothing
    @fact func(100, 200, 300) => nothing
  end

  context("Empty anonymous function with a mix of args") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x),
                                 ParsedArgument(:(y::Integer)),
                                 ParsedArgument(:(z...))])
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func(10, 20) => nothing
    @fact func(10, 20, 30) => nothing
    @fact func(10, 20, 30, 40) => nothing
  end


  #############################################################################

  context("Method with a numeric literal body") do
    pfunc = ParsedFunction(name=:hello100,
                           body=Expr(:block, 10))
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello100
    @fact func.env.max_args => 0
    @fact func() => 10
  end

  context("Anonymous function with a numeric literal body") do
    pfunc = ParsedFunction(body=Expr(:block, 10))
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func() => 10
  end
  #----------------------------------------------------------------------------

  context("Method with a symbol body") do
    pfunc = ParsedFunction(name=:hello101,
                           args=[ParsedArgument(:x)],
                           body=Expr(:block, :x))
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello101
    @fact func.env.max_args => 1
    @fact func(10) => 10
    @fact func(100) => 100
  end

  context("Anonymous function with a symbol body") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x)],
                           body=Expr(:block, :x))
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func(10) => 10
    @fact func(100) => 100
  end
  #----------------------------------------------------------------------------

  context("Method with a expression body") do
    pfunc = ParsedFunction(name=:hello102,
                           args=[ParsedArgument(:x)],
                           body=:(x + 10))
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello102
    @fact func.env.max_args => 1
    @fact func(10) => 20
    @fact func(100) => 110
  end

  context("Anonymous function with a expression body") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x)],
                           body=:(x + 10))
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func(10) => 20
    @fact func(100) => 110
  end
  #----------------------------------------------------------------------------

  context("Method with a multiline body") do
    pfunc = ParsedFunction(name=:hello103,
                           args=[ParsedArgument(:x)],
                           body=quote
                             y = x + 10
                             z = x - 10
                             return z//y
                           end)
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => true
    @fact func.env.name => :hello103
    @fact func.env.max_args => 1
    @fact func(100) => 9//11
  end

  context("Anonymous function with a multiline body") do
    pfunc = ParsedFunction(args=[ParsedArgument(:x)],
                           body=quote
                             y = x + 10
                             z = x - 10
                             return z//y
                           end)
    func = eval(emit(ParsedFunction(emit(pfunc))))
    @fact isgeneric(func) => false
    @fact func(100) => 9//11
  end
end

###############################################################################
###############################################################################

facts("MetaTools.@commutative tests") do
  context("@commutative method") do
    @commutative function foo(s::String, i::Integer)
      return "$s -> $i"
    end

    @fact length(methods(foo)) => 2
    @fact foo("hello", 42) => "hello -> 42"
    @fact foo(42, "hello") => "hello -> 42"
  end

  context("@commutative with wrong type of function") do
    @fact_throws eval(:(@commutative function foo(s::String) end))
    @fact_throws eval(:(@commutative function foo(s1::String, s2::String) end))
    @fact_throws eval(:(@commutative function foo(s::String, i::Integer...) end))
    @fact_throws eval(:(@commutative function foo(s::String, i::Integer=10) end))
    @fact_throws eval(:(@commutative function foo(s1::String, s2::Integer, s3::FloatingPoint) end))
    @fact_throws eval(:(@commutative function foo(s::String, i::Integer; special=false) end))
    @fact_throws eval(:(@commutative function(s::String, i::Integer) end))
    @fact_throws eval(:(@commutative (s::String, i::Integer) -> begin end))
  end

  context("@commutative shorthand method") do
    @commutative bar(s::String, i::Integer) = "$s -> $i"

    @fact length(methods(bar)) => 2
    @fact bar("hello", 42) => "hello -> 42"
    @fact bar(42, "hello") => "hello -> 42"
  end

  context("@commutative method in namespace") do
    @commutative function MetaTestModule1.baz(s::String, i::Integer)
      return "$s -> $i"
    end

    @fact MetaTestModule1.baz("hello", 42) => "hello -> 42"
    @fact MetaTestModule1.baz(42, "hello") => "hello -> 42"
  end

  context("@commutative shorthand method in namespace") do
    @commutative MetaTestModule1.boo(s::String, i::Integer) = "$s -> $i"

    @fact MetaTestModule1.boo("hello", 42) => "hello -> 42"
    @fact MetaTestModule1.boo(42, "hello") => "hello -> 42"
  end

  context("@commutative method with an Any arg makes 3 methods") do
    @commutative function hmmm(a::Any, s::String)
      return "$s -> $a"
    end

    @fact length(methods(hmmm)) => 3
    @fact hmmm("hello", "world") => "hello -> world"
    @fact hmmm("hello", 42) => "hello -> 42"
    @fact hmmm(42, "hello") => "hello -> 42"
  end
end

end