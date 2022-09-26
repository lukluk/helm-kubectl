FROM alpine:3.13.6

ARG KUBE_VERSION
ARG HELM_VERSION

COPY tools ./tools
RUN chmod +x ./tools/*

RUN apk add --no-cache ca-certificates bash git openssh curl gettext jq bind-tools \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && chmod g+rwx /root \
    && mkdir /config \
    && chmod g+rwx /config \
    && apk add git \
    && apk add --no-cache make \
    && apk add --update docker openrc \
    && rc-update add docker boot \
    && helm repo add "stable" "https://charts.helm.sh/stable" --force-update \
    && apk add --no-cache python3 py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir awscli \
    && rm -rf /var/cache/apk/* \
    && mkdir /root/.kube \
    && mkdir /root/.aws  

WORKDIR /config

CMD bash
