# Stage 1: build React
FROM node:20 AS builder

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
