module Bool
  class Evaluator
    if RUBY_PLATFORM =~ /java/
      require 'libbool'

      def self.new
        Java::Bool::EvalVisitor.new
      end

    else
      def var(var_node, vars)
        !!vars.index(var_node.name)
      end

      def and(and_node, vars)
        evaluate(and_node.left, vars) && evaluate(and_node.right, vars)
      end

      def or(and_node, vars)
        evaluate(and_node.left, vars) || evaluate(and_node.right, vars)
      end

      def not(not_node, vars)
        !evaluate(not_node.other, vars)
      end

      private

      def evaluate(node, vars)
        node.describe_to(self, vars)
      end
    end
  end
end

