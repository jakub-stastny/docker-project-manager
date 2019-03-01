REPO = 'botanicus/docker-project-manager'

desc "Build the image"
task :build do
  sh "docker build . -t #{REPO}"
end

desc "Run SH in the image"
task :sh do
  sh "docker run -it --rm --entrypoint /bin/sh #{REPO}"
end

desc "Test the project manually"
task :try do
  sh "crystal run src/docker-project-manager.cr -- test-project DROPBOX_ACCESS_KEY PROWL_API_KEY=test"
end

desc "Test the project manually in Docker"
task 'docker:try' => :build do
  sh "docker run -it --rm #{REPO} test-project DROPBOX_ACCESS_KEY PROWL_API_KEY=test"
end

desc "Run the tests"
task :test do
  sh "crystal spec"
end

desc "Format the code based on the Crystal conventions"
task :format do
  sh "crystal tool format"
end
