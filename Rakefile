REPO = 'botanicus/docker-project-manager'

desc "Build the image"
task :build do
  sh "docker build . -t #{REPO}"
end

desc "Test the project manually"
task try: :build do
  sh "docker run -it --rm #{REPO}"
end
