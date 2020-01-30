FROM python:3.6-slim-buster

MAINTAINER jeffrey.freeman@syncleus.com

# uwsgi must be compiled - install necessary build tools, compile uwsgi
# and then remove the build tools to minimize image size
# (buildDeps are removed, deps are kept)
RUN set -ex \
    && apt-get update && apt-get install -y build-essential git --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip \
    && pip install sphinx \
    && find /usr/local -depth \
    \( \
        \( -type d -a -name test -o -name tests \) \
        -o \
        \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    \) -exec rm -rf '{}' +

#Allow local installs via pip
RUN mkdir /.local && chmod a+rwx /.local

WORKDIR /app

CMD cd /app && pip install -U -r requirements.txt && cd /app/docs && make html
