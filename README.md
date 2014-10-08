docker-dns
----------

Automatic container DNS for [Docker][docker].

[docker]: http://github.com/docker/docker "Docker"


Usage
-----

Run some containers:

    % docker run -d --name foo ubutnu bash -c "sleep 60"

Start up dockerdns:

    % docker run --name dns -v /var/run/docker.sock:/docker.sock phensley/docker-dns \
        --domain example.com

Start more containers:

    % docker run -d --name bar ubuntu bash -c "sleep 60"

Check dockerdns logs:

    % docker logs dns
    2014-10-08T20:45:37.349161 [dockerdns] table.add dns.example.com -> 172.17.0.3
    2014-10-08T20:45:37.351574 [dockerdns] table.add foo.example.com -> 172.17.0.2
    2014-10-08T20:45:37.351574 [dockerdns] table.add bar.example.com -> 172.17.0.4

Query for the containers by hostname:

    % host foo.example.com 172.17.0.3
    Using domain server:
    Name: 172.17.0.3
    Address: 172.17.0.3#53
    Aliases:

    foo.example.com has address 172.17.0.2
    foo.example.com has address 172.17.0.2

Use dns container as a resolver inside a container:

    % docker run -it --dns $(docker inspect -f '{{.NetworkSettings.IPAddress}}' dns) \
        --dns-search example.com ubuntu bash

    root@95840788bf08:/# cat /etc/resolv.conf
    nameserver 172.17.0.3
    search example.com

    root@95840788bf08:/# ping foo
    PING foo.example.com (172.17.0.2) 56(84) bytes of data.
    64 bytes from 172.17.0.2: icmp_seq=1 ttl=64 time=0.112 ms
    64 bytes from 172.17.0.2: icmp_seq=2 ttl=64 time=0.112 ms


