$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'bool'
require 'minitest/autorun'

describe 'Bool' do

  describe "AND expression" do
    before do
      @ast = Bool.parse("a && b")
    end

    it "is false when one operand is false" do
      @ast.accept(Bool::EvalVisitor.new, ["a"]).must_equal(false)
    end

    it "is true when both operands are true" do
      @ast.accept(Bool::EvalVisitor.new, ["a", "b"]).must_equal(true)
    end
  end

  describe "OR expression" do
    before do
      @ast = Bool.parse("a || b")
    end

    it "is true when one operand is false" do
      @ast.accept(Bool::EvalVisitor.new, ["a"]).must_equal(true)
    end

    it "is false when both operands are false" do
      @ast.accept(Bool::EvalVisitor.new, []).must_equal(false)
    end
  end

  describe "NOT expression" do
    before do
      @ast = Bool.parse("!a")
    end

    it "is true when operand is false" do
      @ast.accept(Bool::EvalVisitor.new, []).must_equal(true)
    end

    it "is false when operand is true" do
      @ast.accept(Bool::EvalVisitor.new, ["a"]).must_equal(false)
    end
  end

  describe "SyntaxError" do
    it 'is raised on scanner error' do
      begin
        Bool.parse(        # line,token_start_col
          "          \n" + # 1
          "          \n" + # 2
          "  a       \n" + # 3,3
          "    ?     \n"   # 4,5
        )
        fail
      rescue Bool::SyntaxError => expected
        expected.line.must_equal 4
        expected.column.must_equal 5
        expected.message.must_equal "Unexpected character: ?"
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
        else
          expected.message.must_equal "syntax error, unexpected $end, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN"
        end
        expected.line.must_equal 6
        expected.column.must_equal 11
      end
    end

  end
end
