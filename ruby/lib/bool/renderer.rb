module Bool
  class Renderer
    if RUBY_PLATFORM =~ /java/
      require 'bool_ext'

      def self.new
        Java::Bool::Renderer.new
      end

    else
      def walk_var(node, vars)
        node.name
      end

      def walk_and(node, vars)
        "(" + render(node.left) + " && " + render(node.right) + ")"
      end

      def walk_or(node, vars)
        "(" + render(node.left) + " || " + render(node.right) + ")"
      end

      def walk_not(node, vars)
        "!" + render(node.other)
      end

      private

      def render(node)
        node.walk_with(self, nil)
      end
    end
  end
end

