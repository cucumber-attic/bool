module Bool
  if RUBY_PLATFORM =~ /java/
    # AST classes defined in bool_ext.jar
  else
    class Var
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def accept(visitor, arg)
        visitor.visit_var(self, arg)
      end
    end

    class And
      attr_reader :left, :right

      def initialize(left, right)
        @left, @right = left, right
      end

      def accept(visitor, arg)
        visitor.visit_and(self, arg)
      end
    end

    class Or
      attr_reader :left, :right

      def initialize(left, right)
        @left, @right = left, right
      end

      def accept(visitor, arg)
        visitor.visit_or(self, arg)
      end
    end

    class Not
      attr_reader :operand

      def initialize(operand)
        @operand = operand
      end

      def accept(visitor, arg)
        visitor.visit_not(self, arg)
      end
    end
  end
end
