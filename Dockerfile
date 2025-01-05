FROM ghcr.io/toshibe678/develop/develop:latest

# setup playwright
RUN npm install -g playwright \
    && npx playwright install chromium msedge firefox webkit
#           playwright install
##           playwright install firefox \
##           playwright install webkit \
##           playwright install

WORKDIR /app

## astroが動くポートを開けておく
EXPOSE 3000

#USER node

#CMD ["yarn","dev"]
CMD ["bash"]
