module Bool
  class Evaluator
    if RUBY_PLATFORM =~ /java/
      require 'bool_ext'

      def self.new
        Java::Bool::Evaluator.new
      end

    else
      def visit_var(node, vars)
        !!vars.index(node.value)
      end

      def visit_and(node, vars)
        evaluate(node.left, vars) && evaluate(node.right, vars)
      end

      def visit_or(node, vars)
        evaluate(node.left, vars) || evaluate(node.right, vars)
      end

      def visit_not(node, vars)
        !evaluate(node.operand, vars)
      end

    private

      def evaluate(node, vars)
        node.accept(self, vars)
      end
    end
  end
end

