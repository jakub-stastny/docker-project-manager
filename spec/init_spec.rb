require "spec_helper"

describe "init", :command do
  context "with no arguments" do
    let(:command) do
      "docker run --rm jakubstastny/docker-project-manager init"
    end

    it "fails with an error message" do
      expect(stdout).to be_empty
      expect(stderr).to include("Usage: init [project_name]")
      expect(status).to eql(1)
    end
  end

  context "with one argument" do
    let(:command) do
      "docker run --rm -v $PWD/tmp:/projects jakubstastny/docker-project-manager init my-project"
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

    pending "generates an executable runner" do
      # TODO
      raise Exception.new
    end

    # Issue #25
    pending "generates SSH keys" do
      Dir.chdir("tmp") do
        path = Pathname.new("my-project/.ssh")
        expect(path).to exist
        expect(sprintf("%o", File.stat(path).mode)).to eql("41254")

        key_path = path.join("id_rsa")
        expect(key_path).to exist
        expect(File.stat(key_path).mode).to eql(33188)
        expect(sprintf("%o", File.stat(key_path).mode)).to eql("100644")
        expect(key_path.read).to match(/-+BEGIN PRIVATE KEY-+/)

        key_path = path.join("id_rsa.pub")
        expect(key_path).to exist
        expect(sprintf("%o", File.stat(key_path).mode)).to eql("100600")

        parts = key_path.read.chomp("\n").split(" ")
        expect(parts[0]).to eql("ssh-rsa")
        expect(parts[1]).to match(/^[\w\/+]{372}$/)
        expect(parts[2]).to eql("root@my-project")
      end
    end
  end
end
