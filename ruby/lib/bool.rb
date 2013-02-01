# This loads either bool_ext.so, bool_ext.bundle or
# bool_ext.jar, depending on your Ruby platform and OS
require 'bool_ext'
require 'bool/ast'
require 'bool/eval_visitor'

module Bool
  class ParseError < StandardError
  end

  if RUBY_PLATFORM =~ /java/
    def parse(source)
      raise "HELLO TRAVIS"
      lexer = Java::Bool::Lexer.new(source)
      parser = Java::Bool::Parser.new(lexer)
      parser.parseExpr()
    rescue => e
      raise ParseError.new(e.message)
    end
    module_function(:parse)
  else
    # parse is defined in ruby_bool.c
  end
end
