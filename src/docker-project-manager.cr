module DockerProjectManager
end

require "./command"
require "./commands/*"

DockerProjectManager::Command.run(ARGV)
