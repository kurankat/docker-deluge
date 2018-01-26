# docker-deluge
Docker container to run [Deluge](http://deluge-torrent.org/) and web client in Ubuntu 16.04

Experimental image. `deluged` and `deluge-web` run as `root`. Much safer to run behind NAT.

# Installation:

Download the image with:

```
docker pull kurankat/deluge
```

Run a container with:

```
docker run -d --name deluge \
   -v /path/to/your/chosen/folder/downloads:/downloads \
   -v /path/to/your/chosen/folder/config:/root/.config/deluge \
   -p 8112:8112 \
   kurankat/deluge
```

# Initialising

The `deluge-web` user interface will be at `http://localhost:8112`. It is set to a default password of "deluge". It is highly recommended to change this to a safe password. Log into the daemon and change the settings to use the `/downloads` folder for finished downloads.

# Examples using `docker-compose`

If you have more than a couple of containers running, it's easier to use `docker-compose` to run your setup. You can use a couple of networking options.

## Default networking (bridge)

Your deluge container will run in a docker-only network and you can choose to bind ports to the host. Your deluge container will be addressable using the IP address of the host.

`docker-compose.yml`

```
version: '3'

services:
 deluge:
  container_name: deluge
  image: kurankat/deluge
  restart: always
  volumes:
   - ./downloads:/downloads
   - ./config:/root/.config/deluge
  environment:
   - TZ=<YOUR TIMEZONE>
  ports:
   - "8112:8112"
   - "58846:58846"
   - "58946:58946"
```

Start your container by running `docker-compose up -d`.

## Placing containers on a LAN (macvlan networking)

Your deluge container will run in a macvlan network, through a pre-configured bridge on the host, and attach directly to the router with its own IP address. The example below assumes that you have:
   - Pre-configured a bridge in your Docker host, in this example `br0`
   - The network you are attaching to is in the 192.168.1.0/24 subnet.
   
Make sure you assign IP addresses that are outside the router's DHCP range to avoid conflicts. In this example your container will be addressable in the LAN at 192.168.1.25

`docker-compose.yml`

```
version: '3'

services:
 deluge:
  container_name: deluge
  image: kurankat/deluge
  restart: always
  volumes:
   - ./downloads:/downloads
   - ./config:/root/.config/deluge
  networks:
  example.lan:
   ipv4_address: <YOUR.CHOSEN.IP.ADDRESS>

networks:
 example.lan:
  driver: macvlan
  driver_opts:
   parent: br0
  ipam:
   config:
    - subnet: <YOUR.CHOSEN.IP.SUBNET>/24
```
