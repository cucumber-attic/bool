module Bool
  class EvalVisitor
    if RUBY_PLATFORM =~ /java/
      require 'libbool'

      def self.new
        Java::Bool::EvalVisitor.new
      end

    else
      def visit_var(var_node, vars)
        !!vars.index(var_node.name)
      end

      def visit_and(and_node, vars)
        and_node.left.accept(self, vars) && and_node.right.accept(self, vars)
      end

      def visit_or(and_node, vars)
        and_node.left.accept(self, vars) || and_node.right.accept(self, vars)
      end

      def visit_not(not_node, vars)
        !not_node.other.accept(self, vars)
      end
    end
  end
end

