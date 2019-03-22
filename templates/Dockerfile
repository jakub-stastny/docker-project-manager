# This is a recipe for your dev environment for {{ project_name }}.
# Do not confuse it with your project's deployment Dockerfile.

# Your base dev image with your tools and configuration.
FROM botanicus/dev:latest

# Your secret variables.
#ENV AWS_TOKEN 1234567890

# Do any setup here.
#RUN ...

# Most of the projects have only one volume that matches the name of the project.
# For instance if I have project my-blog, then the top-level directory my-blog/
# will typically contain a nested my-blog directory.
#
# This is because the top-level directory contains various persistent data such as
# SSH keys and shell history, whereas the nested directory is just the Git repository
# of your project.
#
# Note also that this Dockerfile is not used only by Docker: it's also used by DPM.
#
# Docker doesn't support specifying host directory (and host port) through Dockerfile.
# Quite logically so: there must be no assumption about the host.
#
# However, DPM does dictate the structure, so it is making these assumptions.
# So if you specify VOLUME {{ project_name}} here, DPM by default will mount
# such volume to {{ project_name }} within the top-level {{ project_name }} directory.
VOLUME /root/.history # Or .bash_history if you are using Bash.
VOLUME /root/.ssh
VOLUME /projects/{{ project_name }}

# Beware, magic ahead!
# A common directory that you want to persist out of the scope of the repository is
# the Git hooks directory. It's an easy thing to do, however there is one caveat:
# You have to clone your repository first.
#
# This is why it's commented out by default. Uncomment it when you're ready to roll.
#VOLUME /projects/{{ project_name }}/.git/hooks

# Just like DPM dictates where the volumes gets mounted, all the exposed ports are also published.
#EXPOSE 3000
