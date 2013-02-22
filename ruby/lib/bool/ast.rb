module Bool
  if RUBY_PLATFORM =~ /java/
    # AST classes defined in bool_ext.jar
  else
    class Var
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def walk_with(walker, arg)
        walker.walk_var(self, arg)
      end
    end

    class And
      attr_reader :left, :right

      def initialize(left, right)
        @left, @right = left, right
      end

      def walk_with(walker, arg)
        walker.walk_and(self, arg)
      end
    end

    class Or
      attr_reader :left, :right

      def initialize(left, right)
        @left, @right = left, right
      end

      def walk_with(walker, arg)
        walker.walk_or(self, arg)
      end
    end

    class Not
      attr_reader :other

      def initialize(other)
        @other = other
      end

      def walk_with(walker, arg)
        walker.walk_not(self, arg)
      end
    end
  end
end
