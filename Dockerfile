FROM python:3.5-alpine

MAINTAINER zhengxiaoyao0716

RUN mkdir /web
WORKDIR /web

# base environment
RUN set -ex \
    && apk add --no-cache uwsgi uwsgi-python

# copy source folder
RUN mkdir ./src
ONBUILD COPY src /web/src/

# mount share folder
RUN mkdir ./share
VOLUME /web/share

# install dependencies
RUN python -m venv .env
# RUN rm /usr/local/bin/pip /usr/local/bin/python
RUN rm /usr/local/bin/python
# RUN ln -s /web/.env/bin/pip /usr/local/bin/pip
RUN ln -s /web/.env/bin/python /usr/local/bin/python
# RUN pip install --no-cache-dir flask
RUN python -m pip install --no-cache-dir flask
ONBUILD COPY requirements.txt /web/
# ONBUILD RUN pip install --no-cache-dir -r requirements.txt
ONBUILD RUN python -m pip install --no-cache-dir -r requirements.txt

# config timezone
ONBUILD COPY localtime /web/
ONBUILD RUN set -ex \
    && rm /etc/localtime \
    && ln -s /web/localtime /etc/localtime

# CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
