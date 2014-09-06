module Geta
  class CommandResult
    attr_reader :stdout
    attr_reader :stderr
    attr_reader :exit_status
    attr_reader :exit_signal

    def initialize(arguments)
      @stdout = arguments[:stdout]
      @stderr = arguments[:stderr]
      @exit_status = arguments[:exit_status]
      @exit_signal = arguments[:exit_signal]
    end

    def success?
      exit_status == 0
    end
  end
end
