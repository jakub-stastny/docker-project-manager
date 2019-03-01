FROM botanicus/dev:latest as builder
RUN apt-get install -y crystal libgmp-dev
WORKDIR /src
COPY . .
RUN shards install
RUN crystal build --release --static src/docker-project-manager.cr -o /src/project-manager

FROM busybox
WORKDIR /app
COPY --from=builder /src/project-manager /app/project-manager
COPY templates /app/templates
WORKDIR /projects
ENTRYPOINT ["/app/project-manager"]
