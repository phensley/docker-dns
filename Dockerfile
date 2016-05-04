FROM alpine:3.3
MAINTAINER "Patrick Hensley <pathensley@gmail.com>"
ADD requirements.txt .
RUN PY=2.7.11-r3 && \
    apk add --update python=$PY python-dev=$PY gcc libgcc libc-dev py-pip libev && \
    pip install -r requirements.txt && \
    apk del python-dev gcc libgcc libc-dev py-pip libev && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*
ADD dockerdns .
ENTRYPOINT ["./dockerdns"]
