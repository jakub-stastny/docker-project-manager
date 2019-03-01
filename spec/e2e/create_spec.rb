require "e2e/spec_helper"

describe "create", :command do
  context "with no arguments" do
    let(:command) do
      "docker run --rm botanicus/docker-project-manager create"
    end

    it "fails with an error message" do
      expect(stdout).to be_empty
      # expect(stderr).to include("Usage: create [project_name]")
      expect(status).to eql(1)
    end
  end

  context "with one argument" do
    let(:command) do
      <<~EOF
        # docker run --rm -v $PWD/tmp:/projects botanicus/docker-project-manager init my-project &> /dev/null
        docker run --rm -v $PWD/tmp:/projects botanicus/docker-project-manager create my-project
      EOF
    end

    it "succeeds and prints out the next steps" do
      expect(stdout[0]).to eql("docker build . -t my-project-dev-env")
      expect(stdout[1]).to match("docker create -v /var/run/docker.sock:/var/run/docker.sock -v /root/.history:/root/.history -v /root/.ssh:/root/.ssh -v /root/my-project:/root/my-project -p 3000:3000 my-project-dev-env")
      expect(stdout[2]).to match(/Next steps:/)
      expect(stderr).to be_empty
      expect(status).to eql(0)
    end

    it "creates a Docker container based on the specifications from Dockerfile" do
      # TODO
    end
  end
end

