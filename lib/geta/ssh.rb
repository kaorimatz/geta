module Geta
  class SSH
    attr_reader :host
    attr_reader :user
    attr_reader :options

    def initialize(host, user, options)
      @host = host
      @user = user
      @options = options
    end

    def execute(command)
      stdout = ''
      stderr = ''
      exit_status = nil
      exit_signal = nil

      session.open_channel do |ch|
        ch.exec(command) do |ch2, success|
          ch2.on_data do |ch3, data|
            stdout += data
          end
          ch2.on_extended_data do |ch3, type, data|
            stderr += data
          end
          ch2.on_request('exit-status') do |ch3, data|
            exit_status = data.read_long
          end
          ch2.on_request('exit-signal') do |ch3, data|
            exit_signal = data.read_long
          end
        end
      end
      session.loop

      Geta::CommandResult.new({
        stdout: stdout,
        stderr: stderr,
        exit_status: exit_status,
        exit_signal: exit_signal,
      })
    end

    def session
      @session ||= Net::SSH.start(host, user, options)
    end
  end
end
