FROM registry.access.redhat.com/ubi8/python-38

ENV description = ""

LABEL maintainer="timbuchinger@gmail.com"
LABEL description="$DESCRIPTION"

USER root

RUN dnf -y update-minimal --security --sec-severity=Important --sec-severity=Critical && \
    dnf -y install git && \
    dnf clean all

USER default

RUN pip3 install --upgrade pip setuptools
COPY requirements.txt .
RUN pip3 install -r requirements.txt
RUN ansible-galaxy collection install google.cloud
RUN ansible-galaxy collection install amazon.aws community.aws
RUN ansible-galaxy collection install azure.azcollection community.azure

WORKDIR /data
ENTRYPOINT ["ansible-lint"]
CMD ["--version"]
