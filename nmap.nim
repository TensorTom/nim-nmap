##
## A native nmap implementation for nim
## https://github.com/blmvxer/nim-nmap
##
## Credit: https://nmap.org
##
## Released under GPLv2, see LICENSE file
## 2017 - blmvxer <blmvxer@gmail.com>
##

#Compiler options
{.deadCodeElim: on, hints: off, warnings: off.}
#

import net, strutils, os

##Constant Values, Types and Exports
const
   TCP = IPPROTO_TCP
   UDP = IPPROTO_UDP
   RAW = IPPROTO_RAW
   ICMP = IPPROTO_ICMP
   IPv4 = AF_INET
   IPv6 = AF_INET6
   STREAM = SOCK_STREAM
   DGRAM = SOCK_DGRAM
   SRAW = SOCK_RAW
   SEQPACKET = SOCK_SEQPACKET
   SSH = 22
   TELNET = 23
   HTTP = 80
   HTTPS = 443

var
   dType = IPv4                     #Domain
   sType = STREAM                   #SockType
   pType = TCP                      #Protocol
   recPacket = newString(1024)      #1024bit Packet
   portList: seq[int]               #Custom Ports
   hostMask: seq[string]            #Carry's IP bits
   hostSwitch = 0                   #use NetMask to eliminate manual
                                    #call to createMask
   netMask: seq[string]             #e.g. 192.168.1.1/24
   localWlan = "192.168.x.1"        #Define router
#PortList Defaults
portList = @[]
portList.add(22)
portList.add(23)
portList.add(80)
portList.add(443)
#HostMask & NetMask Controls
hostMask = @[]
netMask = @[]
##########################################################
export SSH, TELNET, HTTP, HTTPS, TCP, UDP, RAW, ICMP
export IPv4, IPv6, STREAM, DGRAM, SRAW, SEQPACKET
export dType, sType, pType, portList, netMask, hostMask
export hostSwitch
##########################################################
#nmap commands and additional features
proc createMask*(host: string): string {.discardable.} =
   var i = 1
   if endsWith(host, "/24"):##Create NetMask out of IP Address
      let host = replace(host, "/24", "")
      let seperators = {'.'}
      for f in split(host, seperators):
         hostMask.add(f)
   else:
      echo "error"

   let ipMask = hostMask[0] & "." & hostMask[1] & "." & hostMask[2] & "."
   while i <= 255:
      netMask.add(ipMask & $i)
      inc(i)
      
proc nmapIface*(): (string) {.discardable.} =
   var i = 0
   while i <= 255:
      let localWlan = replace(localWlan, "x", $i)
      try:
         var sock = newSocket(IPv4, STREAM, TCP)
         echo localWlan
         sock.connect(localWlan, Port(HTTP), 350 * 1)
         let router = localWlan
         sock.close()
         var socket = newSocket()
         socket.bindAddr(Port(82))
         socket.listen()
         createMask(router)
         for x in netMask:
            try:
               var iface = newSocket()
               iface.connect(x, Port(82), 350 * 1)
               echo "localhost: " & x
               socket.close()
               iface.close()
            except:
               inc(i)
      except:
         inc(i)

#This proc is standard connect
proc nmapScan*(host: string, port: int): string {.discardable.} =
   if port == 0:
      for i in portList:
         try:
            var sock = newSocket(IPv4, STREAM, TCP)
            sock.connect(host, Port(i))
            let sPort = intToStr(i)
            echo host & " Connected succesfully on " & sPort
            sock.close()
         except:
            let ErrorMsg = getCurrentExceptionMsg()
            let sPort = intToStr(i)
            echo host & " " & ErrorMsg &  " on " & sPort
   else:
      try:
         var sock = newSocket(IPv4, STREAM, TCP)
         sock.connect(host, Port(port))
         let sPort = intToStr(port)
         echo host & " Connected succesfully on " & sPort
         sock.close()
      except:
         let ErrorMsg = getCurrentExceptionMsg()
         let sPort = intToStr(port)
         echo host & " " & ErrorMsg &  " on " & sPort

#This proc allows additional low-level control
proc nmapScan*(host: string, port: int,
                dType: Domain, sType: SockType, pType: Protocol):
                string {.discardable.} =
   try:
      if pType == UDP:
         var sock = newSocket()
         discard sock.sendTo(host, Port(port), "status\n")
         let recPacket = sock.recvLine(1024 * 5)#TODO Work on sending and receiving data from Packets
         echo sizeOf(recPacket)#TODO
      else:
         var sock = newSocket(dType, sType, pType)#Allow control over Domain, SockType, and Protocol
         sock.connect(host, Port(port))
         let sPort = intToStr(port)
         echo host & " Connected succesfully on " & sPort
         sock.send("bbHHh")
         let recPacket = sock.recvLine(1024 * 5)
         echo sizeOf(recPacket)
         sock.close()
   except:
     let ErrorMsg = getCurrentExceptionMsg()
     let sPort = intToStr(port)
     echo host & " " & ErrorMsg &  " on " & sPort
