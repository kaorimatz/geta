module Geta
  module Cobbler
    class CommandBuilder
      COBBLER_BINARY_PATH = 'cobbler'

      def initialize(command, &block)
        @command = command
        @options = []

        if block_given?
          block.arity == 1 ? yield(self) : instance_eval(&block)
        end
      end

      def option(key, value, type = :string)
        @options << build_option(key, value, type) if value
        self
      end

      def build(sudo = true)
        if sudo
          "sudo #{COBBLER_BINARY_PATH} #{@command} #{@options.join(' ')}"
        else
          "#{COBBLER_BINARY_PATH} #{@command} #{@options.join(' ')}"
        end
      end

      private

      def build_option(key, value, type)
        case type
        when :string
          if value.is_a?(Array)
            "--#{key}='#{value.join(' ')}'"
          else
            "--#{key}='#{value}'"
          end
        when :array
          "--#{key}='#{value.map { |v| "\"#{v}\"" }.join(' ')}'"
        end
      end
    end
  end
end
