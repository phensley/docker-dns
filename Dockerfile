FROM python:2.7-slim
MAINTAINER "Patrick Hensley <spaceboy@indirect.com>"
RUN apt-get -qq update && \
    apt-get -qqy install \
    gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD requirements.txt .
RUN pip install -r requirements.txt
ADD dockerdns .
ENTRYPOINT ["./dockerdns"]