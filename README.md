# About

[DockerHub](https://cloud.docker.com/repository/docker/botanicus/docker-project-manager/general)

Help managing Docker development environment lifecycle.

Written in Crystal, distributed as a Docker multi-stage build image.

# Architecture

The less changes we have to do manually on each VPS, the easier is the management.

This project proposes that all you need to install is <abbr title="And Mosh if you're so inclined">Docker</abbr>.

Everything else should happen in Docker containers.

Please note that I'm talking about the _development_ phase. This is not an alternative to `docker-compose`: in fact we are using `docker-compose` for managing more complex setup.

## Copy of development environment

Dotfiles has been around for a while. It's indeed a good idea to have all the shell, Vim and other configuration files in one place and versioned.

Still. You get a new VPS, fetch your dotfiles and then you're installing and installing. Software from the OS package manager, Vim plugins, development dependencies, your dev tools ... it makes a lot of sense bake all this into a Docker image.

## Docker-in-Docker

Since the development environment is an equivalent of our development machine, it's logical that we'll want to use Docker inside it.

This is possible and all the projects are automatically configured to support Docker-in-Docker.

That way every container feels like a real VM with no limitations.

## Isolation

So on our development VPS, instead of spinning this image and doing everything in it, it makes sense to spin a container for each project we are working on.

## Persistence

When we spin a new container using `docker create`, the container is running. So our tmux session never dies.

Let's say we messed up the environment and we want to recreate it.

It'd be a huge bummer if our shell history and SSH keys (that are created per-project) would die with the old container.

That's why every project has its folder. It typically has:

- `Dockerfile` to define ports that should be exposed (and published!), environment variables and volumes. Unlike the base development environment container, the image build from this `Dockerfile` is not meant to be published. This way we can bake in environment variables such as API keys and access tokens that are not meant for 3rd parties to see.
- **SSH keys directory** and **shell history file** to be shared as volumes inside the container.

Note that there's no global state. It makes sense to isolate everything per project. If you want for instance use the same pair of SSH keys, just copy them to the project directory. This way it's all predictable and there are no surprises.

# Usage

_This is changing._

```
docker pull botanicus/docker-project-manager
docker run -it --rm botanicus/docker-project-manager MY-PROJECT ENV_VAR_1 ENV_VAR_2=test
```

# Development

```
rake -T
# rake build       # Build the image
# rake sh          # Run SH in the image
# rake docker:try  # Test the project manually in Docker
# rake try         # Test the project manually
```
