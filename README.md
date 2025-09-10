# blog.toshi.click

MarkdownでブログコンテンツをAstroで静的サイトとしてビルドし、AWS S3+CloudFrontで配信するブログサイトプロジェクトです。

## 技術スタック
- Astro 5.3.0
- Node.js
- TypeScript
- Docker / Docker Compose
- AWS (S3, CloudFront)
- GitHub Actions (CI/CD)

## 機能
- Markdownコンテンツのブログ記事化
- リンクカードの自動生成（remark-link-card）
- 外部リンクの自動target="_blank"設定
- RSS フィード生成
- サイトマップ生成
- GitHub Actionsによる自動デプロイ

## 開発環境のセットアップ
### 必要条件
- Docker
- Docker Compose
- Visual Studio Code
- Dev Containers拡張機能（VSCode）

### 開発環境の起動
1. リポジトリのクローン
```bash
git clone [repository-url]
```

2. Dev Containersで開発環境を起動
VSCodeでプロジェクトを開き、左下の「><」アイコンをクリックして「Reopen in Container」を選択

3. 依存パッケージのインストール
```bash
npm install
```

4. 開発サーバーの起動
```bash
npm run dev
```
サーバーが起動したら http://localhost:4321 でアクセス可能

## デプロイ
### 自動デプロイ (CI/CD)
このプロジェクトはGitHub Actionsを使用して自動デプロイを実装しています：

- `develop` ブランチへのプッシュ → ステージング環境へデプロイ
- `main` ブランチへのプッシュ → 本番環境へデプロイ

自動デプロイは以下のファイルに変更がある場合に実行されます：
- `blog/**`
- `.github/workflows/deploy*`

### 手動デプロイ
必要に応じて手動でデプロイすることも可能です：

1. ビルド
```bash
npm run build
```

2. AWS S3へのアップロード（AWS CLI設定済みの場合）
```bash
aws s3 sync dist/ s3://[bucket-name]/ --delete --size-only --region ap-northeast-1
```

### 環境変数の設定
#### ローカル開発環境
プロジェクトルートに`.env`ファイルを作成し、必要な環境変数を設定してください：

```env
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_DEFAULT_REGION=ap-northeast-1
```

#### GitHub Actions
デプロイに必要な以下の環境変数をGitHubのSecretsに設定してください：
- `S3AWS_ACCESS_KEY_ID`
- `S3AWS_SECRET_ACCESS_KEY`

## コンテンツの追加
1. `blog/src/content/blog/`ディレクトリに新しいMarkdownファイルを作成
2. 以下のフロントマターを含めて記事を作成：

```markdown
---
title: "記事タイトル"
description: "記事の説明"
pubDate: "2025-03-15"
---

記事の内容をここに書く
```

## ディレクトリ構造
```
blog/
├── src/
│   ├── components/    # Astroコンポーネント
│   ├── content/       # ブログコンテンツ
│   ├── layouts/       # ページレイアウト
│   ├── pages/         # ルーティング
│   ├── plugins/       # カスタムプラグイン
│   └── styles/        # グローバルCSS
├── public/            # 静的ファイル
├── astro.config.mjs   # Astro設定
└── package.json       # 依存関係
