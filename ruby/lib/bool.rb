# This loads either bool_ext.so, bool_ext.bundle or
# bool_ext.jar, depending on your Ruby platform and OS
require 'bool_ext'
require 'bool/ast'
require 'bool/evaluator'

module Bool
  class SyntaxError < StandardError
    attr_reader :first_line, :last_line, :first_column, :last_column

    def initialize(message, first_line, last_line, first_column, last_column)
      super(message)
      @first_line, @last_line, @first_column, @last_column = first_line, last_line, first_column, last_column
    end
  end

  if RUBY_PLATFORM =~ /java/
    def parse(source)
      lexer = Java::Bool::Lexer.new(source)
      parser = Java::Bool::Parser.new(lexer)
      parser.parseExpr()
    rescue => e
      raise SyntaxError.new(e.message, e.line, e.line, e.column, e.column)
    end
    module_function(:parse)
  else
    # parse is defined in ruby_bool.c
  end
end
