module Bool
  if RUBY_PLATFORM =~ /java/
    # AST classes defined in bool_ext.jar
  else
    class Var
      attr_reader :value

      def initialize(value)
        puts "VAR:#{value}"
        @value = value
      end

      def accept(visitor, arg)
        visitor.visit_var(self, arg)
      end
    end

    class And
      attr_reader :value, :left, :right

      def initialize(value, left, right)
        puts "AND:#{value}"
        @value, @left, @right = value, left, right
      end

      def accept(visitor, arg)
        visitor.visit_and(self, arg)
      end
    end

    class Or
      attr_reader :value, :left, :right

      def initialize(value, left, right)
        puts "OR:#{value}"
        @value, @left, @right = value, left, right
      end

      def accept(visitor, arg)
        visitor.visit_or(self, arg)
      end
    end

    class Not
      attr_reader :value, :operand

      def initialize(value, operand)
        puts "NOT:#{value}"
        @value, @operand = value, operand
      end

      def accept(visitor, arg)
        visitor.visit_not(self, arg)
      end
    end
  end
end
