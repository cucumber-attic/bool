module Bool
  if RUBY_PLATFORM =~ /java/
    # AST classes defined in bool_ext.jar (bool-jvm)
  else
    class Var
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def describe_to(visitor, arg)
        visitor.visit_var(self, arg)
      end
    end

    class And
      attr_reader :left, :right

      def initialize(left, right)
        @left, @right = left, right
      end

      def describe_to(visitor, arg)
        visitor.visit_and(self, arg)
      end
    end

    class Or
      attr_reader :left, :right

      def initialize(left, right)
        @left, @right = left, right
      end

      def describe_to(visitor, arg)
        visitor.visit_or(self, arg)
      end
    end

    class Not
      attr_reader :other

      def initialize(other)
        @other = other
      end

      def describe_to(visitor, arg)
        visitor.visit_not(self, arg)
      end
    end
  end
end
