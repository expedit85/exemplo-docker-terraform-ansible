FROM node:8.11.3

RUN mkdir -p /app
COPY package.json /app
WORKDIR /app
RUN npm install 

ADD  .  /app

ENTRYPOINT ["/bin/bash", "-c", "npm start"]
