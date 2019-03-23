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
      # request = HTTP::Client.new(URI.parse("https://raw.githubusercontent.com"))
      # response = request.get("/botanicus/docker-project-manager/master/templates/runner")

      unless response.status_code == 200
        puts "! ERROR: Cannot download. Status code: #{response.status_code}"
      end

      etag = response.headers["ETag"]

      if etag == self.last_etag
        puts "~ Runner unchanged." && return
      else
        puts "~ Updating runner #{self.last_etag.inspect} -> #{etag.inspect}."
      end

      body = response.body.lines.join("\n")
      body = self.replace_variables(body)
      body = self.add_etag(body.split("\n"), etag)

      FileUtils.mv("runner", "runner.backup")

      File.open("runner", "w", 0o755) do |file|
        file.puts(body)
      end
    end
  end

  private def last_etag : String
    File.read_lines("runner")[1].sub(/^# /, "")
  end

  private def add_etag(lines, etag) : String
    [lines[0], "# #{etag}", lines[1..-1]].flatten.join("\n")
  end

  private def replace_variables(body) : String
    body.gsub(PROJECT_HOST_PATH_REGEXP, self.project_host_path)
  end
end
