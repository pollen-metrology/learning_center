# Build docker Moodle
# docker build -t learning_center .
FROM bitnami/moodle:3.7.0
LABEL MAINTAINER Pollen Metrology <admin-team@pollen-metrology.com>

USER root

RUN apt-get update

RUN apt-get install -y vim

WORKDIR /bitnami