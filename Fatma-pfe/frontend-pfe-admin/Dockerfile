# Étape 1 : Build de l'application avec Node.js
FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Étape 2 : Image de production avec NGINX
FROM nginx:alpine

# Nettoyer l'ancien contenu nginx
RUN rm -rf /usr/share/nginx/html/*

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier le build depuis l'étape 'build'
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
