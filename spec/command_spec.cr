require "../src/command"
require "./spec_helper"

class DockerProjectManager::Test < DockerProjectManager::Command end

describe DockerProjectManager::Command do
  describe ".commands" do
    it "saves all the commands in command_name: command_class hash" do
      DockerProjectManager::Command.commands["test"] = DockerProjectManager::Test
    end
  end

  describe ".run" do
    it "requires a command" do
      expect_raises(DockerProjectManager::CommandError, /./) do
        DockerProjectManager::Command.run(Array(String).new)
      end
    end
  end
end
