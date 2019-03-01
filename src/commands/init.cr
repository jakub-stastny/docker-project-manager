# dpm init my-blog
#
# Creates:
# my-blog/README.md
# my-blog/Dockerfile
# my-blog/my-blog/
# my-blog/.ssh/
# my-blog/.history

# This should all happen in ~/projects.
class DockerProjectManager::Init < DockerProjectManager::Command
  PROJECT_NAME_REGEXP = /{{\s*project_name\s*}}/

  def usage : String
    "#{@name} [project_name]"
  end

  def validate : Nil
    unless @args.size == 1
      raise CommandArgumentError.new(self.usage)
    end

    if self.project_name.match(/\//)
      raise CommandArgumentError.new("project name cannot match /")
    end
  end

  def project_name : String
    @args.first
  end

  # TODO: This is temporary, it will behave differently on Travis, in Docker etc.
  def template_dir : String
    @args[1] || "/root/docker-project-manager/templates"
  end

  def run : Nil
    Dir.mkdir(self.project_name)
    Dir.cd(self.project_name) do
      Dir.mkdir(self.project_name)
      Dir.mkdir(".ssh")
      Dir.glob("#{template_dir}/*").each do |path|
        self.process_template(File.new(path))
      end
    end

    # Read every file from templates, replace {{ project_name }} with the actual project name.
    # Generate SSH keys (this requires external software).
  end

  # Hopefully Crystal gets Path, so we don't have to use this ugly
  # class methods API such as File.basename.
  #
  # https://github.com/crystal-lang/crystal/issues/5550
  def process_template(file : File) : Nil
    template = file.gets_to_end
    content = template.gsub(PROJECT_NAME_REGEXP, self.project_name)
    File.open(File.basename(file.path), "w") do |file|
      file.puts(content)
    end
  end
end