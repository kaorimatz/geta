module Geta
  module Collectors
    class Network < Base
      def gateway
        ssh.execute(commands.get_gateway).stdout.strip
      end

      def hostname
        ssh.execute(commands.get_hostname).stdout.strip
      end

      def name_servers
        ssh.execute(commands.get_name_servers).stdout.split(/\n/).map(&:strip)
      end

      def name_servers_search
        ssh.execute(commands.get_name_servers_search).stdout.split(/\n/).map(&:strip)
      end

      def interfaces
        ssh.execute(commands.get_interfaces).stdout.split(/\n/).map(&:strip).map do |interface|
          NetworkInterface.new(ssh, interface)
        end
      end
    end
  end
end
