---
title: "WSLの導入手順"
pubDate: "2019-06-04"
updatedDate: "2022-05-10"
description: ''
image:
    url: '/images/header/no_image_square.jpg' 
    alt: ''
tags: ['Linux','Windows','インフラ','開発環境']
---

# WSLの導入手順
WSL (Windows Subsystem for Linux) の導入手順について書きます。

## WSLとは？
Windows10（バージョン 1709 以降）で利用可能になった Windows10 から Linux を利用するための機能です。

## 目次
1. WSL を導入する
1. Linux ディストリビューションをインストールする
1. おわりに

## WSLを導入する
### コマンドの場合
以下のコマンドを PowerShell を管理者権限で起動し実行します。
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
### GUIの場合
1. プログラムと機能 → Windows の機能の有効化または無効化を開きます。

    ![](/blog/public/images/wsl_setup/wsl_gui_01.jpg)
1. ダイアログ内の`Windows Subsystem for Linux`の左側のチェックボックスにチェックを付けて OK

    ![](/blog/public/images/wsl_setup/wsl_gui_02.jpg)
1. Windows を再起動します。

## Linuxディストリビューションをインストールする
Windows Store で、WSL 用の Linux が提供されていますので、そちらからお好みのものを導入します。

今回は Ubuntu 18.04 LTS をインストールします。

1. Windows Store 内でお好みの Linux ディストリビューションを表示し、`インストール`ボタンを押します。

   ※ 初めてインストールする際には`入手`ボタンを押すことが必要です。

    ![](/blog/public/images/wsl_setup/wsl_distro_01.jpg)
1. `起動`をクリックします。

    ![](/blog/public/images/wsl_setup/wsl_distro_02.jpg)
1. ユーザー名とパスワードを入力します。

    ![](/blog/public/images/wsl_setup/wsl_distro_03.jpg)

   これで Ubuntu18.04 LTS を使い始めることができます。
1. 次回以降の起動

   スタートメニューに Ubuntu18.04 LTS が追加されていますのでそちらから起動します。

    ![](/blog/public/images/wsl_setup/wsl_distro_04.jpg)

## おわりに
WSL (Windows Subsystem for Linux) の導入手順について書きました。

WSL だけでは Linux コマンドを Cygwin 等を導入しなくても使用できるようになった程度でメリットが見えにくいです。
