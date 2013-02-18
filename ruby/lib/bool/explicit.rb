module Bool
  class Explicit
    if RUBY_PLATFORM =~ /java/
      require 'bool_ext'

      def self.new
        Java::Bool::Explicit.new
      end

    else
      def var(node, vars)
        node.name
      end

      def and(node, vars)
        "(" + explicit(node.left) + " && " + explicit(node.right) + ")"
      end

      def or(node, vars)
        "(" + explicit(node.left) + " || " + explicit(node.right) + ")"
      end

      def not(node, vars)
        "!" + explicit(node.other)
      end

      private

      def explicit(node)
        node.describe_to(self, nil)
      end
    end
  end
end

