#!/bin/bash
set -e

# Create directories and Python apps
mkdir -p app1 app2

echo 'import socket
s = socket.socket()
s.bind(("0.0.0.0", 5000))
s.listen(1)
conn, addr = s.accept()
data = conn.recv(1024)
print("App1 received:", data.decode())
conn.close()' > app1/app1.py

echo 'import socket
import time
time.sleep(3)  # wait for app1 to start
s = socket.socket()
s.connect(("app1", 5000))
s.send(b"Hello from App2")' > app2/app2.py

# Dockerfiles
echo 'FROM python:3.12-slim
WORKDIR /app
COPY app1.py .
CMD ["python", "app1.py"]' > app1/Dockerfile

echo 'FROM python:3.12-slim
WORKDIR /app
COPY app2.py .
CMD ["python", "app2.py"]' > app2/Dockerfile

# Build images
docker build -t app1-image ./app1
docker build -t app2-image ./app2

# Create network
docker network create mynet || true

# Run containers
docker run -d --name app1 --network mynet app1-image
docker run -d --name app2 --network mynet app2-image

echo "Containers are running and communicating on network 'mynet'"
