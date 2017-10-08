FROM ubuntu:xenial

RUN  useradd --shell /bin/bash -u 1000 -o -c "" -m dehydrated

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /dehydrated

RUN git clone https://github.com/lukas2511/dehydrated . && mkdir hooks && git clone https://github.com/kappataumu/letsencrypt-cloudflare-hook hooks/cloudflare && pip3 install -r hooks/cloudflare/requirements.txt && sed -i '1c\#!/usr/bin/python3' hooks/cloudflare/hook.py

ENV DOCKERIZE_VERSION v0.5.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY config.tmpl config.tmpl

RUN chown -R dehydrated /dehydrated

USER dehydrated

VOLUME /dehydrated/certs
VOLUME /dehydrated/accounts

ENTRYPOINT ["dockerize", "-template", "config.tmpl:config", "bash", "dehydrated", "-t", "dns-01", "-k", "hooks/cloudflare/hook.py"]
