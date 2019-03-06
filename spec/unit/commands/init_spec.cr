require "command"
require "commands/init"
require "spec_helper"

# TODO: Move this to E2E tests.
# This should only test #validate, #usage etc.
# The #run method needs to be tested in a more holistic manner.
describe DockerProjectManager::Init do
  describe "#run" do
    # it "requires an argument" do
    #   expect_raises(DockerProjectManager::NoCommandError) do
    #     DockerProjectManager::Command.run(["init"])
    #   end
    # end
  end
end
