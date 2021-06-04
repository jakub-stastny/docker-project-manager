module DockerProjectManager
end

require "./command"
require "./commands/init"
require "./commands/create"
require "./commands/update"

DockerProjectManager::Command.run(ARGV)
