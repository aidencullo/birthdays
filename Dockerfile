# Stage 1: build React
FROM node:20 AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Relatywny URL umożliwia działanie z każdą domeną (dev, test, prod)
ENV VITE_API_URL=/api

RUN npm run build

# Stage 2: serwujemy statyki przez NGINX
FROM nginx:alpine

# usuwamy defaultową stronę
RUN rm -rf /usr/share/nginx/html/*

# kopiujemy z builda
COPY --from=builder /app/dist/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
