require "http/client"
require "file_utils"

class DockerProjectManager::Update < DockerProjectManager::Command
  PROJECT_HOST_PATH_REGEXP = /{{\s*project_host_path\s*}}/ # Copied from init. Refactor.
  RUNNER_URL = "https://raw.githubusercontent.com/botanicus/docker-project-manager/master/templates/runner"

  def usage : String
    "#{@name} [project_host_path]"
  end

  def validate : Nil
    unless @args.size == 1
      raise CommandArgumentError.new(self.usage)
    end
  end

  def project_host_path : String
    @args.first
  end

  def run : Nil
    Dir.cd("/root/project-directory") do
      response = HTTP::Client.get(RUNNER_URL)
      unless response.status_code == 200
        puts "! ERROR: Cannot download. Status code: #{response.status_code}"
      end

      if response.headers["ETag"] == self.last_etag
        puts "~ Runner unchanged." and return
      else
        puts "~ Updating runner."
      end

      body = response.body.lines.join("\n").gsub(PROJECT_HOST_PATH_REGEXP, self.project_host_path)

      lines = body.split("\n")
      body = [lines[0], "# #{response.headers["ETag"]}", *lines[1..-1]].join("\n")

      FileUtils.mv("runner", "runner.backup")

      File.open("runner", "w", 0o755) do |file|
        file.puts(body)
      end
    end
  end

  private def last_etag
    File.read_lines("runner")[1].sub(/^# /, "")
  end
end
