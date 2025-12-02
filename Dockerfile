FROM python:3.11-slim

WORKDIR /app

# Copy all files from current directory
COPY . .

# Expose port 8000
EXPOSE 8000

# Run the HTTP server
CMD ["python", "-m", "http.server", "8000"]
