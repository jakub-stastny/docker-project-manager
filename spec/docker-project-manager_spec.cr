require "./spec_helper"

describe DockerProjectManager::Command do
  describe ".commands" do
    it "saves all the commands in command_name: command_class hash" do
      DockerProjectManager::Command.commands["bootstrap"] = DockerProjectManager::Bootstrap
    end
  end

  describe ".run" do
    # TODO
  end
end
