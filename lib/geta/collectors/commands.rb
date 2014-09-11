module Geta
  module Collectors
    class Commands
      BONDING_DRIVER_OPTIONS = [
        {
          name: 'ad_select',
          default: ['stable', 0],
        },
        {
          name: 'all_slaves_active',
          default: 0,
        },
        {
          name: 'arp_interval',
          default: 0,
        },
        {
          name: 'arp_ip_target',
          default: nil
        },
        {
          name: 'downdelay',
          default: 0,
        },
        {
          name: 'lacp_rate',
          default: ['slow', 0],
        },
        {
          name: 'lp_interval',
          default: 1,
        },
        {
          name: 'miimon',
          default: 0,
        },
        {
          name: 'min_links',
          default: 0,
        },
        {
          name: 'mode',
          default: ['balance-rr', 0],
        },
        {
          name: 'num_unsol_na',
          default: 1,
        },
        {
          name: 'packets_per_slave',
          default: 1,
        },
        {
          name: 'primary_reselect',
          default: ['always', 0],
        },
        {
          name: 'resend_igmp',
          default: 1,
        },
        {
          name: 'updelay',
          default: 0,
        },
        {
          name: 'use_carrier',
          default: 1,
        },
        {
          name: 'xmit_hash_policy',
          default: ['layer2', 0],
        },
      ].freeze

      def get_gateway
        "/usr/sbin/ip route | awk '/^default / { print $3 }'"
      end

      def get_hostname
        "/usr/bin/hostname -s"
      end

      def get_name_servers
        "awk '/^nameserver/ { print $2 }' /etc/resolv.conf"
      end

      def get_name_servers_search
        "awk '/^search/ { print $2 }' /etc/resolv.conf"
      end

      def get_interfaces
        command = ""
        command += "/usr/sbin/ip address | "
        command += "grep -E '^[0-9]+: ' | "
        command += "sed -e 's/^[0-9]\\+: \\([a-zA-Z0-9\\.]\\+\\)\\(@[a-zA-Z0-9]+\\)\\?: .*/\\1/'"
        command
      end

      def get_mac_address(interface)
        command = ""
        command += "/usr/sbin/ip address show #{interface} | "
        command += "grep -E '^    link/' | "
        command += "awk '{ print $2 }'"
        command
      end

      def get_static_routes(interface)
        command = ""
        command += "/usr/sbin/ip route show dev #{interface} | "
        command += "grep -w 'via' | "
        command += "sed -e 's/ via /:/' -e 's,default,0.0.0.0/0,'"
        command
      end

      def get_ip_addresses(interface)
        "#{get_ip_addresses_with_prefixes(interface)} | cut -d / -f 1"
      end

      def get_prefix_lengths(interface)
        "#{get_ip_addresses_with_prefixes(interface)} | cut -d / -f 2"
      end

      def check_is_bonding_interface(interface)
        "test -d /sys/class/net/#{interface}/bonding"
      end

      def check_is_bonding_slave_interface(interface)
        "test -d /sys/class/net/#{interface}/bonding_slave"
      end

      def check_is_bridge_interface(interface)
        "test -d /sys/class/net/#{interface}/bridge"
      end

      def check_is_bridge_slave_interface(interface)
        "test -d /sys/class/net/#{interface}/brport"
      end
      
      def get_non_default_bonding_options(interface)
        BONDING_DRIVER_OPTIONS.map do |option|
          command = ""
          command += "("
          command += check_has_bonding_option_value(interface, option[:name], option[:default])
          command += " || "
          command += "echo \"#{option[:name]}=$(#{get_bonding_option_value(interface, option[:name])})\""
          command += ")"
          command
        end.join(' && ')
      end

      def get_master(interface)
        "basename $(readlink -f /sys/class/net/#{interface}/master)"
      end

      private

      def get_ip_addresses_with_prefixes(interface)
        command = ""
        command += "/usr/sbin/ip address show #{interface} | "
        command += "grep -E '^    inet ' | "
        command += "awk '{ print $2 }'"
        command
      end

      def get_bonding_option_value(interface, option)
        "awk '{ print $1 }' /sys/class/net/#{interface}/bonding/#{option}"
      end

      def check_has_bonding_option_value(interface, option, value)
        if value.nil?
          "! grep -E '.*' /sys/class/net/#{interface}/bonding/#{option}"
        elsif value.is_a?(Array)
          "grep -qFx '#{value.join(' ')}' /sys/class/net/#{interface}/bonding/#{option}"
        else
          "grep -qFx '#{value}' /sys/class/net/#{interface}/bonding/#{option}"
        end
      end
    end
  end
end
