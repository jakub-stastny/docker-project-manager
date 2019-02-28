module DockerProjectManager
  VERSION = "0.1.0"

  abstract class Command
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

      unless args.size > 0
        abort "Usage: #{PROGRAM_NAME} <command>"
      end

      if command = self.commands[args.first]
        command.run(args[1..-1])
      else
        abort "No such command: #{args.first}\nAvailable commands: #{self.commands.keys.join(", ")}"
      end
    end
  end
end

# Main.
require "./commands/*"

DockerProjectManager::Command.run(ARGV)
