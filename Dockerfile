# Guide: Dockerizing a Node.js web app
# https://nodejs.org/en/docs/guides/nodejs-docker-webapp
FROM node:18-buster-slim

# Install Google Chrome dependencies.
# https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#chrome-doesnt-launch-on-linux
# https://source.chromium.org/chromium/chromium/src/+/main:chrome/installer/linux/debian/dist_package_versions.json
RUN apt-get update && \
    apt-get -yq --no-install-recommends install \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libexpat1 \
    libgbm1 \
    libgcc1 \
    libglib2.0-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libuuid1 \
    libx11-6 \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxkbcommon0 \
    libxrandr2 \
    libxrender1 \
    libxshmfence1 \
    libxss1 \
    libxtst6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV production

# Create app directory
WORKDIR /usr/heart

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

# Install Heart dependencies.
# npm ci provide faster, reliable, reproducible builds for production environments.
RUN npm ci --omit=dev

# Bundle app source
COPY . .
 
ENTRYPOINT ["npx", "heart"]
