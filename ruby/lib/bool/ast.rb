module Bool
  if RUBY_PLATFORM =~ /java/
    # AST classes defined in bool_ext.jar
  else
    class Token
      attr_reader :value

      def initialize(value)
        @value = value
      end
    end

    class Node
      attr_reader :token

      def initialize(token)
        @token = token
      end
    end

    class Var < Node
      def accept(visitor, arg)
        visitor.visit_var(self, arg)
      end
    end

    class And < Node
      attr_reader :left, :right

      def initialize(token, left, right)
        super(token)
        @left, @right = left, right
      end

      def accept(visitor, arg)
        visitor.visit_and(self, arg)
      end
    end

    class Or < Node
      attr_reader :left, :right

      def initialize(token, left, right)
        super(token)
        @left, @right = left, right
      end

      def accept(visitor, arg)
        visitor.visit_or(self, arg)
      end
    end

    class Not < Node
      attr_reader :operand

      def initialize(token, operand)
        super(token)
        @operand = operand
      end

      def accept(visitor, arg)
        visitor.visit_not(self, arg)
      end
    end
  end
end
