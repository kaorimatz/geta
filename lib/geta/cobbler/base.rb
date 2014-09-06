module Geta
  module Cobbler
    class Base
      def option(key, type, value)
        if value
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
        else
          nil
        end
      end
    end
  end
end
