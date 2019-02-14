# nim-nmap v0.1.4

A pure implementation of Nmap for Nim.

Documentation will be added as this project progresses as well as commented sections in the source code.

# Commands

* `nmapIface()`
	* Non-functional in current state
	* Native implementation without ExecCmd
* `nmapScan(host: string, Port(port: int)`
* `nmapScan(host: string, Port(port: int, aType: Domain, sType: SockType, nType: Protocol)`
* `nmapHostDisc()`
	* Determines local router and host on network
* `portList.add(port: int)`

# Arguments


* Host
	* IP Address
* Port
	* 0 - Custom ports using portList
	* SSH - 22
	* TELNET 23
	* HTTP - 80
	* HTTPS - 443
	* int - any integer
* Domain
    * IPv4
    * IPv6
* SockType
    * STREAM
    * DGRAM
    * SRAW
    * SEQPACKET
* Protocol
    * TCP
    * UDP
    * RAW
    * ICMP

# Roadmap to v1.0

[x] Basic socket support
[x] Basic Port Scanner
[ ] Read packet information(i.e. TTL, WindowSize)
[ ] Test if Ports are filtered or not
[x] Host Discovery
[ ] OS Fingerprinting
[ ] nmapIface()
[x] NetMask support for host: string

# Examples

## NetMask via `createMask()`

```nim
import nmap
createMask("192.168.1.1/24") 
for i in netMask:
    nmapScan(i, 80)
```

Result will be something like this.
```
192.168.1.1 Connected succesfully on 80
192.168.1.2 No route to host on 80
192.168.1.3 No route to host on 80
```

## `nmapHostDisc()`

```nim
import nmap
for p in countup(1, 999):
    portList.add(p)
    nmapHostDisc()
```

or

```nim
import nmap
portList.add(22)
nmapHostDisc()
```

Bugs in portList with Host Discovery

Adding too many ports(700+) results in too many files open.


## Looking for developers ##

