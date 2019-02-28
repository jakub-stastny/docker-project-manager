require "../../src/command"
require "../../src/commands/init"
require "./../spec_helper"

describe DockerProjectManager::Init do
  describe "#run" do
    it "requires an argument" do
      expect_raises(DockerProjectManager::NoCommandError) do
        DockerProjectManager::Command.run(Array(String).new)
      end
    end
  end
end

