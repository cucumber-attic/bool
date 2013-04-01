$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'bool'
require 'minitest/autorun'

describe 'Bool' do

  def evaluate(vars)
    ast.accept(Bool::Evaluator.new, vars)
  end

  def renderer
    ast.accept(Bool::Renderer.new, nil)
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

 describe "AND OR expression" do
    let(:expression) { "a && b || c" } # (a && b) || c

    it "is true when a and b are true" do
      evaluate(['a', 'b']).must_equal(true)
    end

    it "is true when a and c are true" do
      evaluate(['a', 'c']).must_equal(true)
    end
  end

  describe "OR AND expression" do
    let(:expression) { "c || a && b" } # c || (a && b)
    
    it "is true when a and b are true" do
      evaluate(['a', 'b']).must_equal(true)
    end

    it "is true when a and c are true" do
      evaluate(['a', 'c']).must_equal(true)
    end
  end


  describe "AND OR expression tested by rendering explicitly" do
    let(:expression) { "a && b || c" } # (a && b) || c

    it "expression should be equivalent to its explicit rendering" do
      renderer.must_equal "((a && b) || c)"
    end
  end

  describe "OR AND expression tested by rendering explicitly" do
    let(:expression) { "c || a && b" } # c || (a && b)
    
    it "expression should be equivalent to its explicit rendering" do
      renderer.must_equal "(c || (a && b))"
    end
  end


  describe "not expression tested by rendering explicitly" do
    let(:expression) { "!(c || a && !b)" } # c || (a && b)
    
    it "expression should be equivalent to its explicit rendering" do
      renderer.must_equal "!(c || (a && !b))"
    end
  end

  describe "SyntaxError" do
    it 'is raised on scanner error' do
      begin
        Bool.parse(        # line,token_start_col
          "          \n" + # 1
          "          \n" + # 2
          "          \n" + # 3
          "    ^^    \n"   # 4,5
          #123456789
        )
        fail
      rescue Bool::SyntaxError => expected
        expected.message.must_equal "syntax error: ^^    \n"
        expected.first_line.must_equal 4
        expected.last_line.must_equal 4
        expected.first_column.must_equal 5
        expected.last_column.must_equal 5
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
          #0123456789
        )
        fail
      rescue Bool::SyntaxError => expected
        expected.first_line.must_equal 6
        if RUBY_PLATFORM =~ /java/
          expected.message.must_equal "syntax error, unexpected end of input, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN"
        else
          expected.message.must_equal "syntax error, unexpected $end, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN"
        end
      end
    end

  end
end
