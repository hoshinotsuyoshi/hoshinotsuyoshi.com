+++
date = "2021-05-04T10:54:40+09:00"
draft = false
title = "Shopify+Vercelでvuestorefront/vue-storefrontを動かすやつ🌠"
slug = "shopify-vuestorefront"
tags = ["shopify","vue","vercel"]
image = "images/shopify-vuestorefront/vue-storefront-og.png"
+++

前回はvercel/commerceをShopifyで動かすのをやりましたが、
今回はvuestorefront/vue-storefrontをShopifyで動かすのをやります!

<!--more-->

### TOC

* Vue Storefrontについて
* 1. @vue-storefront/cliを利用してインストール
* 2. Shopifyでストアを作る
* 3. Shopifyでstorefront用のプライベートアプリを作り、storefront用のアクセストークンを得る
* 4. 商品を登録してみる
* 5. 手元で動かしてみる
* 6. Vercelのdeployの準備
* 7. GitHubにプライベートリポジトリを作ってpush・Vercelでdeploy
* まとめ

### Vue Storefrontについて

<img alt="commerce" src="/images/shopify-vuestorefront/vue-storefront-og.png" width=600>

[Vue Storefront](https://nextjs.org/commerce)はVue.js製のeコマースサイト用フレームワークです。

MagentoやShopify(Shopifyはまだbeta扱い)などのバックエンドに対応しています。

今回はShopifyを使います。

### 1. @vue-storefront/cliを利用してインストール

ドキュメントにしたがってインストールしていきます。
https://docs.vuestorefront.io/v2/general/installation.html#using-vue-storefront-cli の通りにやれば大丈夫です。

```
$ npx @vue-storefront/cli init
```

`Choose integration` のところで `Shopify(beta)` を選択します。


インストールし終わるとこんな感じのファイルレイアウトになります -> https://github.com/hoshinotsuyoshi/vuestorefront-shopify-demo/tree/first

### 2. Shopifyでストアを作る

※ これは[前回](/post/shopify-next-commerce/) と同じです。

Shopifyでアカウントを作り、ストアを作ります。

<img alt="shopify" src="/images/shopify-next-commerce/shopify-01.png" width=400>

### 3. Shopifyでstorefront用のプライベートアプリを作り、storefront用のアクセストークンを得る

※ これは[前回](/post/shopify-next-commerce/) と同じです。

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

※ これは[前回](/post/shopify-next-commerce/) と同じです。

商品が1つもないとよくわからないので適当に商品を登録してみます。

「商品のステータス」を「アクティブ」にして価格も適当に入れておきます。

今回も適当に家にあったカードゲームのカードを登録してみました。

<img alt="shopify" src="/images/shopify-next-commerce/shopify-12.png" width=400>

### 5. 手元で動かしてみる

手元のターミナルで、先ほど作成したディレクトリに移動して、動かしてみます。

`$ yarn` で依存パッケージをインストールします。

さらに以下のようにして環境変数経由でShopifyストアのドメイン名とstorefrontのアクセストークンを渡します。


```diff
diff --git a/middleware.config.js b/middleware.config.js
index 777954b..ff46fb8 100644
--- a/middleware.config.js
+++ b/middleware.config.js
@@ -4,8 +4,8 @@ module.exports = {
       location: '@vue-storefront/shopify-api/server',
       configuration: {
         api: {
-          domain: '<DOMAIN>',
-          storefrontAccessToken: '<TOKEN>'
+          domain: process.env.SHOPIFY_STORE_DOMAIN,
+          storefrontAccessToken: process.env.SHOPIFY_STOREFRONT_ACCESS_TOKEN,
         },
         currency: 'USD',
         country: 'US'
```

そして `$ yarn dev` するとサーバーが動くはずです。


```
[terminal]$ yarn dev
yarn run v1.22.4
$ nuxt

 WARN  sass-loader@8.0.2 is installed but ^10.1.1 is expected


 WARN  router.scrollBehavior property is deprecated in favor of using ~/app/router.scrollBehavior.js file, learn more: https://nuxtjs.org/api/configuration-router#scrollbehavior

ℹ VSF Starting Vue Storefront Nuxt Module
✔ VSF Installed Vue Storefront Context plugin
✔ VSF Installed Vue Storefront SSR plugin
✔ VSF Installed VSF Logger plugin

 WARN  useMeta is not supported in onGlobalSetup as @nuxtjs/pwa detected.
See https://github.com/nuxt-community/composition-api/issues/307

✔ VSF Installed nuxt Composition API Module
✔ VSF Installed StorefrontUI Module
✔ VSF Installed Performance Module
ℹ VSF Using raw source/ESM for @vue-storefront/shopify
ℹ VSF Using raw source/ESM for @vue-storefront/core
ℹ VSF Using raw source/ESM for @storefront-ui/vue
ℹ VSF Using raw source/ESM for @storefront-ui/shared
ℹ VSF Starting Theme Module
ℹ Middleware starting....
ℹ Loading integartions...
ℹ - Loading: shopify @vue-storefront/shopify-api/server
✔ - Integration: shopify loaded!
✔ Integrations loaded!
✔ Middleware created!

   ╭────────────────────────────────────────────╮
   │                                            │
   │   Nuxt @ v2.15.4                           │
   │                                            │
   │   ▸ Environment: development               │
   │   ▸ Rendering:   server-side               │
   │   ▸ Target:      server                    │
   │                                            │
   │   Listening: http://192.168.50.227:3001/   │
   │                                            │
   ╰────────────────────────────────────────────╯

ℹ Preparing project for development
ℹ Initial build may take a while
✔ Builder initialized
✔ Nuxt files generated

✔ Client
  Compiled successfully in 25.11s

✔ Server
  Compiled successfully in 23.44s

No issues found.                                                                      12:43:28
ℹ Waiting for file changes                                                            12:43:28
ℹ Memory usage: 447 MB (RSS: 671 MB)                                                  12:43:28
ℹ Listening on: http://192.168.50.227:3001/                                           12:43:28
```

🎉

トップページ:

<img alt="" src="/images/shopify-vuestorefront/done-01.png" width=400>

商品の個別ページ:

<img alt="" src="/images/shopify-vuestorefront/done-02.png" width=400>

<img alt="" src="/images/shopify-vuestorefront/done-03.png" width=400>

### 6. Vercelへのdeployの準備

(ここは何も参考にせずに独自で設定したのであまり自信ありません🙇)

そのままだとdeployできなかったので、`vercel.json` を準備します。

また、configが空だと「middleware.config.jsが見つからないよ」と怒られたので
`"serverFiles": ["middleware.config.js"]` を指定します。

```js
{
  "builds": [
    {
      "src": "nuxt.config.js",
      "use": "@nuxtjs/vercel-builder",
      "config": {
        "serverFiles": ["middleware.config.js"]
      }
    }
  ]
}
```

また、tsconfig.jsonがおかしいよ(見つからないよ)と言われたので色々調べたところ、どう自動生成されたはずのtsconfig.jsonがJSONになってない(!)ようでしたのでこれも修正しました。([`f6a11845be`](https://github.com/hoshinotsuyoshi/vuestorefront-shopify-demo/commit/f6a11845bea7afa959dd04b19c9938e0fb167d2d))

```diff
diff --git a/tsconfig.json b/tsconfig.json
index 5c68c38..c3999f1 100644
--- a/tsconfig.json
+++ b/tsconfig.json
@@ -27,5 +27,5 @@
       "@nuxt/types",
       "nuxt-i18n"
     ]
-  },
+  }
 }
```

### 7. GitHubにプライベートリポジトリを作ってpush・Vercelにdeploy

(ここも何も参考にせずに独自で設定したのであまり自信ありません🙇)

Vercelでdeployします。

試行錯誤しましたが、とりあえず `OUTPUT DIRECTORY` を `.nuxt` に変更することで動作しました。

<img alt="" src="/images/shopify-vuestorefront/vercel-01.png" width=400>
<img alt="" src="/images/shopify-vuestorefront/vercel-02.png" width=400>

Deployを実行し、「Congrantulations!」と出れば成功です🕶。

🎉 これで全世界の人がアクセスできるようになりました。

後で消すと思いますが、こんなサイトができました🛍 (  https://rosesinmay2.vercel.app/ ) なお Shopifyは課金してないので、お買い物はできません。

商品詳細画面で雑にLighthouseを走らせてみました。PWAが有効になってるのが面白いですね。画像については最適化がかかっていないようです。

<img alt="lighthouse" src="/images/shopify-vuestorefront/lighthouse.png" width=400>

### まとめ

* Shopifyに$29/月を払って手続きすれば普通に決済も使えそうなので趣味としてはいいかもしれません(前回に引き続き2回目)
* Vue.jsの勉強にもなりそうです(前回に引き続き2回目)


<script type="text/javascript" src="/js/prism.js" async></script>
