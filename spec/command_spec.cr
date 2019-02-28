require "../src/command"
require "./spec_helper"

class DockerProjectManager::Test < DockerProjectManager::Command
  def validate : Nil
  end

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
    it "requires a command as the first command-line argument" do
      expect_raises(DockerProjectManager::NoCommandError) do
        DockerProjectManager::Command.run(Array(String).new)
      end
    end

    it "requires a command of such name to be registered" do
      expect_raises(DockerProjectManager::NoSuchCommandError) do
        DockerProjectManager::Command.run(["hola"])
      end
    end

    pending "runs the command's #validate method" do
      # TODO
    end

    it "runs the command's #run method" do
      DockerProjectManager::Command.run(["test"]).should eq(Array(String).new)
    end

    it "passes arguments to the initializer" do
      DockerProjectManager::Command.run(["test", "uno", "dos", "tres"]).should eq(["uno", "dos", "tres"])
    end
  end
end
