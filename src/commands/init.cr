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
  def template_dir
    @args[1] || "/root/docker-project-manager/templates"
  end

  def run : Nil
    Dir.mkdir(self.project_name)
    Dir.cd(self.project_name) do
      Dir.mkdir(self.project_name)
      Dir.mkdir(".ssh")
      Dir.glob("#{template_dir}/*").each do |file_name|
        process_template file_name
      end
    end

    # Read every file from templates, replace {{ project_name }} with the actual project name.
    # Generate SSH keys (this requires external software).
  end

  def process_template(file_name : String) : Nil
    template_body = File.read(file_name)
    template_body = template_body.gsub /{{\s*project_name\s*}}/, project_name
    File.open(File.basename(file_name), "w") do |f|
      f.print template_body
    end
  end
end
