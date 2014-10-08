docker-dns
----------

Automatic container DNS for [Docker][docker].

[docker]: http://github.com/docker/docker "Docker"


Usage
-----

Run some containers:

    % docker run -d --name foo ubutnu bash -c "sleep 600"

Start up dockerdns:

    % docker run --name dns -v /var/run/docker.sock:/docker.sock phensley/docker-dns \
        --domain example.com

Start more containers:

    % docker run -d --name bar ubuntu bash -c "sleep 600"

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

Names not rooted in `example.com` will be resolved recursively using Google's resolver `8.8.8.8` by default:

    root@95840788bf08:/# ping github.com
    PING github.com (192.30.252.128) 56(84) bytes of data.
    64 bytes from 192.30.252.128: icmp_seq=1 ttl=61 time=21.3 ms

To disable recursive resolution, use the `--no-recursion` flag:

    % docker run --name dns -v /var/run/docker.sock:/docker.sock phensley/docker-dns \
        --domain example.com --no-recursion

Now names not rooted in `example.com` will fail to resolve:

    % docker run -it --dns $(docker inspect -f '{{.NetworkSettings.IPAddress}}' dns) \
        --dns-search example.com ubuntu bash
    root@4d15342387b0:/# ping github.com
    ping: unknown host github.com


License
-------

    Copyright (c) 2014 Patrick Hensley

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

