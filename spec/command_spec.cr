require "../src/command"
require "./spec_helper"

class DockerProjectManager::Test < DockerProjectManager::Command
  def run : Array(String)
    @args
  end
end

describe DockerProjectManager::Command do
  describe ".commands" do
    it "saves all the commands in command_name: command_class hash" do
      DockerProjectManager::Command.commands["test"] = DockerProjectManager::Test
    end
  end

  describe ".run" do
    it "requires a command" do
      expect_raises(DockerProjectManager::NoCommandError) do
        DockerProjectManager::Command.run(Array(String).new)
      end
    end

    it "requires a registered command" do
      expect_raises(DockerProjectManager::NoSuchCommandError) do
        DockerProjectManager::Command.run(["hola"])
      end
    end

    it "runs the #run method of a command" do
      DockerProjectManager::Command.run(["test"]).should eq(Array(String).new)
    end

    it "passes arguments to the initializer" do
      DockerProjectManager::Command.run(["test", "uno", "dos", "tres"]).should eq(["uno", "dos", "tres"])
    end
  end
end
