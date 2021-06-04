# docker run --rm -v ~/projects:/projects jakubstastny/docker-project-manager init my-project
#   /projects is where all the projects are within the Docker image (WORKDIR /projects).
#
# Creates:
# my-blog/README.md
# my-blog/Dockerfile
# my-blog/runner

class DockerProjectManager::Init < DockerProjectManager::Command
  PROJECT_NAME_REGEXP = /{{\s*project_name\s*}}/
  PROJECT_HOST_PATH_REGEXP = /{{\s*project_host_path\s*}}/
  TEMPLATE_DIR = ["templates", "/app/templates"].find { |path| Dir.exists?(path) }

  def usage : String
    "#{@name} [project_name] [projects_host_path]"
  end

  def validate : Nil
    unless @args.size == 2
      raise CommandArgumentError.new(self.usage)
    end

    if self.project_name.match(/\//)
      raise CommandArgumentError.new("project name cannot match /")
    end

    if Dir.exists?(self.project_name)
      raise CommandError.new("Destination #{self.project_name} already exists.")
    end

    unless Dir.exists?(TEMPLATE_DIR)
      raise CommandError.new("Template directory #{TEMPLATE_DIR} doesn't exist")
    end
  end

  def project_name : String
    @args.first
  end

  def project_host_path : String
    File.join(@args[1], self.project_name)
  end

  def run : Nil
    # Base project directory.
    Dir.mkdir(self.project_name)

    Dir.cd(self.project_name) do
      # Project templates.
      Dir.glob("#{TEMPLATE_DIR}/*").each do |path|
        self.process_template(File.new(path))
      end
    end

    puts "\nCongratulations! You initiated project #{self.project_name.colorize(:green)}.\n\n"
    puts "#{"Next steps:".colorize(:magenta).mode(:bold)}\n\n"
    puts "#{"1.".colorize(:green).mode(:bold)} Generate your #{"SSH keys".colorize(:yellow)}.\n\n"
    puts "   The keys will be available within the development environment,"
    puts "   since #{"#{self.project_name}/.ssh".colorize(:light_gray)} directory will be mounted as a volume.\n\n"
    puts "   #{"$".colorize(:cyan)} #{"cd #{self.project_host_path}".colorize(:light_gray)}"
    puts "   #{"$".colorize(:cyan)} #{"./runner ssh-keygen".colorize(:light_gray)}\n\n"
    puts "   Alternatively you can just copy your existing keys from #{"~/.ssh".colorize(:light_gray)}.\n\n"
    puts "   You'll most likely want to add the public key into your"
    puts "   #{"GitHub".colorize(:yellow)} and/or #{"GitLab".colorize(:yellow).mode(:bold)} account.\n\n"
    puts "   #{"*".colorize(:green)} #{"https://github.com/settings/keys".colorize(:blue)}"
    puts "   #{"*".colorize(:green)} #{"https://gitlab.com/profile/keys".colorize(:blue)}\n\n"
    puts "#{"2.".colorize(:green).mode(:bold)} Edit #{"Dockerfile".colorize(:light_gray)}.\n\n"
    # puts "   Use it to set #{"environment variables".colorize(:yellow)}, expose #{"ports".colorize(:yellow)} and #{"volumes".colorize(:yellow)}.\n\n"
    # puts "   Note that DPM automatically mounts volumes and publishes ports"
    # puts "   defined in the Dockerfile.\n\n"
    # TODO: shared/
    puts "#{"3.".colorize(:green).mode(:bold)} Build the image.\n\n"
    puts "   #{"$".colorize(:cyan)} #{"./runner create".colorize(:light_gray)}"
  end

  # Hopefully Crystal gets Path, so we don't have to use this ugly
  # class methods API such as File.basename.
  #
  # https://github.com/crystal-lang/crystal/issues/5550
  def process_template(file : File) : Nil
    template = file.gets_to_end
    content = template
      .gsub(PROJECT_NAME_REGEXP, self.project_name)
      .gsub(PROJECT_HOST_PATH_REGEXP, self.project_host_path)
    mode = File.executable?(file.path) ? 0o755 : 0o644
    File.open(File.basename(file.path), "w", mode) do |file|
      file.puts(content)
    end
  end
end
