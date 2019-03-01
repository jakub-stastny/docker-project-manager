FROM botanicus/dev:latest as builder
RUN apt-get install -y crystal libgmp-dev
WORKDIR /src
COPY shard.* ./
RUN shards install
COPY . .
# This works fine locally, but unfortunatelly not on Travis.
# RUN export CRYSTAL_PATH=$(crystal env | grep CRYSTAL_PATH | /opt/rubies/*/bin/ruby -ne 'puts $_.split(/=/).last[1..-3]'):./src:./spec/unit && echo "CRYSTAL_PATH:$CRYSTAL_PATH" && crystal spec spec/unit && echo OK && crystal build --release --static src/docker-project-manager.cr -o /src/project-manager
RUN export CRYSTAL_PATH=$(crystal env | grep CRYSTAL_PATH | /opt/rubies/*/bin/ruby -ne 'puts $_.split(/=/).last[1..-3]'):./src:./spec/unit && echo "CRYSTAL_PATH:$CRYSTAL_PATH"
RUN crystal build --release --static src/docker-project-manager.cr -o /src/project-manager

FROM busybox
WORKDIR /app
COPY --from=builder /src/project-manager /app/project-manager
COPY templates /app/templates
WORKDIR /projects
ENTRYPOINT ["/app/project-manager"]
