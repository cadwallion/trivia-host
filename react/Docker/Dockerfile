FROM node:latest

WORKDIR /opt/triva-host

#copy package*.json files first and run npm install
COPY package*.json ./
RUN npm install

#copy app source, doing it after install so npm install is cached
COPY . .
#initialize DB
RUN node db/setup.js

EXPOSE 8080
EXPOSE 3000
