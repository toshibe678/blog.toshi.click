---
title: "Windows10 + WSL(Ubuntu18.04) + Docker Desktopで開発環境構築"
pubDate: "2019-07-09"
updatedDate: "2022-05-10"
description: ''
image:
    url: '/images/header/computer_programming_woman.png' 
    alt: ''
tags: ['Docker','Linux','Windows','WSL','インフラ','開発環境']
---
## TL;DR
`WSL2`の発表と`Docker Desktop for WSL 2`の発表によってこの記事の手順は 20H1 の WindowsUpdate 後は陳腐化すると思われます。

https://engineering.docker.com/2019/06/docker-hearts-wsl-2/

## 前作業
* [WSLの導入手順](https://git.infrastructure.jp/cs/knowledge/issues/24)
* [Docker Desktop導入手順](https://git.infrastructure.jp/cs/knowledge/issues/25)

上記が終わっていること前提。

### アップデート/アップグレード
```
$ sudo apt -y update
$ sudo apt -y upgrade
```

### 日本語環境
1. 日本語/タイムゾーン設定
    ```
    $ sudo apt -y install language-pack-ja
    $ sudo update-locale LANG=ja_JP.UTF-8
    $ sudo timedatectl set-timezone 'Asia/Tokyo'
    $ sudo apt -y install manpages-ja manpages-ja-dev
    ```
1. Ubuntu Japanese Team リポジトリを追加する
    ```
    $ wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O- | sudo apt-key add -
    $ wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O- | sudo apt-key add -
    $ sudo wget https://www.ubuntulinux.jp/sources.list.d/$(lsb_release -cs).list -O /etc/apt/sources.list.d/ubuntu-ja.list
    $ sudo apt -y update
    $ sudo apt -y upgrade
    ```

### Docker
Windows10 バージョン 201903 では WSL で Docker Daemon を動かすことが環境依存で難しいため。

Docker Desktop に接続して操作できるようにする。

インストールがうまく出来ない場合は[公式のインストール手順](https://docs.docker.com/install/linux/docker-ce/ubuntu/)を参照してください。
1. 開発(基本)パッケージを取得する
    ```
    $ sudo apt update
    $ sudo apt -y install build-essential git apt-transport-https ca-certificates curl gnupg2 software-properties-common
    ```
1. Docker リポジトリの追加
    ```
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    $ sudo apt-key fingerprint 0EBFCD88
    $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    $ sudo apt update
    ```
1. Docker のインストール
    ```
    $ sudo apt -y install docker-ce
    ```
1. Docker Desktop のデーモンに接続するように設定を追加
  1. ~/.bashrc に下記を追加
      ```
      export DOCKER_HOST=tcp://localhost:2375
      alias docker="DOCKER_HOST=${DOCKER_HOST} docker"
      alias docker-compose="docker-compose -H ${DOCKER_HOST}"
      ```
  1. 設定反映
      ```
      $ source ~/.bashrc
      ```
### docker-compose
apt で入る docker-compose は古いので[公式](https://docs.docker.com/compose/install/)のやり方で入れる。
1. 以下のコマンドを実行し、`docker-compose`コマンドを直接`/usr/local/bin`以下に配置します。
    ```
    $ sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    ```
   ※このコマンドにはバージョン番号が含まれています。[Install Docker Compose](https://docs.docker.com/compose/install/)にて最新のコマンドを確認してください。
1. 実行可能にするためバーミッションを変更します。
    ```
    $ sudo chmod a+rx /usr/local/bin/docker-compose
    ```

### ボリュームマウントの問題について
この状態では docker でボリュームマウントオプションを入れてもボリュームマウントができないので対処する。
* Docker Desktop 側の設定
  1. タスクバーのインジゲータから Docker アイコンを右クリック
  1. 設定を開き、`Shared Drives`タブにてマウントしたいディレクトリがあるディスクを選択
  1. `Apply`で設定を適用し、起動中であれば念のため Docker を再起動
  1. C ドライブをマウントした場合`/c`にマウントされる

* WSL では/mnt 配下にディスクがマウントされます。
  * 上記のため WSL で docker のマウントオプションを付けて実行してもマウントに失敗します。
  * 原因は Docker Desktop と WSL のマウント位置が違うためであるので WSL にて下記対応をする
```
ln -s /c /mnt/c
```
