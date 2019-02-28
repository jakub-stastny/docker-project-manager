module DockerProjectManager
  class CommandError < Exception end

  class NoCommandError < CommandError
    def initialize
      super("Usage: #{PROGRAM_NAME} <command>")
    end
  end

  class NoSuchCommandError < CommandError
    def initialize(command : String, available_commands : Array(String))
      super("No such command: #{command}\nAvailable commands: #{available_commands.join(", ")}")
    end
  end

  abstract class Command
    def initialize(@args : Array(String)) end

    def self.commands : Hash(String, Command.class)
      @@commands ||= Hash(String, Command.class).new
    end

    macro inherited
      command_class = {{ @type.name.id }}
      command_name = "{{ @type.name.id }}".split("::").last.downcase
      self.commands[command_name] = command_class
    end

    def self.run(args)
      Signal::INT.trap { exit }

      raise NoCommandError.new if args.empty?

      command_class = self.command(args.first)
      command = command_class.new(args[1..-1])
      command.run
    end

    def self.command(command_name) : self.class
      self.commands[command_name]
    rescue KeyError
      raise NoSuchCommandError.new(command_name, self.commands.keys)
    end
  end
end
