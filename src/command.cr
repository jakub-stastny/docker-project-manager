module DockerProjectManager
  class CommandError < Exception end

  class NoCommandError < CommandError
    def initialize
      super("Usage: #{PROGRAM_NAME} <command>")
    end
  end

  class NoSuchCommandError < CommandError
    def initialize(command, available_commands)
      super("No such command: #{command}\nAvailable commands: #{available_commands.keys.join(", ")}")
    end
  end

  abstract class Command
    def initialize(@args) end

    def self.commands : Hash(String, Command.class)
      @@commands ||= Hash(String, Command.class).new
    end

    macro inherited
      command_class = {{ @type.name.id }}
      command_name = "{{ @type.name.id }}".split("::").last.downcase
      self.commands[command_name] = command_class
    end

    def self.run(args) : Nil
      Signal::INT.trap { exit }

      unless args.size > 0
        raise NoCommandError.new
      end

      command = self.command(args.first)
      command.run(args[1..-1])
    end

    private def self.command(command_name) : Command.class
      self.commands[command_name]
    rescue KeyError
      raise NoSuchCommandError.new(command_name, self.commands)
    end
  end
end
