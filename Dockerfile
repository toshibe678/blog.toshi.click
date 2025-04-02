FROM ghcr.io/toshibe678/develop/develop:latest

USER root

# install yamllint via apt
RUN apt-get update && apt-get install -y \
    yamllint \
    python3-pathspec \
    && rm -rf /var/lib/apt/lists/*

# install global npm packages
RUN npm install -g \
    textlint \
    textlint-rule-preset-ja-technical-writing \
    textlint-rule-preset-japanese \
    textlint-rule-prh \
    textlint-rule-spellcheck-tech-word

# setup playwright
# RUN npm install -g playwright \
#     && npx playwright install chromium msedge firefox webkit
#           playwright install
##           playwright install firefox \
##           playwright install webkit \
##           playwright install

# SSH設定: github.com向けのホスト鍵チェックを無効化
RUN mkdir -p /root/.ssh && \
    echo "Host github.com\n\tStrictHostKeyChecking no\n" > /root/.ssh/config && \
    chmod 600 /root/.ssh/config

WORKDIR /app

## astroが動くポートを開けておく
EXPOSE 4321

#RUN sudo chown -R $USERNAME:$USERNAME /app

#CMD ["yarn","dev"]
CMD ["bash"]
