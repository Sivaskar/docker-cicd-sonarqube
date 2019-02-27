FROM openjdk:10-jdk-slim
LABEL version="1.0" maintainer="Sivaskar"
ENV SONAR_SCANNER_VERSION 3.3.0.1492

# install tools
# https://github.com/docker-library/buildpack-deps/blob/b0fc01aa5e3aed6820d8fed6f3301e0542fbeb36/sid/curl/Dockerfile
# plus git and ssh
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    vim \
    && rm -rf /var/lib/apt/lists/*

# https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner
# install sonar-scanner
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip && \
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
    unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux -d /usr/local/share/ && \
    chown -R node: /usr/local/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux

ENV SONAR_RUNNER_HOME "/usr/local/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux"
ENV PATH="${SONAR_RUNNER_HOME}/bin:${PATH}"

# install dumb-init
# https://engineeringblog.yelp.com/2016/01/dumb-init-an-init-for-docker.html
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

USER sonar
ENTRYPOINT ["dumb-init", "--"]
CMD ["sonar-scanner"]
