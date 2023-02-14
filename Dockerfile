# ビルド用
FROM node:16 as builder

WORKDIR /app

## パッケージをインストール
COPY package.json ./
COPY yarn.lock ./
#RUN yarn ci

COPY . ./

RUN yarn build

# 実行用
FROM node:16
WORKDIR /app

## ビルド用のレイヤからコピーする
#COPY --from=builder /app/build ./build
COPY --from=builder /app/yarn.lock .
COPY --from=builder /app/node_modules ./node_modules

## Svelteが動く3000ポートを開けておく
EXPOSE 3000

EXPOSE 5173
EXPOSE 5174
EXPOSE 5175
EXPOSE 5176
EXPOSE 5177

USER node

CMD ["@"]
#CMD ["yarn", "dev"]
#CMD ["node", "./build"]
