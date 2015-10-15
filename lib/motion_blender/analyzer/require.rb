module MotionBlender
  class Analyzer
    class Require
      attr_accessor :loader, :method, :arg, :trace

      def initialize loader, method, arg
        @loader = loader
        @method = method
        @arg = arg
      end

      def file
        @file ||= resolve_path
      end

      def resolve_path
        path = candidates.find(&:file?)
        fail LoadError, "not found `#{arg}'" unless path
        explicit_relative path
      end

      def candidates
        path =
          if %i(motion_require require_relative).include? method
            Pathname.new(loader).dirname.join(arg)
          else
            Pathname.new(arg)
          end
        dirs = (uses_load_path? && path.relative?) ? $LOAD_PATH : ['']
        exts = path.extname.empty? ? ['', '.rb'] : ['']
        Enumerator.new do |y|
          dirs.product(exts).each do |dir, ext|
            y << Pathname.new(dir).join("#{path}#{ext}")
          end
        end
      end

      def explicit_relative path
        path.to_s.sub(%r{^(?![\./])}, './')
      end

      def uses_load_path?
        method == :require
      end
    end
  end
end