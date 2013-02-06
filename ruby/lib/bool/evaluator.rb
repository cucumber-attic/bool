module Bool
  class Evaluator
    if RUBY_PLATFORM =~ /java/
      require 'libbool'

      def self.new
        Java::Bool::Evaluator.new
      end

    else
      def var(node, vars)
        !!vars.index(node.name)
      end

      def and(node, vars)
        evaluate(node.left, vars) && evaluate(node.right, vars)
      end

      def or(node, vars)
        evaluate(node.left, vars) || evaluate(node.right, vars)
      end

      def not(node, vars)
        !evaluate(node.other, vars)
      end

      private

      def evaluate(node, vars)
        node.describe_to(self, vars)
      end
    end
  end
end

