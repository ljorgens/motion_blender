module MotionBlender
  class Analyzer
    class Source
      attr_reader :code, :file, :line, :parent, :type, :method, :ast
      attr_reader :evaluated
      alias_method :evaluated?, :evaluated

      def initialize attrs = {}
        @evaluated = false
        ast = attrs.delete :ast
        if ast
          @code = ast.loc.expression.source
          @file = ast.loc.expression.source_buffer.name
          @line = ast.loc.expression.line
          @type = ast.type
          @method = (ast.type == :send) ? ast.children[1] : nil
          @ast = ast
        end
        attrs.each do |k, v|
          instance_variable_set "@#{k}", v
        end
      end

      def evaluated!
        @evaluated = true
      end

      def children
        @children ||=
          if @ast
            @ast.children.grep(::Parser::AST::Node).map do |ast|
              Source.new(ast: ast, parent: self)
            end
          else
            []
          end
      end
    end
  end
end
