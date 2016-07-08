FROM jenkins:1.651.3
MAINTAINER Stephen Doxsee

ENV LANG=en_US.UTF-8

# Prep Jenkins Directories
USER root
# Refs:
# https://forums.docker.com/t/how-to-run-docker-inside-a-container-running-on-docker-for-mac/16268/2
# http://container-solutions.com/running-docker-in-jenkins-in-docker/

RUN mkdir /var/cache/jenkins \
      && chown -R jenkins:jenkins /var/cache/jenkins \
      && apt-get update -qq \
      && apt-get install -y apt-transport-https ca-certificates \
      && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
      && echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list \
      && apt-get update -qq \
      && apt-cache policy docker-engine \
      && apt-get install -y docker-engine \
      && curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
      && chmod +x /usr/local/bin/docker-compose \
      && apt-get install -y sudo \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
USER jenkins

# Set list of plugins to download / update in plugins.txt like this
# pluginID:version
# credentials:1.18
# maven-plugin:2.7.1
# ...
# NOTE : Just set pluginID to download latest version of plugin.
# NOTE : All plugins need to be listed as there is no transitive dependency resolution.
ADD plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# Set Defaults
ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS="--webroot=/var/cache/jenkins/war"
