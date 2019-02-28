require "spec"
require "file_utils"

def tmp(&block)
  Dir.mkdir("tmp") unless Dir.exists?("tmp")
  Dir.cd("tmp", &block)
  FileUtils.rm_r("tmp")
end
