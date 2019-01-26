import nativesockets, net, strutils, os

let lan = "192.168.0.x"
var v = 1
for v in countup(1, 255):
  let lan = replace(lan, "x", $v)
  try:
    let sock = newSocket()
    sock.connect(lan, Port(80), 500 * 1)
    echo getHostByName(lan)
    echo getHostByAddr(lan)
    sleep(1500)
    sock.close()
  except:
    let ErrorMsg = getCurrentExceptionMsg()
    echo ErrorMsg
    continue
