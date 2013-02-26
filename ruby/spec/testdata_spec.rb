$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'bool'
require 'minitest/autorun'

describe "Testdata" do
  Dir[File.dirname(__FILE__) + '/../../testdata/*.txt'].each do |f|
    expr, vars, result = IO.read(f).split(/\n/)
    it f do
      ast = Bool.parse(expr)
      ast.accept(Bool::Evaluator.new, vars.split(/\s+/)).to_s.must_equal(result)
    end
  end
end
