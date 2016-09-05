FROM python:2.7-alpine

MAINTAINER zhengxiaoyao0716

RUN mkdir /web
WORKDIR /web

# base environment
RUN set -ex \
    && apk add --no-cache uwsgi uwsgi-python \
    && pip install --no-cache-dir virtualenv

# # config supervisor
# RUN set -ex \
#     && pip install --no-cache-dir supervisor \
#     && echo_supervisord_conf > /etc/supervisord.conf
# ONBUILD COPY programs.conf /web/
# ONBUILD RUN echo -e "[include]\nfiles = /web/programs.conf" >> /etc/supervisord.conf

# copy source folder
RUN mkdir ./src
ONBUILD COPY src /web/src/

# mount share folder
RUN mkdir ./share
VOLUME /web/share

# install dependencies
RUN virtualenv .virtualenv
RUN rm /usr/local/bin/pip /usr/local/bin/python
RUN ln -s /web/.virtualenv/bin/pip /usr/local/bin/pip
RUN ln -s /web/.virtualenv/bin/python /usr/local/bin/python
RUN pip install --no-cache-dir flask
ONBUILD COPY requirements.txt /web/
ONBUILD RUN pip install --no-cache-dir -r requirements.txt

# config timezone
ONBUILD COPY localtime /web/
ONBUILD RUN set -ex \
    && rm /etc/localtime \
    && ln -s /web/localtime /etc/localtime

# CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
