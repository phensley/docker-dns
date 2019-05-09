FROM alpine:latest
MAINTAINER "Patrick Hensley <pathensley@gmail.com>"
ADD requirements.txt .
RUN apk add --update python python-dev gcc libgcc libc-dev py2-pip libev && \
    pip install -r requirements.txt && \
    apk del python-dev gcc libgcc libc-dev py2-pip libev && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*
ADD dockerdns .
EXPOSE 53
ENTRYPOINT ["./dockerdns"]
