FROM registry.access.redhat.com/ubi8/ubi:8.5

ENV description = ""

LABEL maintainer="timbuchinger@gmail.com"
LABEL description="$DESCRIPTION"

RUN dnf -y install python3 git
RUN pip3 install --upgrade --user pip setuptools
#RUN pip3 install --upgrade --user
RUN pip3 install ansible ansible-lint
#RUN ansible-galaxy collection install google.cloud
#RUN ansible-galaxy collection install amazon.aws community.aws
#RUN ansible-galaxy collection install azure.azcollection community.azure

WORKDIR /data
ENTRYPOINT ["ansible-lint"]
CMD ["--version"]