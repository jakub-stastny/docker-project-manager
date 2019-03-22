# require "../ssh-key-pair"

# docker run --rm -v ~/projects:/projects botanicus/docker-project-manager init my-project
#   /projects is where all the projects are within the Docker image (WORKDIR /projects).
#
# Creates:
# my-blog/README.md
# my-blog/Dockerfile
# my-blog/runner
# my-blog/.ssh/{id_rsa,id_rsa.pub} # currently disabled, see #26.

class DockerProjectManager::Init < DockerProjectManager::Command
  PROJECT_NAME_REGEXP = /{{\s*project_name\s*}}/
  PROJECT_HOST_PATH_REGEXP = /{{\s*project_host_path\s*}}/
  TEMPLATE_DIR = "/app/templates"

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
      # SSH keys.
      # Dir.mkdir(".ssh", 700)
      # key_pair = SSHKeyPair.new
      # key_pair.save(".ssh")

      # Project templates.
      Dir.glob("#{TEMPLATE_DIR}/*").each do |path|
        self.process_template(File.new(path))
      end
    end

    puts "\nCongratulations! You initiated project #{self.project_name.colorize(:green)}.\n\n"
    puts "Things to note:\n\n"
    #puts "* A pair of #{"SSH keys".colorize(:yellow)} has been generated into #{self.project_name}/.ssh."
    puts "#{"*".colorize(:green).mode(:bold)} Generate your #{"SSH keys".colorize(:yellow)} thus:\n\n"
    puts "  #{"$".colorize(:cyan)} #{"cd #{self.project_host_path}".colorize(:light_gray)}"
    puts "  #{"$".colorize(:cyan)} #{"./runner ssh-keygen".colorize(:light_gray)}\n\n"
    puts "  The directory with the keys will be mounted as a volume and"
    puts "  will be available within your dev environment.\n\n"
    puts "  You'll most likely want to add the public key into your"
    puts "  GitHub/GitLab account.\n\n"
    puts "#{"*".colorize(:green)} If this is an existing project, you'll want to clone the repo:\n\n"
    puts "  #{"$".colorize(:cyan)} #{"git clone repo my_repo/.git --bare".colorize(:light_gray)}"
    puts "  #{"$".colorize(:cyan)} #{"git checkout .".colorize(:light_gray)}\n\n"
    puts "#{"*".colorize(:green).mode(:bold)} Use #{"./runner create".colorize(:light_gray)} to build Docker image off #{self.project_name}/Dockerfile."
    puts "  Note that DPM automatically mounts volumes and publishes ports"
    puts "  defined in the Dockerfile.\n\n"
    puts "  For more detail, see the documentation in #{self.project_name}/Dockerfile."
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
