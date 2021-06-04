load ~/.zsh/environments/helpers.zsh && save-function-list
load ~/.zsh/environments/emacs.zsh
load ~/.zsh/environments/basic.zsh

start-emacs-session
rename-first-tab

# Custom functions & aliases.
DH_REPO=jakubstastny/docker-project-manager

rspec() {
  bundle exec rspec
}

build() {
  # tag = args[:tag] ? "#{REPO}:#{args[:tag]}" : REPO
  tag=$DH_REPO
  docker build --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
               --build-arg VCS_REF=`git rev-parse --short HEAD` \
               --build-arg VERSION=$(egrep '^version: ' shard.yml | awk '{ print $2 }') . -t $tag
}

push() {
  docker push $DH_REPO
}

report-custom-functions

# VERSION = YAML.load_file('shard.yml')['version']


#   # The image is updated from Travis CI, this is just ad-hoc.
#   desc "Push the image to DockerHub"
#   task :push do
#     sh "docker push #{REPO}"
#   end

#   desc "Run SH in the image"
#   task :sh do
#     sh "docker run -it --rm -v $PWD/tmp:/projects --entrypoint /bin/sh #{REPO}"
#   end

#   namespace :test do
#     desc "Manually test the init command"
#     task :init do
#       sh "rm -rf tmp &> /dev/null; mkdir tmp"
#       sh "docker run -it --rm -v $PWD/tmp:/projects #{REPO} init my-blog"
#     end
#   end
# end

# namespace :test do
#   desc "Manually test the init command"
#   task :init do
#     # NOTE that we cannot change the current directory with crystal run, it won't find the shards.
#     sh "rm -rf my-blog"
#     sh "crystal run src/docker-project-manager.cr -- init my-blog"
#   end
# end
