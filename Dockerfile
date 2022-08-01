FROM node:14-slim

# Inspired by official Pupetter documentation: https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-in-docker
# To use, run any of your script this way: docker run -i --init -v "hostPath:containerPath" --cap-add=SYS_ADMIN moukrea/puppeteer node -e "`cat yourScript.js`"

ARG PUPPETEER_VERSION=${PUPPETEER_VERSION:-15.5.0}
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=google-chrome-stable
ENV NODE_PATH=/usr/local/lib/node_modules

RUN apt update && apt install -y wget gnupg ;\
\
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - ;\
\
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' ;\
\
apt update && apt install -y \ 
    google-chrome-stable \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-freefont-ttf \
    libxss1 \
    --no-install-recommends ;\
\    
rm -rf /var/lib/apt/lists/* ;\
\
mkdir /app ;\
\
npm i -g puppeteer@${PUPPETEER_VERSION} ;\
\
groupadd -r puppeteer && useradd -r -g puppeteer -G audio,video puppeteer ;\
\
mkdir -p /home/puppeteer/Downloads ;\
\
chown -R puppeteer:puppeteer /home/puppeteer ;\
\
chown -R puppeteer:puppeteer /app

USER puppeteer

CMD ["google-chrome-stable"]