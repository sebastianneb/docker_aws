FROM debian:buster-slim

# Install needed basics
# hadolint ignore=DL3015
RUN apt-get update \
  && apt-get install -y curl=7.64.0-4 unzip=6.0-23+deb10u1 python=2.7.16-1 python-pip=18.1-5 less=487-0.1+b1 groff=1.22.4-3 git=1:2.20.1-2+deb10u1 locales=2.28-10 build-essential=12.6 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV PATH="/home/aws/.linuxbrew/bin:/home/aws/.local/bin:${PATH}"

# Create specific user for brew
RUN useradd -ms /bin/bash aws
USER aws
WORKDIR /home/aws

# Install aws-cli
ENV AWS_VERSION 1.16.302
RUN pip install awscli --upgrade --user

# Install and configure brew
ENV BREW_VERSION 2.2.1
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" \
  && echo "eval $(/home/aws/.linuxbrew/bin/brew shellenv)" >>/home/aws/.bashrc \
  && eval "$(/home/aws/.linuxbrew/bin/brew shellenv)"

# Install and configure sam
ENV SAM_VERSION 0.37.0
RUN brew tap aws/tap \
  && brew install aws-sam-cli \
  && sam --version

# Labels
ARG BUILD_TIME
ARG REPOSITORY_URL
ARG REVISION
ARG VERSION

LABEL maintainer="Sebastian Neb <Sebastian.Neb@me.com>"
LABEL name="sebastianneb/aws_deployer"
LABEL title="AWS Deployer"
LABEL org.opencontainers.image.created=$BUILD_TIME
LABEL org.opencontainers.image.authors="Sebastian Neb <Sebastian.Neb@me.com>"
LABEL org.opencontainers.image.url=$REPOSITORY_URL
LABEL org.opencontainers.image.documentation=$REPOSITORY_URL
LABEL org.opencontainers.image.source=$REPOSITORY_URL
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.vendor="Sebastian Neb"
LABEL org.opencontainers.image.title="AWS Deployer"
LABEL org.opencontainers.image.description="Simple Docker image based on debian:buster-slim that contains aws-cli and sam-cli"

CMD ["/bin/bash"]