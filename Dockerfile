FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7:v3.6.173.0.5-5

# https://docs.projectatomic.io/container-best-practices/#_labels
# https://github.com/projectatomic/ContainerApplicationGenericLabels
# https://docs.openshift.org/latest/creating_images/metadata.html
# https://docs.docker.com/engine/userguide/labels-custom-metadata/
# https://speakerdeck.com/garethr/shipping-manifests-bill-of-lading-and-docker-metadata-and-container
#
# ATOMIC LABELS
#
# 1. STATIC LABELS:
#
LABEL architecture="x86_64" \
      authoritative-source-url="https://registry-console-default.apps-build.evobanco.local" \
      changelog-url="https://github.com/EVO/docet-docker-library/CHANGELOG" \
      description="Taurus is an automation-friendly framework for Continuous Testing \
                   The Jenkins slave Taurus image has Taurus installed \
                   on top of the OpenShift Jenkins slave base image." \
      distribution-scope="private" \
      docker.dockerfile="/root/buildinfo/Dockerfile_Jenkins_agent_Taurus" \
      license="Worldpay" \
      maintainer="Devops <devops@evobanco.com>" \
      name="ci/caas-jenkins-slave-taurus-rhel7" \
      summary="The Jenkins slave Taurus image has Taurus installed \
               on top of the OpenShift Jenkins slave base image." \
      url="https://gettaurus.org/" \
      vcs-type="git" \
      vcs-url="https://github.com/EVO/jenkins-slave-taurus-rhel7.git" \
      vendor="Pipy" \
      version="1.9.5"
#
# 2. DYNAMIC LABELS:
#
#LABEL build-date "2017-07-07T21:54:52,383192881+01:00" # date -Ins \
#      release "1" \
#      release-date "2017-07-07T21:54:52,383192881+01:00" # date -Ins \
#      vcs-ref A 'reference' within the repository; e.g. a git commit "364a2a"
#
# 3. ACTION LABELS:
#
LABEL run="docker run -d --name \${NAME} \${IMAGE} \
          -v /etc/machine-id:/etc/machine-id:ro \
          -v /etc/localtime:/etc/localtime:ro \
          -e IMAGE=IMAGE -e NAME=NAME" \
      stop="docker stop \${NAME}"
#
# OPENSHIFT LABELS
#
LABEL io.k8s.description="The Jenkins slave Taurus image has Taurus installed \
                          on top of the OpenShift Jenkins slave base image." \
      io.k8s.display-name="Jenkins Agent Taurus" \
      io.openshift.min-memory="1Gi" \
      io.openshift.min-cpu="1" \
      io.openshift.non-scalable="true" \
      io.openshift.tags="openshift,jenkins,agent,taurus"
#
# VENDOR LABELS
#
LABEL com.evobanco.is-beta="False" \
      com.evobanco.is-production="True"
#
# DOCUMENTATION
#
# http://docs.projectatomic.io/container-best-practices/#_creating_a_help_file
COPY help.1 /help.1
# https://docs.projectatomic.io/container-best-practices/#_location_2
RUN mkdir -p /root/buildinfo
COPY Dockerfile /root/buildinfo/Dockerfile_Jenkins_agent_Taurus

ENV BASH_ENV /usr/local/bin/scl_enable

# add internal CAs
# RUN curl -k https://github.com/raw/EVO/certs/master/bundle/bundle.pem \
#         -x ${HTTPS_PROXY} \
#         -o /etc/pki/ca-trust/source/anchors/evobanco.local_bundle.pem
#    update-ca-trust

# Install Taurus and its dependencies
RUN yum -y install --setopt=tsflags=nodocs \
        --enablerepo=rhel-7-server-rpms \
        --enablerepo=rhel-server-rhscl-7-rpms \
          gcc \
          java-1.8.0-openjdk-headless \
          libxml2-devel \
          libxslt-devel \
          python27-python-devel \
          python27-python-pip \
          zlib && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    source scl_source enable python27 && \
    pip install bzt && \
    printf "source scl_source enable python27" > /usr/local/bin/scl_enable && \
    chmod a+x /usr/local/bin/scl_enable

# jenkins-slave-base leaves USER as root
USER 1001
