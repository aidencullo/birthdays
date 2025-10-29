#!/bin/bash
# Create hello world HTML file
cat > /tmp/hello.html <<'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
    <h1>Hello World!</h1>
    <p>Welcome to the Hello World server</p>
</body>
</html>
HTML

# Start Python HTTP server on port 80
cd /tmp
nohup sudo python3 -m http.server 80 > /dev/null 2>&1 &

