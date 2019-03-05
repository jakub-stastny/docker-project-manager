require "open3"
require "pathname"

module ShellCommandInspector
  ANSI_SEQUENCE = /\e\[(\d+)(;\d+)*m/

  def self.included(base)
    base.instance_eval do
      let(:result) { Open3.capture3(command) }
      let(:stdout) { result[0].gsub(ANSI_SEQUENCE, '').split("\n").grep_v(/^(~ .+|)$/) }
      let(:stderr) { result[1].gsub(ANSI_SEQUENCE, '').split("\n") }
      let(:status) { result[2].exitstatus }
    end
  end
end

RSpec.configure do |config|
  config.include ShellCommandInspector, :command

  config.before(:all) do
    system("rm -rf tmp; true")
  end
end
