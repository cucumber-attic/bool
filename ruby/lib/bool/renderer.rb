module Bool
  class Renderer
    if RUBY_PLATFORM =~ /java/
      require 'bool_ext'

      def self.new
        Java::Bool::Renderer.new
      end

    else
      def visit_var(node, _)
        node.token.value
      end

      def visit_and(node, _)
        "(#{render(node.left)} #{node.token.value} #{render(node.right)})"
      end

      def visit_or(node, _)
        "(#{render(node.left)} #{node.token.value} #{render(node.right)})"
      end

      def visit_not(node, _)
        "#{node.token.value}#{render(node.operand)}"
      end

      def render(node)
        node.accept(self, nil)
      end
    end
  end
end

