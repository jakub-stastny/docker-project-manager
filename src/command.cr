module DockerProjectManager
  class CommandError < Exception
  end

  abstract class Command
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
        raise CommandError.new("Usage: #{PROGRAM_NAME} <command>")
      end

      if command = self.commands[args.first]
        command.run(args[1..-1])
      else
        raise CommandError.new("No such command: #{args.first}\nAvailable commands: #{self.commands.keys.join(", ")}")
      end
    end
  end
end
