module Bool
  class Renderer
    if RUBY_PLATFORM =~ /java/
      require 'bool_ext'

      def self.new
        Java::Bool::Renderer.new
      end

    else
      def visit_var(node, vars)
        node.name
      end

      def visit_and(node, vars)
        "(" + render(node.left) + " && " + render(node.right) + ")"
      end

      def visit_or(node, vars)
        "(" + render(node.left) + " || " + render(node.right) + ")"
      end

      def visit_not(node, vars)
        "!" + render(node.other)
      end

    private

      def render(node)
        node.accept(self, nil)
      end
    end
  end
end

