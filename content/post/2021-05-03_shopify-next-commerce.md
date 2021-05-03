+++
date = "2021-05-03T14:39:47+09:00"
draft = false
title = "Shopify+Vercelでvercel/commerceを動かすやつ🛍(20分でできる)"
slug = "shopify-next-commerce"
tags = ["shopify","nextjs","vercel"]
image = "images/shopify-next-commerce/commerce.png"
+++

vercel/commerceをshopifyで動かすのをやります。
GitHubに慣れているエンジニアなら、20分は言い過ぎかもしれませんが、ShopifyとVercelにアカウント作る時間を込みで考えても、1時間で終わると思います。

<!--more-->

### TOC

* vercel/commerceについて
* 1. vercel/commerceをclone
* 2. Shopifyでストアを作る
* 3. Shopifyでstorefront用のプライベートアプリを作り、storefront用のアクセストークンを得る
* 4. 商品を登録してみる
* 5. 手元で動かしてみる
* 6. GitHubにプライベートリポジトリを作ってpush
* 7. Vercelでdeploy
* まとめ

### vercel/commerceについて

<img alt="commerce" src="/images/shopify-next-commerce/commerce.png" width=600>

[vercel/commerce](https://nextjs.org/commerce)はNext.js製のeコマースサイト用フレームワークです。

BigCommerceやShopifyなどのバックエンドに対応しています。

今回はShopifyを使います。

### 1. vercel/commerceをclone

まずGitHubから[vercel/commerce](https://github.com/vercel/commerce)をcloneします。

```bash
$ git clone https://github.com/vercel/commerce.git [なにか好きな名前]
```

(今回は2021/4/22時点のmasterのリビジョン([`a4f56d1`](https://github.com/vercel/commerce/commit/a4f56d15496c837a73d83281cb0ff55fd95520e1)) でやります)

### 2. Shopifyでストアを作る

Shopifyでアカウントを作り、ストアを作ります。

<img alt="shopify" src="/images/shopify-next-commerce/shopify-01.png" width=400>

### 3. Shopifyでstorefront用のプライベートアプリを作り、storefront用のアクセストークンを得る

storefront用のアクセストークンが欲しいのでプライベートアプリを作ります。

以下のようにポチポチやっていきます(説明雑)

<img alt="shopify" src="/images/shopify-next-commerce/shopify-02.png" width=400>
<img alt="shopify" src="/images/shopify-next-commerce/shopify-03.png" width=400>
<img alt="shopify" src="/images/shopify-next-commerce/shopify-04.png" width=400>
<img alt="shopify" src="/images/shopify-next-commerce/shopify-05.png" width=400>
<img alt="shopify" src="/images/shopify-next-commerce/shopify-07.png" width=400>
<img alt="shopify" src="/images/shopify-next-commerce/shopify-08.png" width=400>

ポチポチしていくとアクセストークンが表示されます。

<img alt="shopify" src="/images/shopify-next-commerce/shopify-11.png" width=400>

(⬆️本当はこんなにたくさん権限付与しなくてもいいかもしれません。ご了承ください)

### 4. 商品を登録してみる

商品が1つもないとよくわからないので適当に商品を登録してみます。

「商品のステータス」を「アクティブ」にして価格も適当に入れておきます。

今回は適当に家にあったカードゲームのカードを登録してみました。

<img alt="shopify" src="/images/shopify-next-commerce/shopify-12.png" width=400>

### 5. 手元で動かしてみる

手元のターミナルで、先ほどcloneしたディレクトリに移動して、nextjsアプリを動かしてみます。

READMEの[このへん](https://github.com/vercel/commerce/blob/a4f56d15496c837a73d83281cb0ff55fd95520e1/README.md#contribute)の通りにやれば良いです。

README抜粋:

```markdown
1. [Fork](https://help.github.com/articles/fork-a-repo/) this repository to your own GitHub account and then [clone](https://help.github.com/articles/cloning-a-repository/) it to your local device.
2. Create a new branch `git checkout -b MY_BRANCH_NAME`
3. Install yarn: `npm install -g yarn`
4. Install the dependencies: `yarn`
5. Duplicate `.env.template` and rename it to `.env.local`
6. Add proper store values to `.env.local`
7. Run `yarn dev` to build and watch for code changes
```

* すでにcloneは終わっているので `2.` あたりからやります。
* `6.` のところで環境変数を設定します。ここでshopifyを指定しつつ先ほどのアクセストークンを貼ります。

環境変数設定例:

```bash
# .env.local
COMMERCE_PROVIDER=shopify
NEXT_PUBLIC_SHOPIFY_STORE_DOMAIN=[shopifyのストア名].myshopify.com
NEXT_PUBLIC_SHOPIFY_STOREFRONT_ACCESS_TOKEN=[さっき作ったstorefront用のアクセストークン]
```

* `7.` で `yarn dev` を実行します。
* ブラウザで表示されたURL( http://localhost:3000 とかになると思います)にアクセスしてみてください。
* 公式デモ( https://shopify.demo.vercel.store/ )のようなお店の画面が出て、先ほど登録した商品が確認できれば成功です🕶。


🎉:
<img alt="" src="/images/shopify-next-commerce/done-02.png" width=400>

### 6. GitHubにプライベートリポジトリを作ってpush

`$ yarn` を実行したので `yarn.lock` に差分が出たかもしれません。これは適当にコミットしておきます。

公開するのにVercel(のGitHub連携)を使うのがラクなので、GitHubにプライベートリポジトリを作ってpushします。(パブリックリポジトリでも、たぶんOKです)

### 7. Vercelでdeploy

Vercelでdeployします。

必要に応じて、GitHub側でリポジトリのアクセス権を指定します。
今作ったリポジトリをVercelが読み取れるようにする必要があります。

<img alt="github" src="/images/shopify-next-commerce/github-01.png" width=400>

Vercel側の画面でリポジトリを読み取れたら、Importの設定をします。

このとき先ほどの環境変数を設定します。

<img alt="vercel" src="/images/shopify-next-commerce/vercel-03.png" width=400>

Deployを実行し、「Congrantulations!」と出れば成功です🕶。

🎉:
<img alt="vercel" src="/images/shopify-next-commerce/vercel-04.png" width=400>
<img alt="vercel" src="/images/shopify-next-commerce/vercel-05.png" width=400>

これで全世界の人がアクセスできるようになりました。

後で消すと思いますが、こんなサイトができました🛍 ( https://rosesinmay.vercel.app/) なお Shopifyは課金してないので、お買い物はできません。

商品詳細画面で雑にLighthouseを走らせてみました。多少最適化は必要そうらしいですが、得点は高かったです。チューニングも楽しそうです。

<img alt="lighthouse" src="/images/shopify-next-commerce/lighthouse.png" width=400>

### まとめ

* Shopifyに$29/月を払って手続きすれば普通に決済も使えそうなので趣味としてはいいかもしれません
* Next.jsの勉強にもなりそうです


<script type="text/javascript" src="/js/prism.js" async></script>
