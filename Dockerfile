# Stage build
FROM node:8-alpine as builder

# install angular 4 global
RUN npm install -g @angular/cli

# git clone source from repo
RUN mkdir /app
WORKDIR /app
RUN apk update && apk add git
RUN git clone https://github.com/yasminghassani/angular-app.git
RUN cd /app/angular-app && git checkout master

WORKDIR /app/angular-app
RUN npm install

# Add env
RUN ng build --prod

# Stage runtime application
FROM nginx:1.11-alpine
COPY --from=builder /app/angular-app/dist/hello-world /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]