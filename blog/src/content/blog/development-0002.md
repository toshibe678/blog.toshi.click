---
title: "React Nativeことはじめ"
pubDate: "2018-04-13"
updatedDate: "2022-05-10"
description: ''
image:
    url: '/images/header/computer_screen_programming.png' 
    alt: ''
tags: ['Android','iOS','JavaScript','プログラミング','開発環境']
---
# はじめに
業務で React Native を使ったスマホアプリ開発をすることになったので、私の作成した開発環境を備忘録的にご紹介します。

# React Nativeとは
React は Facebook が開発した JavaScript のフレームワークです。  
React Native は React で Android アプリと iOS アプリの開発が出来るようにしたものです。

React Native を使用することで Android アプリと iOS アプリを１つのソースコードで作ることができます。(…凝らなければですが。)  
凝ったことをしたい場合は、Android だったら Java や Kotlin、iOS だったら Objective-C や Swift でライブラリを自分で書いて React Native 自体を拡張することも出来ます。  
極力共通パーツで作成するようにすると、７～８割ぐらいは同じソースコードにすることが出来るようです。

# 環境構築
会社ではインフラ担当もしている関係があり、Windows , Mac どちらもいいスペックの物を使わせてもらってます。
どちらの OS でも使えるようにしました。
## Windows
Node.js などをインストールする必要がありますが、更新速度がかなり早いので普通にインストーラーからインストールすると更新に着いていくのが大変ですし、面倒です。  
そこで、パッケージマネージャーとして[Chocolatey](https://chocolatey.org/)を使用してインストールします。

スタートメニューから PowerShell を管理者権限で起動し下記のコマンドを実行します。
```
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```
Chocolatey のインストールが完了したら、そのまま必要パッケージをインストールしましょう。
```
choco install -y nodejs.install
choco install -y python2
choco install -y jdk8
```
以下をコマンドプロンプト（管理者権限でなくて OK）で実行。
```
npm install -g react-native-cli
npm install -g create-react-native-app
npm install -g yarn
```

## Mac
Mac の場合は[Homebrew](https://brew.sh/index_ja.html)で入れるのがいいです。
Homebrew のセットアップについてはググれば一杯出てきますが[ここ](https://qiita.com/balius_1064/items/ac7dff5ef10eaf69996f)とか見れば入れられるんじゃないですかね。

コンソールを開いてコマンド実行してください。
```
brew install node
brew install watchman
brew install flow
npm install -g react-native-cli
npm install -g create-react-native-app
```

# Androidアプリの開発・テストをする事前準備
SDK をインストールする必要があります。Android Studio を使わないでインストールする方法もありますが、Android Studio を使ったほうが遥かに楽です。

そして作成したアプリの実行環境が必要です。
Android 端末を持っている場合はそれを使えますが、持っていない場合は Genymotion を入れるか、AndroidStudio のエミュレーターの設定をするのがおすすめです。

## Windowsでの事前準備
```
# ANDROID_HOME環境変数へSDKインストールフォルダを登録してください
・ANDROID_HOME=C:\Users\ユーザ名\AppData\Local\Android\sdk

# WindowsはSDKへの環境変数が必要。既定値でインストールした場合は下記をPathに追加してください
・C:\Users\ユーザ名\AppData\Local\Android\sdk\tools
・C:\Users\ユーザ名\AppData\Local\Android\sdk\platform-tools
```

## Macでの事前準備
```
cd
vi .bash_profile
追記--------------------
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
--------------------
```

# iOSアプリの開発・テストをする事前準備
Homebrew 入れるときに Xcode を入れましたので、iOS Simulator を使えば OK です。

# React Nativeの初期設定
コマンドプロンプトもしくはコンソールから実行してください。  
[]内は書き換えてください。
```
cd [プロジェクトを作りたいディレクトリ]
create-react-native-app [プロジェクト名]

cd [プロジェクト名]
npm start
```

![](/blog/public/images/development-0002/prompt.png)

案内が上記のように画面に出ますので、QR コードを撮影するか exp://から始まるアドレスへ Xpo アプリから接続してください。  
コマンドプロンプトやコンソールを閉じると切れてしまうので注意！

# まとめ
まだ使い始めですが、簡単なアプリだったらすぐ作ることが出来ます。
普段 Android アプリを Kotlin で書いてる身からすると、変更がすぐ見られるのはいいですね。
