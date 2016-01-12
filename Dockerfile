FROM alpine:3.1
MAINTAINER "Patrick Hensley <spaceboy@indirect.com>"
ADD requirements.txt .
RUN PY=2.7.9-r0 && \
    apk add --update python=$PY python-dev=$PY gcc libgcc libc-dev py-pip libev && \
    pip install -r requirements.txt && \
    apk del python-dev gcc libgcc libc-dev py-pip libev && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*
ADD dockerdns .
ENTRYPOINT ["./dockerdns"]