class DockerProjectManager::Init < DockerProjectManager::Command
  def usage : String
    "#{self.name} [project_name]"
  end

  def validate
    unless @args.size == 1
      raise CommandArgumentError.new(self.usage)
    end
  end

  def run
  end
end
