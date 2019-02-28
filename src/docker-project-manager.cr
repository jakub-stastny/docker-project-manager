module DockerProjectManager
  VERSION = "0.1.0"
end

require "./command"
require "./commands/*"

DockerProjectManager::Command.run(ARGV)
