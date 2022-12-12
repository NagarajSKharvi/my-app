# FROM node:14.17.0 as build
# WORKDIR /app
# ENV PATH /app/node_modules/.bin:$PATH
# COPY package.json ./
# COPY package-lock.json ./

# RUN npm ci --silent
# RUN npm install react-scripts -g --silent
# COPY . .
# RUN npm run build 

# #prepare nginx
# FROM nginx:stable-alpine
# COPY --from=build /app/build /usr/share/nginx/html

# #fire up nginx
# EXPOSE 80
# CMD ["nginx","-g","daemon off;"]

FROM node:alpine AS builder
ENV NODE_ENV production
WORKDIR /app
COPY ./package.json ./
RUN npm install
COPY . .
RUN npm run build
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf