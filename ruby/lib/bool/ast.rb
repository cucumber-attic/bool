module Bool
  if RUBY_PLATFORM =~ /java/
    # AST classes defined in bool_ext.jar (bool-jvm)
  else
    class Var
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def accept(visitor, arg)
        visitor.visit_var(self, arg)
      end
    end

    class Binary
      attr_reader :left, :right

      def initialize(left, right)
        @left, @right = left, right
      end
    end

    class And < Binary
      def accept(visitor, arg)
        visitor.visit_and(self, arg)
      end
    end

    class Or < Binary
      def accept(visitor, arg)
        visitor.visit_or(self, arg)
      end
    end

    class Unary
      attr_reader :node

      def initialize(node)
        @node = node
      end
    end

    class Not < Unary
      def initialize(node)
        @node = node
      end

      def accept(visitor, arg)
        visitor.visit_not(self, arg)
      end
    end
  end
end