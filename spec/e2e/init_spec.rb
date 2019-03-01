require "e2e/spec_helper"

describe "init", :command do
  context "with no arguments" do
    let(:command) do
      "docker run --rm botanicus/docker-project-manager init"
    end

    it "fails with an error message" do
      expect(stdout).to be_empty
      expect(stderr).to include("Usage: init [project_name]")
      expect(status).to eql(1)
    end
  end

  context "one argument" do
    let(:command) do
      "docker run --rm -v $PWD/tmp:/projects botanicus/docker-project-manager init my-project"
    end

    it "succeeds and prints out the next steps" do
      expect(stdout[0]).to match(/You initiated project my-project/)
      expect(stdout[1]).to match(/Things to note:/)
      expect(stderr).to be_empty
      expect(status).to eql(0)
    end

    it "generates README.md" do
      Dir.chdir("tmp") do
        path = Pathname.new("my-project/README.md")
        expect(path).to exist

        expect(path.read).to match(/# About/)
      end
    end

    it "generates Dockerfile" do
      Dir.chdir("tmp") do
        path = Pathname.new("my-project/Dockerfile")
        expect(path).to exist

        expect(path.read).to match(/^FROM /)
        expect(path.read).to match(/^#?VOLUME /)
        expect(path.read).to match(/^#?EXPOSE /)
      end
    end

    it "generates SSH keys" do
      Dir.chdir("tmp") do
        path = Pathname.new("my-project/.ssh")
        expect(path).to exist
        expect(File.stat(path).mode).to eql(17068)

        key_path = path.join("id_rsa")
        expect(key_path).to exist
        expect(File.stat(key_path).mode).to eql(33188)
        expect(key_path.read).to match(/-+BEGIN PRIVATE KEY-+/)

        key_path = path.join("id_rsa.pub")
        expect(key_path).to exist
        expect(File.stat(key_path).mode).to eql(33152)
        expect(key_path.read).to match(/-+BEGIN PUBLIC KEY-+/)
      end
    end
  end
end
