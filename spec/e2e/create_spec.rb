require "e2e/spec_helper"

describe "create", :command do
  context "with no arguments" do
    let(:command) do
      "docker run --rm botanicus/docker-project-manager create"
    end

    it "fails with an error message" do
      expect(stdout).to be_empty
      expect(stderr).to include("Usage: create [project_name] [project_host_path]")
      expect(status).to eql(1)
    end
  end

  context "with one argument" do
    # TODO
  end

  context "with two arguments" do
    let(:command) do
      <<~EOF
        docker run --rm -v $PWD/tmp:/projects botanicus/docker-project-manager init my-project > /dev/null
        docker run --rm -v $PWD/tmp:/projects botanicus/docker-project-manager create my-project ~/projects
      EOF
    end

    it "succeeds and prints out the next steps" do
      expect(stderr).to be_empty
      expect(stdout[0]).to eql("cd #{ENV['HOME']}/projects/my-project")
      expect(stdout[1]).to eql("docker build . -t my-project-dev-env")
      expect(stdout[2]).to match("docker create -it -v /var/run/docker.sock:/var/run/docker.sock -v #{ENV['HOME']}/projects/my-project/.history:/projects/.history -v #{ENV['HOME']}/projects/my-project/.ssh:/projects/.ssh -v #{ENV['HOME']}/projects/my-project/my-project:/projects/my-project  --network host --name my-project-dev-env --hostname my-project my-project-dev-env")
      expect(stdout[3]).to match(/Next steps:/)
      expect(status).to eql(0)
    end

    it "creates a Docker container based on the specifications from Dockerfile" do
      # TODO
    end
  end
end

