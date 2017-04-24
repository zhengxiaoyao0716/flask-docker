FROM python:3.5-alpine

MAINTAINER zhengxiaoyao0716

RUN mkdir /web
WORKDIR /web

# base environment
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        # for uwsgi complie
        gcc \
        libc-dev \
        linux-headers \
        # for uwsgi-websocket support
        openssl-dev \
    && pip install --no-cache-dir uwsgi \
    && apk del .build-deps

# copy source folder
RUN mkdir ./src
ONBUILD COPY src /web/src/

# mount share folder
RUN mkdir ./share
VOLUME /web/share

# install dependencies
RUN python -m venv .env
# RUN rm /usr/local/bin/pip /usr/local/bin/python
# RUN ln -s /web/.env/bin/pip /usr/local/bin/pip
# RUN ln -s /web/.env/bin/python /usr/local/bin/python
RUN /web/.env/bin/pip install --no-cache-dir flask
ONBUILD COPY requirements.txt /web/
ONBUILD RUN /web/.env/bin/pip install --no-cache-dir -r requirements.txt

# config timezone
ONBUILD COPY localtime /web/
ONBUILD RUN set -ex \
    && rm /etc/localtime \
    && ln -s /web/localtime /etc/localtime

# CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
