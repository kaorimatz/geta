module Geta
  module Cobbler
    class System < Base
      attr_reader :name
      attr_reader :profile
      attr_reader :network

      def initialize(name, profile, network)
        @name = name
        @profile = profile
        @network = network
      end

      def create
        create_system
        network.interfaces.each do |interface|
          create_interface(interface)
        end
        nil
      end

      private

      def create_system
        command = "sudo cobbler system add"
        options = ["--name='#{name}'", "--profile='#{profile}'"]
        options << option('gateway', :string, network.gateway)
        options << option('hostname', :string, network.hostname)
        options << option('name-servers', :array, network.name_servers)
        options << option('name-servers-search', :array, network.name_servers_search)
        command += ' ' + options.compact.join(' ')
        system(command)
      end

      def create_interface(interface)
        command = "sudo cobbler system edit"
        options = ["--name='#{name}'", "--interface='#{interface.name}'"]
        options << option('interface-type', :string, type(interface))
        options << option('ip-address', :string, interface.ip_address)
        options << option('netmask', :string, interface.netmask)
        options << option('mac-address', :string, interface.mac_address)
        options << option('static-routes', :array, interface.static_routes)
        options << option('bonding-opts', :string, interface.bonding_options)
        options << option('bridge-opts', :string, interface.bridge_options)
        command += ' ' + options.compact.join(' ')
        system(command)
      end

      def type(interface)
        if interface.bridge?
          'bridge'
        elsif interface.bond_slave?
          'bond_slave'
        elsif interface.bond? && interface.bridge_slave?
          'bonded_bridge_slave'
        elsif interface.bond?
          'bond'
        elsif interface.bridge_slave?
          'bridge_slave'
        else
          nil
        end
      end
    end
  end
end
