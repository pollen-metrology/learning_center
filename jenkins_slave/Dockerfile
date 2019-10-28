#The MIT License
#
#  Copyright (c) 2015-2018, CloudBees, Inc. and other Jenkins contributors
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

# docker build -t learning_center_jenkins_slave .
FROM ubuntu:16.04
LABEL MAINTAINER Pollen Metrology <admin-team@pollen-metrology.com>

ARG VERSION=3.28
ARG user=jenkins
ARG group=jenkins
ARG uid=2222
ARG AGENT_WORKDIR=/home/jenkins/

# https://docs.docker.com/get-started/part2/#build-the-app
# https://github.com/shufo/jenkins-slave-ubuntu/blob/master/Dockerfile
# https://github.com/jenkinsci/docker-slave
# https://github.com/jenkinsci/docker-jnlp-slave

RUN apt-get clean
RUN apt update

# Install JDK 7 (latest edition)
RUN apt install -y --no-install-recommends default-jdk

# Install utilities
RUN apt install -y curl locales locales-all

# Add user jenkins to the image
RUN adduser --system --quiet --uid ${uid} --group --disabled-login jenkins


RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

# USER jenkins
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/jenkins/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/jenkins/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/jenkins

RUN mkdir -p /home/pollen && chown jenkins:jenkins /home/pollen && ln -s /home/pollen /pollen


# If you put this label at the beginning of the Dockerfile, docker seems to use cache and build fails more often
#LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="1.2"

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


COPY jenkins-slave.sh /usr/bin/jenkins-slave.sh
RUN chmod +x /usr/bin/jenkins-slave.sh

# Git
RUN apt-get install -y git

ENTRYPOINT ["/usr/bin/jenkins-slave.sh"]