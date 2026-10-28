# Minimal Lightweight Production Image (Nginx Alpine)
FROM nginx:alpine

# Copy built production SPA files
COPY dist /usr/share/nginx/html

# Copy custom Nginx configuration with API reverse proxy
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
