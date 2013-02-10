$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'bool'
require 'minitest/autorun'

describe 'Bool' do

  def evaluate(vars)
    ast.describe_to(Bool::Evaluator.new, vars)
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

  describe "SyntaxError" do
    it 'is raised on scanner error' do
      begin
        Bool.parse(        # line,token_start_col
          "          \n" + # 1
          "          \n" + # 2
          "          \n" + # 3,3
          "    ^     \n"   # 4,5
        )
        fail
      rescue Bool::SyntaxError => expected
        expected.line.must_equal 4
        expected.column.must_equal 5
        expected.message.must_equal "Unexpected character: ^"
      end
    end

    it 'is raised on parse error' do
      begin
        Bool.parse(        # line,token_start_col
          "          \n" + # 1
          "          \n" + # 2
          "  a       \n" + # 3,3
          "    ||    \n" + # 4,5
          "      c   \n" + # 5,7
          "        &&"     # 6,9
        )
        fail
      rescue Bool::SyntaxError => expected
        if RUBY_PLATFORM =~ /java/
          expected.message.must_equal "syntax error, unexpected end of input, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN"
          expected.column.must_equal 11
        else
          expected.message.must_equal "syntax error, unexpected $end, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN"
          expected.column.must_equal 10
        end
        expected.line.must_equal 6
      end
    end

  end
end
