FROM nginx:alpine

EXPOSE 5001

CMD ["nginx", "-g", "daemon off;"]
