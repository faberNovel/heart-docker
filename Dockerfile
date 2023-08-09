# Guide: Dockerizing a Node.js web app
# https://nodejs.org/en/docs/guides/nodejs-docker-webapp
FROM node:18-slim

# Install Google Chrome dependencies.
# https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#chrome-doesnt-launch-on-linux
# https://source.chromium.org/chromium/chromium/src/+/main:chrome/installer/linux/debian/dist_package_versions.json
# Dependencies has been first installed without version specified to see which version are installed, then these versions have been set with minor adaptations (see comments).
RUN apt-get update && \
    apt-get -yq --no-install-recommends install \
    # Package libasound2 is not available, but is referred to by another package.
    # However the following packages replace it: libatopology2 libasound2-data
    # libasound2=1.2.8-1 \
    libatopology2=1.2.8-1+b1 \
    libasound2-data=1.2.8-1 \
    libatk-bridge2.0-0=2.46.0-5 \
    libatk1.0-0=2.46.0-5 \
    libatspi2.0-0=2.46.0-5 \
    libc6=2.36-9+deb12u1 \
    libcairo2=1.16.0-7 \
    libcups2=2.4.2-3+deb12u1 \
    libdbus-1-3=1.14.8-2~deb12u1 \
    libdrm2=2.4.114-1+b1 \
    libexpat1=2.5.0-1 \
    libgbm1=22.3.6-1+deb12u1 \
    # Package libgcc1 is a virtual package provided by: libgcc-s1 12.2.0-14 (= 1:12.2.0-14)
    # libgcc1=12.2.0-14 \
    libgcc-s1=12.2.0-14 \
    libglib2.0-0=2.74.6-2 \
    libnspr4=2:4.35-1 \
    libnss3=2:3.87.1-1 \
    libpango-1.0-0=1.50.12+ds-1 \
    libpangocairo-1.0-0=1.50.12+ds-1 \
    libstdc++6=12.2.0-14 \
    libuuid1=2.38.1-5+b1 \
    libx11-6=2:1.8.4-2+deb12u1 \
    libx11-xcb1=2:1.8.4-2+deb12u1 \
    libxcb-dri3-0=1.15-1 \
    libxcb1=1.15-1 \
    libxcomposite1=1:0.4.5-1 \
    libxcursor1=1:1.2.1-1 \
    libxdamage1=1:1.1.6-1 \
    libxext6=2:1.3.4-1+b1 \
    libxfixes3=1:6.0.0-2 \
    libxi6=2:1.8-1+b1 \
    libxkbcommon0=1.5.0-1 \
    libxrandr2=2:1.5.2-2+b1 \
    libxrender1=1:0.9.10-1.1 \
    libxshmfence1=1.3-1 \
    libxss1=1:1.2.3-1 \
    libxtst6=2:1.2.3-1.1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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
