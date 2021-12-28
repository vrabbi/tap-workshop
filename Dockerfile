FROM projects.registry.vmware.com/educates/base-environment

# All the direct Downloads need to run as root as they are going to /usr/local/bin
USER root
# TMC
RUN curl -L -o /usr/local/bin/tmc $(curl -s https://tanzupaorg.tmc.cloud.vmware.com/v1alpha/system/binaries | jq -r 'getpath(["versions",.latestVersion]).linuxX64') && \
  chmod 755 /usr/local/bin/tmc
# Policy Tools
RUN curl -L -o /usr/local/bin/opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64 && \
  chmod 755 /usr/local/bin/opa
# TBS
RUN curl -L -o /usr/local/bin/kp https://github.com/vmware-tanzu/kpack-cli/releases/download/v0.4.1/kp-linux-0.4.1 && \
  chmod 755 /usr/local/bin/kp
# Tanzu
RUN curl -o /usr/local/bin/tanzu https://storage.googleapis.com/tanzu-cli/artifacts/core/latest/tanzu-core-linux_amd64 && \
  chmod 755 /usr/local/bin/tanzu
COPY plugins/apps-artifacts /tmp/apps-artifacts
COPY plugins/apps-artifacts /tmp/apps-artifacts/
RUN tanzu plugin install apps --local /tmp/apps-artifacts --version v0.2.0
# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh
COPY files/wildcard.crt /usr/local/share/ca-certificates/ca.crt
RUN update-ca-certificates
# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

COPY kubectl-scp /usr/local/bin/kubectl-scp

COPY plugins/acc-artifacts /tmp/acc-artifacts
COPY plugins/acc-artifacts /tmp/acc-artifacts/
RUN tanzu plugin install accelerator --local /tmp/acc-artifacts --version v0.4.1
# Knative
RUN curl -L -o /usr/local/bin/kn https://github.com/knative/client/releases/download/v0.26.0/kn-linux-amd64 && \
    chmod 755 /usr/local/bin/kn
# Utilities
RUN apt-get update && apt-get install -y unzip
RUN curl -L -o /usr/local/bin/hey https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 && \
  chmod 755 /usr/local/bin/hey
# VSCODE
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version 4.0.0
RUN mv /usr/bin/code-server /opt/code-server/bin/code-server
RUN code-server --install-extension redhat.vscode-yaml
RUN code-server --install-extension redhat.java
RUN code-server --install-extension vscjava.vscode-java-pack
COPY tanzu-vscode-extension.vsix /opt/tanzu-vscode-extension.vsix
RUN code-server --install-extension /opt/tanzu-vscode-extension.vsix
RUN echo -n 'export PATH=~/.local/bin:$PATH' >> /etc/profile
RUN chown eduk8s:users /home/eduk8s/.cache
RUN curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash
RUN chown -R eduk8s:users /home/eduk8s/.tilt-dev
USER 1001
RUN curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | PATH=~/.local/bin:$PATH bash
