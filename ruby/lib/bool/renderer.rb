module Bool
  class Renderer
    if RUBY_PLATFORM =~ /java/
      require 'bool_ext'

      def self.new
        Java::Bool::Renderer.new
      end

    else
      def var(node, vars)
        node.name
      end

      def and(node, vars)
        "(" + renderer(node.left) + " && " + renderer(node.right) + ")"
      end

      def or(node, vars)
        "(" + renderer(node.left) + " || " + renderer(node.right) + ")"
      end

      def not(node, vars)
        "!" + renderer(node.other)
      end

      private

      def renderer(node)
        node.describe_to(self, nil)
      end
    end
  end
end

