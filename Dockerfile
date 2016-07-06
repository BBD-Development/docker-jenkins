FROM jenkins:1.651.2
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
      && apt-get -y install docker.io \
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
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# Set Defaults
ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS="--webroot=/var/cache/jenkins/war"
