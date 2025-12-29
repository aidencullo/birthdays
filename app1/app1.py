import socket
s = socket.socket()
s.bind(("0.0.0.0", 5000))
s.listen(1)
conn, addr = s.accept()
data = conn.recv(1024)
print("App1 received:", data.decode())
conn.close()
