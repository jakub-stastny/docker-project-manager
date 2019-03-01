class DockerProjectManager::Create < DockerProjectManager::Command
  def usage : String
    "#{@name} [project_name]"
  end

  def validate : Nil
  end

  def run : Nil
  end
end
