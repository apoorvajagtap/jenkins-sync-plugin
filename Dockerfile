# This Dockerfile is intended for use by openshift/ci-operator config files defined
# in openshift/release for v4.x prow based PR CI jobs

FROM quay.io/openshift/origin-jenkins-agent-maven:4.11.0 AS builder
WORKDIR /java/src/github.com/openshift/jenkins-sync-plugin
COPY . .
USER 0
RUN mvn clean package

FROM registry.redhat.io/ocp-tools-4/jenkins-rhel8:v4.12.0
RUN rm /opt/openshift/plugins/openshift-sync.jpi
COPY --from=builder /java/src/github.com/openshift/jenkins-sync-plugin/target/openshift-sync.hpi /opt/openshift/plugins
RUN mv /opt/openshift/plugins/openshift-sync.hpi /opt/openshift/plugins/openshift-sync.jpi
COPY --from=builder /java/src/github.com/openshift/jenkins-sync-plugin/PR-Testing/download-dependencies.sh /usr/local/bin
RUN /usr/local/bin/download-dependencies.sh
