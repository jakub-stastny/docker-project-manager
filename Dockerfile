FROM alpine:latest as builder
RUN apk add -u crystal shards libc-dev
WORKDIR /src
COPY . .
RUN crystal build --release --static project-manager.cr -o /src/project-manager

FROM busybox
WORKDIR /app
COPY --from=builder /src/project-manager /app/project-manager
ENTRYPOINT ["/app/project-manager"]
