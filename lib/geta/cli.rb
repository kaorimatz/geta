module Geta
  class CLI
    attr_reader :arguments

    def self.run(arguments)
      new(arguments).run
    end

    def initialize(arguments)
      @arguments = arguments
    end

    def run
      Geta::Cobbler::System.new(name, options[:profile], network).create
    end

    private

    def network
      @network ||= Geta::Collectors::Network.new(ssh)
    end

    def ssh
      @ssh ||= Geta::SSH.new(hostname, ssh_user, ssh_options)
    end

    def ssh_user
      options[:'ssh-user'] || ENV['USER']
    end
    
    def ssh_options
      opts = Hash.new
      opts[:password] = options[:'ssh-password'] if options[:'ssh-password']
      opts
    end

    def name
      options[:name] || hostname
    end

    def hostname
      arguments[0]
    end

    def options
      @options ||= Slop.parse!(arguments, help: true) do
        banner 'Usage: geta [options] <hostname>'
        on('n', 'name=', 'Specify system name.')
        on('p', 'profile=', 'Specify profile name to which system belongs.')
        on('ssh-user=', 'Login with the given user.')
        on('ssh-password=', 'Login with the given password.')
      end.to_hash
    end
  end
end
