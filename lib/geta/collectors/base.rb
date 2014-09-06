module Geta
  module Collectors
    class Base
      attr_reader :ssh

      def initialize(ssh)
        @ssh = ssh
      end

      def commands
        @commands ||= Commands.new
      end
    end
  end
end
