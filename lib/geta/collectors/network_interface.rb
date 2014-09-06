module Geta
  module Collectors
    class NetworkInterface < Base
      attr_reader :name

      def initialize(ssh, name)
        super(ssh)
        @name = name
      end

      def bonding_options
        if bond?
          ssh.execute(commands.get_non_default_bonding_options(name)).stdout.split(/\n/).map(&:strip).presence
        else
          nil
        end
      end

      def bridge_options
        if bridge?
          nil
        else
          nil
        end
      end

      def master
        if slave?
          ssh.execute(commands.get_master(name)).stdout.strip.presence
        else
          nil
        end
      end

      def ip_address
        ip_addresses.first
      end

      def netmask
        netmasks.first
      end

      def mac_address
        ssh.execute(commands.get_mac_address(name)).stdout.strip.presence
      end

      def static_routes
        ssh.execute(commands.get_static_routes(name)).stdout.split(/\n/).map(&:strip).presence
      end

      def bond?
        ssh.execute(commands.check_is_bonding_interface(name)).success?
      end
      
      def bond_slave?
        ssh.execute(commands.check_is_bonding_slave_interface(name)).success?
      end

      def bridge?
        ssh.execute(commands.check_is_bridge_interface(name)).success?
      end

      def bridge_slave?
        ssh.execute(commands.check_is_bridge_slave_interface(name)).success?
      end

      private

      def ip_addresses
        ssh.execute(commands.get_ip_addresses(name)).stdout.split(/\n/).map(&:strip)
      end

      def netmasks
        ssh.execute(commands.get_prefix_lengths(name)).stdout.split(/\n/).map(&:strip).map do |prefix_length|
          IPAddr.new("255.255.255.255/#{prefix_length}").to_s
        end
      end

      def slave?
        bond_slave? || bridge_slave?
      end
    end
  end
end
