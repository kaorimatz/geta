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
        command = CommandBuilder.new('system add') do |builder|
          builder.option('name', name)
          builder.option('profile', profile)
          builder.option('gateway', network.gateway)
          builder.option('hostname', network.hostname)
          builder.option('name-servers', network.name_servers, :array)
          builder.option('name-servers-search', network.name_servers_search, :array)
        end.build
        system(command)
      end

      def create_interface(interface)
        command = CommandBuilder.new('system edit') do |builder|
          builder.option('name', name)
          builder.option('interface', interface.name)
          builder.option('interface-type', interface_type(interface))
          builder.option('ip-address', interface.ip_address)
          builder.option('netmask', interface.netmask)
          builder.option('mac-address', interface.mac_address)
          builder.option('static-routes', interface.static_routes, :array)
          builder.option('bonding-opts', interface.bonding_options)
          builder.option('bridge-opts', interface.bridge_options)
        end.build
        system(command)
      end

      def interface_type(interface)
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
