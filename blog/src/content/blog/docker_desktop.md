---
title: "Docker Desktop導入手順"
pubDate: "2019-07-08"
updatedDate: "2022-05-10"
description: ''
image:
    url: '/images/header/magnifier_animal_inu.png' 
    alt: ''
tags: ['Docker','Mac','Windows','インフラ','開発環境']
---
## Docker Desktopとは？
以前は`Docker For Windows`、`Docker For Mac`と呼ばれていたソフトウェアが 2018 年 9 月頃`Docker Desktop`に統一されました。

`Windows`および`macOS`でももっとも簡単に`Docker Swarm`や`Kubernetes`を実行出来ます。

Windows では`Hyper-V`、macOS では`Hyperkit`を使用。

## 目次
1. 注意点
1. Docker Desktop を導入する
1. Docker Desktop の設定
1. エラー対応
1. おわりに

## 注意点
Windows で`Hyper-V`を使用するには下記使用要件([公式の使用要件ページ](https://docs.microsoft.com/ja-jp/virtualization/hyper-v-on-windows/reference/hyper-v-requirements))を満たす必要があります。

* 要件の確認
  1. Windows Professional、Enterprise、および Education
  1. 64bit 版 OS
  1. 仮想化テクノロジー(`Intel VT`/`AMD V`)の有効化
  1. 最小`4GB`のメモリー

`Hyper-V`は、`Windows 10 Home`にはインストールできません。

## Docker Desktopを導入する
### Windows
[公式サイト](https://www.docker.com/products/docker-desktop)からインストール。

もしくは[Chocolatey](https://chocolatey.org/)などで[インストール](https://chocolatey.org/packages/docker-desktop)をする。


#### Hyper-Vを有効化する(GUI)
スタート＞設定＞アプリ＞プログラムと機能＞Windows の機能の有効化または無効化を開き Hyper-V にチェックを付けて OK。

![](images/docker_desktop_01.jpg)

※ OS 再起動が必要になります。


#### Hyper-Vを有効化する(コマンド)
管理者として PowerShell コンソールを開き下記実行。
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

※ OS 再起動が必要になります。

### Mac OSX
1. Homebrew で入れる場合、下記コマンド実行。
    ```
    brew install docker
    brew cask install docker
    ```
1. Docker.app の起動。下記コマンド実行。
    ```
    open /Applications/Docker.app
    ```
   色々とダイアログが表示されますので、メッセージに従って実行を進めてください。
1. アカウントを登録
   下記のような画面が表示されますので、`Sign in / Create a Docker ID`でアカウント登録してください。

    ![](/blog/public/images/docker_desktop/docker_desktop_mac1.png)
1. Mac のメニューバーに Docker のアイコンが表示されたら完了です。

    ![](/blog/public/images/docker_desktop/docker_desktop_mac2.png)

## Docker Desktopの設定

### 共有設定(Windowsのみ)
ホストのディレクトリをコンテナマウントする際に共有の設定、許可をしていないといけないため設定します。

タスクトレイのクジラアイコン![](/blog/public/images/docker_desktop/docker_desktop_win_1.jpg)を右クリック＞`Setting`をクリック。

Settings ウィンドウが表示されるので、Shared Drives をクリックします。

![](/blog/public/images/docker_desktop/docker_desktop_win_2.jpg)

共有を許可するドライブにチェックを入れて、Apply をクリックします。

左下が再び Docker is running となれば完了です。

## エラー対応

### shared folder設定時にFirewallの警告が出る場合は
1. ファイアウォールで許可するように設定する
  * [参考リンク](https://stackoverflow.com/questions/42203488/settings-to-windows-firewall-to-allow-docker-for-windows-to-share-drive)
1. ネットワークの種別をプライベートネットワークに変更する
    ```
    Set-NetConnectionProfile -interfacealias "vEthernet (DockerNAT)" -NetworkCategory Private
    ```
尚、Docker の Shared Drives 設定で以下のようなファイルシステム認証画面が出た場合は、ホスト PC のユーザ名（ログインアカウント）とパスワードを入力して認証すれば OK！

![](/blog/public/images/docker_desktop/docker_desktop_win_error1.jpg)

### Hyper-Vが有効になっていない場合
![](/blog/public/images/docker_desktop/docker_desktop_win_error2.jpg)

上のようなプロンプトが表示されるので、`Hyper-V`を有効化させてください。

## おわりに
Mac に比べて Windows では要件が厳しいですが、Docker は便利なので積極的に使っていきたいですね！
