FROM jakubstastny/dev:latest as builder

RUN apt-get install -y crystal libgmp-dev
WORKDIR /src
#COPY shard.* ./
#RUN shards install
COPY . .
RUN crystal env
# This works fine locally, but unfortunatelly not on Travis.
RUN export CRYSTAL_PATH=$(crystal env | grep CRYSTAL_PATH | awk -F= '{ print $2 }'):./src:./spec/unit && echo "CRYSTAL_PATH:$CRYSTAL_PATH" && crystal spec spec/unit && echo OK && crystal build --release --static src/docker-project-manager.cr -o /src/project-manager
#RUN export CRYSTAL_PATH=$(crystal env | grep CRYSTAL_PATH | /opt/rubies/*/bin/ruby -ne 'puts $_.split(/=/).last[1..-3]'):./src:./spec/unit && echo "CRYSTAL_PATH:$CRYSTAL_PATH"

# Because of HTTP::Client not working with static, removing --static for now.
# https://github.com/crystal-lang/crystal/issues/6099
RUN crystal build --release --static src/docker-project-manager.cr -o /src/project-manager
# RUN crystal build --release src/docker-project-manager.cr -o /src/project-manager
# ... but removing it fucks up everything. Awesome shit.

FROM busybox

# For microbadger.com
# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="docker-project-manager" \
      org.label-schema.description="Quickly spin off Docker containers for prototyping and development with your full dev environment, dotfiles and tools of choice." \
      org.label-schema.url="https://github.com/jakub-stastny/docker-project-manager" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/jakub-stastny/docker-project-manager" \
      org.label-schema.vendor="Jakub Šťastný" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

WORKDIR /app
COPY --from=builder /src/project-manager /app/project-manager
COPY templates /app/templates
WORKDIR /projects
ENTRYPOINT ["/app/project-manager"]
