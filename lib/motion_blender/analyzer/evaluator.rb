require 'motion_blender/collector'
require 'motion_blender/analyzer/source'

module MotionBlender
  class Analyzer
    class Evaluator
      attr_reader :source
      attr_reader :trace, :requires
      attr_reader :dynamic
      alias_method :dynamic?, :dynamic

      def initialize source
        @source = source
        @trace = "#{source.file}:#{source.line}:in `#{source.method}'"
        @requires = []
        @dynamic = false
      end

      def run
        return if @source.evaluated?

        @source.evaluated!
        collector = Collector.get(@source)
        collector.instance_eval(@source.code, @source.file, @source.line)
        @requires = collector.instance_variable_get(:@_requires) || []
        @requires.each do |req|
          req.trace = @trace
        end
        self
      rescue StandardError, ScriptError => err
        recover_from_error err
      end

      def recover_from_error err
        @source = @source.parent
        @source = @source.parent if @source && @source.type.rescue?
        fail LoadError, err.message unless @source
        @dynamic = true
        run
      end
    end
  end
end
