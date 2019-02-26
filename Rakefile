REPO = 'botanicus/docker-project-manager'

desc "Build the image"
task :build do
  sh "docker build . -t #{REPO}"
end

desc "Test the project manually"
task :try do
  sh "crystal run project-manager.cr -- test-project DROPBOX_ACCESS_KEY"
end

desc "Test the project manually in Docker"
task 'docker:try' => :build do
  sh "docker run -it --rm #{REPO} test-project DROPBOX_ACCESS_KEY"
end
