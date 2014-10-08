FROM python:2.7-onbuild
MAINTAINER "Patrick Hensley <spaceboy@indirect.com>"
ADD . /workdir
ENTRYPOINT ["/workdir/dockerdns"]

