FROM node:14-buster-slim as step1
WORKDIR /usr/heart
COPY package.json .
COPY entrypoint.sh .
RUN \
    yarn run use-cli && \
    yarn run use-dareboost && \
    yarn run use-slack && \
    chmod +x entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["/usr/heart/entrypoint.sh"]