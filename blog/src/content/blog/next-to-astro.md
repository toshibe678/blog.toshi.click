---
title: "私のブログ ホスティングの歴史"
pubDate: "2023-05-01"
updatedDate: "2023-05-01"
description: '私のブログ ホスティングの歴史'
image:
    url: '/images/header/computer_programming_man.png' 
    alt: ''
tags: ["js","雑記"]
---

## はてブ、Qiitaで記事公開時代
当時確かポエム記事などが消されまくるということで炎上していたので、
やっぱり自前ホスティングが最強だよなと思って移行を開始しました。

## WordPress 時代 201708-202204 
* さくらのVPS 201708-201911
* IDCFクラウド 201911-202204

前職でエンジニアブログの構築運用をWordPressで行っていた経験があったのでサクッとWordPressで作成。

途中でホスティング業者を変えたのはIDCFの個人事業主プランで契約すると、
当時監視に使用していたMackerelのデータが1週間保持サービスがついてきたから。
（フリープランだとデータ保持3日制限）

## Next.js 時代 202204-202304
WordPressのアップデート対応などに運用の限界を感じて静的ブログでいいんじゃないかと思って構築。

記事をMarkdownで書いておくと体裁整えてHTML出力。

SSGでCloudFront + S3構成に変えたおかげでランニングコスト1/5になりました。

## astro時代
Next.jsが依存パッケージが多すぎてGithubのDependabotがうるさすぎた。

バージョンをあげたら体裁崩れたなどが発生し、これではWordpress時代とあまり変わらないなと感じ、
ほかのよいフレームワークが無いか探していたところ見つけました。

astroはテンプレートにブログがありかつSSGが標準で実装されていて構築しやすく工数も最小で済みそうであったので採用しました。

公式ドキュメントが日本語なのもいい点です。

## SSGってなんぞや
まずSSG、SSGと話してきましたがフロントエンドを開発されたことが無い方には馴染みがないと思いますので解説します。

SSG（Static Site Generator）はその名の通り静的サイトを生成することです。

Next.jsやastroはJSのフレームワークなので本来動かすにはNode.jsが必要となりますが、
SSGするとSPA（Single Page Application）で作成したアプリをただのHTMLやJSに変換してくれるので、
普通のWebサーバーで配信可能となります。

私はCloudFront + S3でサーバーレス化もして月額100円ぐらいになりました。

## astro の始め方
[公式ドキュメント](https://docs.astro.build/ja/install/auto/)にある通りですが、
Node.jsがインストール済みの状態であれば1コマンドで開発開始可能です。

※ 私が普段yarnを使っているのでyarnコマンドで紹介します。
```shell
# yarnで新しいプロジェクトを作成する
yarn create astro
```

コマンド実行後は以下の質問をされるので答えていくだけでテンプレートを使ってブログが作成済みの状態で記事を書き始めることができます。
```shell
root# yarn create astro
yarn create v1.22.19
warning package.json: No license field
[1/4] Resolving packages...
[2/4] Fetching packages...
[3/4] Linking dependencies...
[4/4] Building fresh packages...
success Installed "create-astro@3.1.3" with binaries:
      - create-astro

╭─────╮  Houston:
│ ◠ ◡ ◠  Let's create something unique!
╰─────╯

 astro   v2.3.2 Launch sequence initiated.

   dir   Where should we create your new project?
         ./blog

  tmpl   How would you like to start your new project?
         Use blog template
      ✔  Template copied

  deps   Install dependencies?
         No
      ◼  No problem! Remember to install dependencies after setup.

    ts   Do you plan to write TypeScript?
         Yes

   use   How strict should TypeScript be?
         Strict
      ✔  TypeScript customized

   git   Initialize a new git repository?
         No
      ◼  Sounds good! You can always run git init manually.

  next   Liftoff confirmed. Explore your project!

         Enter your project directory using cd ./blog
         Run yarn dev to start the dev server. CTRL+C to stop.
         Add frameworks like react or tailwind using astro add.

         Stuck? Join us at https://astro.build/chat

╭─────╮  Houston:
│ ◠ ◡ ◠  Good luck out there, astronaut! 🚀
╰─────╯
Done in 77.38s.
```

構築後は`yarn dev`を実行して http://localhost:3000/ にアクセスするとアクセス可能。

`yarn build`で静的ファイルが生成することができて、
生成されたファイルをWebサーバーにアップロードすればもう配信可能。

#### astroの良くないところ
.astro拡張子で作成していきますがJS記述部分とHTMLが上下に分かれていて読みづらい

## 終わりに
いろいろ迷走しましたが今のところ数年はastroで頑張ってみようと思います。
利用者が増えるとユースケースが増えて私もうれしいので皆さんもブログ作りましょう！
