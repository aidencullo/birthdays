import socket
import time
time.sleep(3)  # wait for app1 to start
s = socket.socket()
s.connect(("app1", 5000))
s.send(b"Hello from App2")
