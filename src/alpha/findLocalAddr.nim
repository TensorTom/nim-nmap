import nativesockets, net, strutils, os


proc main(): string {.discardable.} =
  var testPort = Port(7612)

  proc findLocalAddr(): string {.discardable.} =
    let localNet = "192.168.0.x"
    var v = 1
    for v in countup(1, 255):
      let localNet = replace(localNet, "x", $v)##Run through mask
      try:
        let sock = newSocket()
        sock.connect(localNet, testPort, 50 * 1)##500 = 1/2 a second
        echo getHostByName(localNet)
        echo getHostByAddr(localNet)
        sleep(1500)
        sock.close()
        quit()
      except:
        continue


  var socket = newSocket()
  socket.bindAddr(testPort)
  socket.listen()
  findLocalAddr()
main()
