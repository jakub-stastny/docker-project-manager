# About

[DockerHub](https://cloud.docker.com/repository/docker/botanicus/docker-project-manager/general)

Help managing Docker development environment lifecycle.

Written in Crystal, distributed as a Docker multi-stage build image.

# Usage

```
docker pull botanicus/docker-project-manager
docker run -it --rm botanicus/docker-project-manager MY-PROJECT ENV_VAR_1 ENV_VAR_2=test
```

# Development

```
rake -T
# rake build       # Build the image
# rake docker:try  # Test the project manually in Docker
# rake try         # Test the project manually
```
