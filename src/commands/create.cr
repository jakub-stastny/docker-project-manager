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
    @args[1]
  end

  def run : Nil
    Dir.cd(self.project_name) do
      lines = File.read("Dockerfile").split("\n")
      definition = self.build_definition(lines)
      volumes_args = definition["volume"].map { |path| "-v #{path}:#{path}" }.join(" ")
      expose_args = definition["expose"].map { |port| "-p #{port}:#{port}" }.join(" ")
      puts "cd #{self.absolute_host_project_root_path}"
      puts "docker build . -t #{self.image_name}"
      # Host networking means that the container IP is the same as the host IP (no need to tweak tmux status line).
      # https://docs.docker.com/network/host/
      puts "docker create -it #{volumes_args} #{expose_args} --network host --name #{self.image_name} --hostname #{self.project_name} #{self.image_name}\n\n"
      puts "Next steps:"
      puts "  $ ./runner start"
      puts "  $ ./runner attach"
    end
  end

  private def build_definition(lines : Array(String)) : Hash(String, Array(String))
    lines.grep(/^(VOLUME|EXPOSE)/).reduce(DEFINITION_TEMPLATE.dup) do |buffer, line|
      keyword = line.split(" ").first.downcase
      buffer[keyword] << line.split(" ")[1]
      buffer
    end
  end

  private def overwrite_path(path) : String
    if path.match(/^\/projects\//)
      path.sub(/^\/projects/, File.expand_path(self.absolute_project_root_path), "..")
    else
      path
    end
  end
end
