# VPN-gateway
## Description
Main goal is to connect to many networks through VPN with docker containers and access remote networks from local host or even network, because:
1. Very offen on one PC there can be only one VPN connection, when working in few remote networks it is needed to disconnect and connect to new VPN
2. Client2site (personal VPN) not always can be configured on routers devices

Current version only support FortiGate SSL VPN (it use openfortivpn package), in feature maybe different protocol will be added (openvpn, wireguard, ipsec).

**As it use macvlan, it can be used only in linux!**

## Deploy container
On host where containers will be run, there must be ppp kernel module installed, because it is needed for container (which use host kernel and its modules). On Debian it can be installed very simply: `apt install ppp`, kernel module is loaded automatically. As container need the kernel module, it has to be run with `--privileged` parameter.

To pass VPN parameters, you have to set environment variables like this:
```console
$ docker network create -d macvlan --subnet=<host network> --gateway=<host gateway ip> -o parent=<host interface> net_pub
$ docker run --privileged --network=net_pub --ip=<free ip from host network> --name vpn-gateway-org1 -e HOST=vpn_server -e USER=username -e PASS=password netrunn3r/vpn-gateway
```
Where parameters to create network are:
1. `host network` - network of host, where docker container is running (it can be local machine or different machine), eg. 10.0.0.0/24
2. `host gateway ip` - gateway of previously defined network, eg. 10.0.0.1
3. `host interface` - interface name on which is previously defined network, eg eth0

There are also two container variables with default value:
1. `PORT=443` - tcp port on which vpn server listen
2. `INTERVAL=3` - after how many seconds reconnect if disconnected

## Configure local network
To route traffic to remote network, there need to be added static routes, eg. in Windows:
```console
route ADD <remote network> MASK <remote network mask> <container ip>
```
and addresses of DNS servers, eg. in Windows:
```console
netsh interface show interface
netsh interface ipv4 add dnsservers "<interface name>" address=<dns server ip> index=1
```
Where first command show interfaces name in PC, second add to that interface new dns server address

Remote networks and address of DNS servers can be obtain from output of container, after success connection.