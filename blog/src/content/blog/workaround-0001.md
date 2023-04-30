---
title: "CentOS 7.3でyum install nodejsが失敗するので回避する"
pubDate: "2017-08-24"
updatedDate: "2022-05-10"
description: ''
image:
    url: '/images/header/taifuu_nangoku.png' 
    alt: ''
tags: ['JavaScript','Linux','インフラ']
---

# はじめに
2017/08/13 頃から**yum -y install nodejs**すると**http-parser**の依存関係でコケるようです。
**http-parser**が Red Hat Base リポジトリに 7.4 で追加されたため、EPEL から削除され、そのために失敗するようです。
参考 URL の情報では**http-parser**を別にインストールすれば問題ないということなので対応してみました。

# 環境
- CentOS Linux release 7.3.1611 (Core)

# コケる
```
# yum -y install nodejs

～省略～

エラー: パッケージ: 1:nodejs-6.11.1-1.el7.x86_64 (epel)
             要求: http-parser >= 2.7.0
エラー: パッケージ: 1:nodejs-6.11.1-1.el7.x86_64 (epel)
             要求: libhttp_parser.so.2()(64bit)

～省略～
```

# 回避策
```
# rpm -ivh https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm
https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm を取得中
準備しています...              ################################# [100%]
更新中 / インストール中...
   1:http-parser-2.7.1-3.el7          ################################# [100%]
```

# 再度実行
```
# yum -y install nodejs
～省略～
インストール:
  nodejs.x86_64 1:6.11.1-1.el7                                                                                                                                                

依存性関連をインストールしました:
  libicu.x86_64 0:50.1.2-15.el7                           libuv.x86_64 1:1.10.2-1.el7                           npm.x86_64 1:3.10.10-1.6.11.1.1.el7                          

完了しました!
```

# おわりに
無事インストールできた。
CentOS7.4 がリリースされたら起きなくなるっぽいんですかね？

# 参考
[https://bugzilla.redhat.com/show_bug.cgi?id=1481008](https://bugzilla.redhat.com/show_bug.cgi?id=1481008)
