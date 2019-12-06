FROM debian:buster-slim
# hadolint ignore=DL3015
RUN apt-get update \
  && apt-get install -y curl=7.64.0-4 unzip=6.0-23+deb10u1 python=2.7.16-1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
  unzip awscli-bundle.zip && \
  ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
CMD ["/bin/sh"]