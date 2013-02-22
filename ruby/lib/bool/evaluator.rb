module Bool
  class Evaluator
    if RUBY_PLATFORM =~ /java/
      require 'bool_ext'

      def self.new
        Java::Bool::Evaluator.new
      end

    else
      def walk_var(node, vars)
        !!vars.index(node.name)
      end

      def walk_and(node, vars)
        evaluate(node.left, vars) && evaluate(node.right, vars)
      end

      def walk_or(node, vars)
        evaluate(node.left, vars) || evaluate(node.right, vars)
      end

      def walk_not(node, vars)
        !evaluate(node.other, vars)
      end

      private

      def evaluate(node, vars)
        node.walk_with(self, vars)
      end
    end
  end
end

