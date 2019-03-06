require "command"
require "commands/init"
require "spec_helper"

describe DockerProjectManager::Init do
#   describe "#run" do
#     # it "requires an argument" do
#     #   expect_raises(DockerProjectManager::NoCommandError) do
#     #     DockerProjectManager::Command.run(["init"])
#     #   end
#     # end

#     # TODO: Move this to E2E tests.
#     # This should only test #validate, #usage etc.
#     # The #run method needs to be tested in a more holistic manner.
#     pending "creates a directory matching the project name" do
#       command = DockerProjectManager::Init.new("init", ["my-blog", "../../templates"])
#       tmp do
#         command.run

#         Dir.exists?("my-blog").should be_true
#         Dir.cd "my-blog"
#         File.exists?("README.md").should be_true
#         File.exists?("Dockerfile").should be_true
#         File.read("README.md").should_not match(/project_name/)

#         Dir.exists?(".ssh").should be_true
#         File.exists?(".ssh/id_rsa").should be_true
#         File.exists?(".ssh/id_rsa.pub").should be_true
#       end
#     end
#   end
end
