$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'bool'
require 'minitest/autorun'

describe 'Bool' do

  def evaluate(vars)
    ast.accept(Bool::EvalVisitor.new, vars)
  end
  let(:ast) { Bool.parse(expression) }
  let(:expression) { raise NotImplementedError }

  describe "AND expression" do
    let(:expression) { "a && b" }

    it "is false when one operand is false" do
      evaluate(["a"]).must_equal(false)
    end

    it "is true when both operands are true" do
      evaluate(["a", "b"]).must_equal(true)
    end
  end

  describe "OR expression" do
    let(:expression) { "a || b" }

    it "is true when one operand is false" do
      evaluate(["a"]).must_equal(true)
    end

    it "is false when both operands are false" do
      evaluate([]).must_equal(false)
    end
  end

  describe "NOT expression" do
    let(:expression) { "!a" }

    it "is true when operand is false" do
      evaluate([]).must_equal(true)
    end

    it "is false when operand is true" do
      evaluate(["a"]).must_equal(false)
    end
  end

  describe "Exception" do
    it 'is raised on parse error' do
      begin
        Bool.parse("a ||")
        fail
      rescue Bool::ParseError => expected
        expected.message.must_match /expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN/
      end
    end

    it 'is raised on lexing error' do
      begin
        Bool.parse("a ^ e")
        fail
      rescue Bool::ParseError => expected
        expected.message.must_match /syntax error, unexpected TOKEN_VAR, expecting \$end|Error: could not match input/
      end
    end
  end
end
