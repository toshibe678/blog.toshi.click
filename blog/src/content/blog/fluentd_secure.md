---
title: "Fluentd間でログを自己証明書で暗号化して送る"
pubDate: "2019-06-26"
updatedDate: "2022-05-10"
description: ''
image:
    url: '/images/header/magnifier_animal_neko.png' 
    alt: ''
tags: ['Fluentd','インフラ','セキュリティ']
---

# 概要
タイトルのとおり、Fluentd で送信元サーバーと送信先サーバー間のログ送信する際に自己署名証明書を使用する際の設定で苦戦したのでメモっておきます。

## 証明書の作成
とりあえず有効期間 30 年の証明書作成。頻繁に証明書を置き換えられるならもっと短くてもいいです。

```
$ openssl req -new -x509 -sha256 -days 10800 -newkey rsa:4096 -keyout fluentd.key -out fluentd.crt
# パスフレーズいれる
your_passphrese

Generating a 4096 bit RSA private key
..........................++
....................................++
writing new private key to 'fluentd.key'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:eg
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:
```

## ログ送信元での設定
上記で作成した crt ファイルをログ送信元に置きます。
今回は`/etc/td-agent/certs/fluentd.crt`に置いています。
shared_key はまぁ適当に設定してください。
バッファーなどの設定は適当ですので適宜変えてください。

```
<match **.*>
    @type forward
    transport tls
    tls_cert_path /etc/td-agent/certs/fluentd.crt
    # 自己署名証明書を使用するにtrue
    tls_allow_self_signed_cert true
    # 自己署名証明書を使用する際にはfalseを設定する必要があります。
    tls_verify_hostname false
    <server>
      host forward.exmple.com
      port 24224
    </server>
    <security>
      self_hostname outputlog.exmple.com
      shared_key hogehoge
    </security>
    <buffer>
      @type file
      path /var/log/td-agent/buffer/sec_forward
    </buffer>
    flush_interval 60s
</match>
```

## ログ送信先での設定
ログ受信時の設定を下記のようにします。
crt と key は作成したもの、shared_key は送り元・送り先で同じフレーズを設定する必要があります。

```
<source>
  @type forward
  port 24224
  bind 0.0.0.0
  <security>
    self_hostname forward.exmple.com
    shared_key hogehoge
  </security>
  <transport tls>
    cert_path /etc/td-agent/certs/fluentd.crt
    private_key_path /etc/td-agent/certs/fluentd.key
    private_key_passphrase your_passphrese
  </transport>
</source>
```
