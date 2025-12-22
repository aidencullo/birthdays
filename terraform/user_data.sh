#!/bin/bash
set -e

# Update package index
apt-get update

# Install nginx
apt-get install -y nginx

# Create a simple Hello World HTML page
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .container {
            text-align: center;
            background: white;
            padding: 50px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        h1 {
            color: #333;
            margin: 0;
            font-size: 3em;
        }
        p {
            color: #666;
            margin-top: 20px;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello World!</h1>
        <p>Nginx is running successfully on EC2</p>
    </div>
</body>
</html>
EOF

# Ensure nginx is started and enabled
systemctl enable nginx
systemctl start nginx
