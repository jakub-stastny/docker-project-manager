REPO = 'botanicus/docker-project-manager'

namespace :docker do
  desc "Build the image"
  task :build do
    sh "docker build . -t #{REPO}"
  end

  desc "Run SH in the image"
  task :sh do
    sh "docker run -it --rm --entrypoint /bin/sh #{REPO}"
  end

  namespace :test do
    desc "Manually test the init command"
    task :init do
      sh "rm -rf tmp &> /dev/null; mkdir tmp"
      sh "docker run -it --rm -v tmp:/root/projects botanicus/docker-project-manager init my-blog"
    end
  end
end

namespace :test do
  desc "Manually test the init command"
  task :init do
    #sh "rm -rf tmp &> /dev/null; mkdir -p tmp/projects"
    sh "crystal run ../src/docker-project-manager.cr -- init my-blog"
  end
end

desc "Run the tests"
task :test do
  sh "crystal spec"
end

desc "Format the code based on the Crystal conventions"
task :format do
  sh "crystal tool format"
end
