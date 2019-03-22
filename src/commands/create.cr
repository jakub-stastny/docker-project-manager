class DockerProjectManager::Create < DockerProjectManager::Command
  DEFINITION_TEMPLATE = {
    "volume" => ["/var/run/docker.sock"],
    "expose" => Array(String).new
  }

  def usage : String
    "#{@name} [project_name] [project_host_path]"
  end

  def validate : Nil
    unless @args.size == 2
      raise CommandArgumentError.new(self.usage)
    end

    if self.project_name.match(/\//)
      raise CommandArgumentError.new("project name cannot match /")
    end

    unless Dir.exists?(self.project_name)
      raise CommandError.new("Destination #{self.project_name} doesn't exist yet.\nRun #{PROGRAM_NAME} init #{self.project_name} first.")
    end

    unless File.exists?(File.join(self.project_name, "Dockerfile"))
      raise CommandError.new("Dockerfile doesn't exist in #{self.project_name}.")
    end
  end

  def project_name : String
    @args.first
  end

  def image_name : String
    "#{self.project_name}-dev-env"
  end

  def absolute_host_project_root_path : String
    File.join(@args[1])
  end

  def run : Nil
    Dir.cd(self.project_name) do
      lines = File.read("Dockerfile").split("\n")
      definition = self.build_definition(lines)
      volumes_args = definition["volume"].map { |path| "-v #{self.overwrite_path(path)}:#{path}" }.join(" ")
      expose_args = definition["expose"].map { |port| "-p #{port}:#{port}" }.join(" ")
      # Host networking means that the container IP is the same as the host IP (no need to tweak tmux status line).
      # https://docs.docker.com/network/host/
      puts "Next steps:\n".colorize(:magenta).mode(:bold)
      puts "  #{"$".colorize(:cyan)} #{"docker create -it".colorize(:light_gray)} #{volumes_args.colorize(:yellow)} #{expose_args.colorize(:green)} #{"--network host --name".colorize(:light_gray)} #{self.image_name.colorize(:magenta)} #{"--hostname".colorize(:light_gray)} #{self.project_name.colorize(:cyan)} #{self.image_name.colorize(:magenta)}\n"
      puts "  #{"$".colorize(:cyan)} #{"./runner start".colorize(:light_gray)}"
      puts "  #{"$".colorize(:cyan)} #{"./runner attach".colorize(:light_gray)}"
      puts "\n#{"*".colorize(:green)} If this is an existing project, you'll want to clone the repo (once attached):\n\n"
      puts "  #{"$".colorize(:cyan)} #{"git clone repo my_repo/.git --bare".colorize(:light_gray)}"
      puts "  #{"$".colorize(:cyan)} #{"git checkout .".colorize(:light_gray)}\n\n"
      puts "  This way there's no need to install git on the host machine."
    end
  end

  # NOTE: Environment variables doesn't need to be passed in args,
  # having them in Dockerfile is enough.
  private def build_definition(lines : Array(String)) : Hash(String, Array(String))
    lines.grep(/^(VOLUME|EXPOSE)/).reduce(DEFINITION_TEMPLATE.dup) do |buffer, line|
      keyword = line.split(" ").first.downcase
      buffer[keyword] << line.split(" ")[1]
      buffer
    end
  end

  private def overwrite_path(path) : String
    if path.match(/^\/(projects|root)\//)
      path.sub(/^\/(projects|root)/, self.absolute_host_project_root_path, "..")
    else
      path
    end
  end
end
