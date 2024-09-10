FROM node:22

# Debian set Locale
# tzdataのapt-get時にtimezoneの選択で止まってしまう対策でDEBIAN_FRONTENDを定義する
ENV DEBIAN_FRONTEND=noninteractive
# debian japanease
RUN apt-get update && apt-get install -y locales \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen \
  && locale-gen

# コンテナのデバッグ等で便利なソフト導入しておく
RUN apt-get update \
    && apt-get -y install vim git curl wget zip unzip net-tools iproute2 iputils-ping pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install aws-cli cfn-lint
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install awscli

# setup playwright
RUN apt-get update && apt-get install -y \
    xvfb \
    libxi6 \
    libgconf-2-4 \
    libnss3 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libgtk-3-0 \
    libxcomposite1 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g playwright \
    && npx playwright install \
    && npx playwright install-deps \
    && npx playwright install firefox \
    && npx playwright install webkit \
    && npx playwright install chromium

WORKDIR /app

## astroが動くポートを開けておく
EXPOSE 3000

#USER node

#CMD ["yarn","dev"]
CMD ["bash"]
