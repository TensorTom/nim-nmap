import nativesockets, net, strutils, os

let localNet = "192.168.0.x"
var v = 1
for v in countup(1, 255):
  let localNet = replace(localNet, "x", $v)
  try:
    let sock = newSocket()
    sock.connect(localNet, Port(80), 500 * 1)
    echo getHostByName(localNet)
    echo getHostByAddr(localNet)
    sleep(1500)
    sock.close()
  except:
    let errorMsg = getCurrentExceptionMsg()
    echo localNet & ": " & errorMsg
    continue
