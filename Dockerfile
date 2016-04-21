FROM python:2.7-alpine

MAINTAINER zhengxiaoyao0716

RUN set -ex\
    && apk add --no-cache uwsgi uwsgi-python \
    && pip install --no-cache-dir flask supervisor \
    && echo_supervisord_conf > /etc/supervisord.conf

RUN mkdir /web
WORKDIR /web

# copy source folder
RUN mkdir ./src
ONBUILD COPY src /web/src/

# mount share folder
RUN mkdir ./share
VOLUME /web/share

# config supervisor
ONBUILD COPY programs.conf /web/
ONBUILD RUN echo -e "[include]\nfiles = /web/programs.conf" >> /etc/supervisord.conf

# install dependencies
ONBUILD COPY requirements.txt /web/
ONBUILD RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT supervisord -c /etc/supervisord.conf && /bin/sh