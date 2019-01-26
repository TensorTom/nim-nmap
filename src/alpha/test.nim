import nativesockets, net, strutils, os

proc localHostNet(): string {.discardable.} =
  let localNet = "192.168.0.x"
  var v = 1
  for v in countup(1, 255):
    let localNet = replace(localNet, "x", $v)##Run through mask
    try:
      let sock = newSocket()
      sock.connect(localNet, Port(80), 500 * 1)##500 = 1/2 a second
      echo getHostByName(localNet)
      echo getHostByAddr(localNet)
      sleep(1500)
      sock.close()
    except:
      let errorMsg = getCurrentExceptionMsg()
      echo localNet & ": " & errorMsg
      continue

proc findLocalAddr(): string {.discardable.} =
  let localHost = getHostname()
  let localAddr = getHostByName(localHost)
  echo localAddr
