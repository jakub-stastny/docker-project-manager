class DockerProjectManager::Create < DockerProjectManager::Command
  DEFINITION_TEMPLATE = {
    "volume" => ["/var/run/docker.sock"]
  }

  def usage : String
    "#{@name} [project_name] [project_host_path] [--show-instructions]"
  end

  def validate : Nil
    unless @args.size == 2 || (@args.size == 3 && @args.last == "--show-instructions")
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

  def show_instructions_only? : Bool
    @args.size > 2 && @args[2] == "--show-instructions"
  end

  def run : Nil
    Dir.cd(self.project_name) do
      if self.show_instructions_only?
        self.run_show_instructions
      else
        self.run_print_commands
      end
    end
  end

  private def run_show_instructions : Nil
    puts "Next steps:\n".colorize(:magenta).mode(:bold)
    puts "  #{"$".colorize(:cyan)} #{"docker create -it".colorize(:light_gray)} #{volumes_args.colorize(:yellow)} #{"--network host --name".colorize(:light_gray)} #{self.image_name.colorize(:magenta)} #{"--hostname".colorize(:light_gray)} #{self.project_name.colorize(:cyan)} #{self.image_name.colorize(:magenta)}\n"
    puts "  #{"$".colorize(:cyan)} #{"./runner start".colorize(:light_gray)}"
    puts "  #{"$".colorize(:cyan)} #{"./runner attach".colorize(:light_gray)}"
  end

  private def run_print_commands : Nil
    puts "run docker create -it #{volumes_args} --network host --name #{self.image_name} --hostname #{self.project_name} #{self.image_name}"
  end

  private def volumes_args : String
    # Dir.glob seems to ignore hidden files, even with .*.
    shared_files_and_dirs = %x(echo shared/* shared/.*).chomp.split(/\s+/).map { |sp| sp.sub(/shared./, "") } - [".", ".."]
    shared_files_and_dirs.map { |path| "-v #{self.absolute_host_project_root_path}/shared/#{path}:/root/#{path}" }.join(" ")
  end
end
