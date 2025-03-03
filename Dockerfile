FROM ghcr.io/toshibe678/develop/develop:latest

USER root

# setup playwright
RUN npm install -g playwright \
    && npx playwright install chromium msedge firefox webkit
#           playwright install
##           playwright install firefox \
##           playwright install webkit \
##           playwright install

WORKDIR /app

## astroが動くポートを開けておく
EXPOSE 4321

USER root
#RUN sudo chown -R $USERNAME:$USERNAME /app

#CMD ["yarn","dev"]
CMD ["bash"]
