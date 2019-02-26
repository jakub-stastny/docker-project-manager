REPO = 'botanicus/docker-project-manager'

desc "Build the image"
task :build do
  sh "docker build . -t #{REPO}"
end

desc "Test the project manually"
task try: :build do
  sh "docker run -it --rm #{REPO}"
end

desc "Run locally"
task :run do
  sh "crystal run project-manager.cr -- test-project"
end
