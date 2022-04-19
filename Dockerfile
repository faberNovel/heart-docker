FROM node:14-buster-slim as step1
WORKDIR /usr/heart
COPY package.json .
COPY index.js .
RUN \
    yarn install && \
    chmod +x index.js
EXPOSE 3000
ENTRYPOINT ["node", "index.js"]