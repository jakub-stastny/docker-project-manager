REPO = 'botanicus/docker-project-manager'

namespace :docker do
  desc "Build the image"
  task :build do
    sh "docker build . -t #{REPO}"
  end

  desc "Run SH in the image"
  task :sh do
    sh "docker run -it --rm -v $PWD/tmp:/projects --entrypoint /bin/sh #{REPO}"
  end

  namespace :test do
    desc "Manually test the init command"
    task :init do
      sh "rm -rf tmp &> /dev/null; mkdir tmp"
      sh "docker run -it --rm -v $PWD/tmp:/projects botanicus/docker-project-manager init my-blog"
    end
  end
end

namespace :test do
  desc "Manually test the init command"
  task :init do
    # NOTE that we cannot change the current directory with crystal run, it won't find the shards.
    sh "rm -rf my-blog"
    sh "crystal run src/docker-project-manager.cr -- init my-blog"
  end
end

desc "Run the tests"
task test: 'docker:build' do
  sh "bundle exec rspec"
end

desc "Format the code based on the Crystal conventions"
task :format do
  sh "crystal tool format"
end
