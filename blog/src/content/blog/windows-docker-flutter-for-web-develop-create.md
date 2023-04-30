---
title: "WindowsのDockerでFlutter for Web（開発環境構築）"
pubDate: "2021-03-26"
updatedDate: "2022-05-10"
description: ''
image:
    url: '/images/header/website_kensaku_top.png' 
    alt: ''
tags: ['Docker','Windows','開発環境']
---

# 概要
あんまり Windows に PATH とか追加設定したく無いという思いがあり Docker Desktop for Windows で開発してみたので環境構築部分について書いておきます。

# 前提
* Docker Desktop for Windows を使用するので Windows10 2004 以降
* Docker Desktop for Windows をインストール済み。

# この記事について
* Windows と書きましたが Docker で Flutter for Web 環境なのでおそらく Mac でも動くはずです。
* `flutter doctor`でエラーが出ないように色々インストールするので Docker build に恐ろしいほど時間がかかります。  
  build 完了したら Docker Hub 等にプッシュしたほうが再利用性が高いです。
* 忙しい人のために[必要ファイルをリポジトリに上げてあります](https://github.com/toshi-click/flutter_web_develop.git)

# 急いでる人がやること
1. リポジトリを Clone して移動
1. `docker-compose build`
1. `docker-compose up -d`
1. コンソールから下記コマンドでコンテナ内に入ります。 (VsCode の remote-container で workspace コンテナを開いたりしてもいいです)   
   ```docker exec -it flutter bash```
1. `cd ${APP_CODE_PATH_CONTAINER} ; flutter create .`を実行します。
1. `flutter run -d web-server --web-port=${WEB_SERVER_PORT} --web-hostname 0.0.0.0`を実行し Web サーバーを起動します。
1. ブラウザで`http://localhost:8888`を開きながらコーディング！

# Dockerファイル
## Dockerfile
```dockerfile
# build時に使用するARGを定義している部分
ARG ubuntu_version
ARG timezone
ARG web_server_port
ARG app_code_path_container

# https://hub.docker.com/_/ubuntu/
FROM ubuntu:${ubuntu_version}

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=ja_JP.UTF-8
ENV LC_CTYPE=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:jp
ENV TZ $timezone
ENV WEB_SERVER_PORT $web_server_port
ENV APP_CODE_PATH_CONTAINER $app_code_path_container

# Ubuntu base setting (locale と timezone と デバッグによく使用するものを入れる)
RUN apt-get update \
    && apt-get -y -q install \
    # Lang ja
    language-pack-ja-base language-pack-ja apt-transport-https \
    # devtool
    vim netcat vim git curl wget zip unzip make sudo gcc libc-dev clang net-tools \
    xserver-xorg pkg-config libgtk-3-dev cmake ninja-build gnupg software-properties-common \
    && locale-gen ja_JP.UTF-8 \
    && localedef -f UTF-8 -i ja_JP ja_JP.utf8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "${TZ}" > /etc/timezone \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

# requisites software（Flutter関連で使用するものを入れる）
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && add-apt-repository ppa:maarten-fonville/android-studio
RUN apt-get update && \
    apt-get -y -q install \
    xz-utils libglu1-mesa openjdk-8-jdk google-chrome-stable android-studio \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# AndroidをビルドできるようにAndroidSDKを入れる
WORKDIR /usr/local
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /usr/local/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/usr/local/Android/sdk/platform-tools"

# Dartのインストール
RUN sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get update && \
    apt-get -y -q install \
    dart \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/usr/local/flutter/bin"

# Flutter Webが使用できるようにする
RUN flutter config --enable-web
# Flutterの診断
RUN flutter doctor

EXPOSE ${WEB_SERVER_PORT}
```

## docker-compose.yml
```yml
version: '3.7'
# 今回のdocker-compose.ymlでは意味ないがlogの設定を別にして使いまわししやすくしている
x-logging:
  &default-logging
  options:
    max-size: '12m'
    max-file: '5'
  driver: json-file

services:
  flutter:
    container_name: flutter
    build:
      context: ../../pages/posts
      args:
        # Dockerfile内でARGしている変数に.envに定義した値を代入。
        - ubuntu_version=${UBUNTU_VERSION}
        - timezone=${TIMEZONE}
        - web_server_port=${WEB_SERVER_PORT}
        - app_code_path_container=${APP_CODE_PATH_CONTAINER}
    tty: true
    env_file: .env
    volumes:
      - ${APP_CODE_PATH_HOST}:${APP_CODE_PATH_CONTAINER}${APP_CODE_CONTAINER_FLAG}
    logging: *default-logging
    # web-serverとして動作させるためにportを指定。
    ports:
      - "$WEB_SERVER_PORT:$WEB_SERVER_PORT"
```

## .env
```
# ここの名前でアプリ名が変わるので自分のアプリ名を設定してください
APP_NAME=YOUR_APP_NAME

APP_CODE_PATH_HOST=./src
APP_CODE_PATH_CONTAINER=/usr/local/workspace
APP_CODE_CONTAINER_FLAG=:cached

TIMEZONE=Asia/Tokyo
UBUNTU_VERSION=20.04
WEB_SERVER_PORT=8888
```

# 感想
Windows に PATH 追加設定したりするのが嫌でない人は素直に Flutter SDK と Android Studio をインストールして開発したほうが速くて快適です。
複数端末を利用していたりしてどうしても Docker でやりたいという想いがないのであればこれはいらないです。
