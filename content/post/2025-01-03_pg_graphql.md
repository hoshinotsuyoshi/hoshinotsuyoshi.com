+++
date = "2025-01-03T11:02:33+09:00"
draft = false
title = "supabaseのpg_graphqlをさわってみたら便利そうだった"
slug = "pg_graphql"
tags = ["supabase","pg_graphql"]
image = "images/pg_graphql-2.jpg"
+++

supabase の [supabase/pg_graphql](https://github.com/supabase/pg_graphql)をさわってみました。


<!--more-->

## TL;DR

* テーブル作ると自動的にいろんなtype(query, mutation, filter等)が生えるので便利そう
* RLSとかpostgresの関数を活用する世界観か...?



## 手元で試したことメモ

### supabase start

適当にsupabase startしてローカルでsupabase一式を動かします。

```bash
$ npm install --save-dev supabase
$ npm exec supabase init
$ npm exec supabase start
# supabase startでdocker コンテナがいろいろと立ち上がります。
# 自分のMacにはもともとdocker for Macが入っていたためかすんなり動きました。
```

`http://127.0.0.1:54323/` でstudio(管理画面) が動くことを確認。

また、このときに `http://127.0.0.1:54321/graphql/v1` でGraphQLサービスが動いているはずです。

`http://127.0.0.1:54323/project/default/integrations/graphiql/overview` で確認できます。

<img alt="pg_graphql" src="/images/pg_graphql-1.png" width=800>

### テーブルを1つ作る

Table Editorで適当にテーブルを1つ作ります。
今回はテーブル名は `products` で カラムは `id`, `title`, `created_at` としました。

<img alt="table" src="/images/pg_graphql-2.jpg" width=800>

### GraphiQLをさわってみる

#### doc

`http://127.0.0.1:54323/project/default/integrations/graphiql/graphiql` でGraphiQL(GraphQLのPlayground)で遊べます。

docのアイコン(?)をクリックするとtypeの一覧が見れます。

<img alt="pg_graphql doc" src="/images/pg_graphql-3.png" width=800>

`products` テーブル関連のqueryやmutationが自動的に生えていました(!)

#### リスト取得してみる

叩いてみます。

```graphql
# request
{
  productsCollection {
    edges {
      node {
        __typename
        nodeId
        id
        title
        created_at
      }
    }
    pageInfo {
      __typename
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
  }
}
```

```json
// response
{
  "data": {
    "productsCollection": {
      "edges": [
        {
          "node": {
            "id": "1",
            "title": "商品1",
            "nodeId": "WyJwdWJsaWMiLCAicHJvZHVjdHMiLCAxXQ==",
            "__typename": "products",
            "created_at": "2025-01-02T13:02:25.930989+00:00"
          }
        }
      ],
      "pageInfo": {
        "endCursor": "WzFd",
        "__typename": "PageInfo",
        "hasNextPage": false,
        "startCursor": "WzFd",
        "hasPreviousPage": false
      }
    }
  }
}
```

とれました!

#### ロール切り替え機能とRLSについて

下側のこのツールでロール切り替えができるようです。

<img alt="pg_graphql doc" src="/images/pg_graphql-4.png" width=800>

以下が切り替えできるっぽい。
なお、supabaseのpostgresはRLS(Row Level Security)がデフォルトでテーブルポチポチつくると有効になっている。

* RLSをスキップするロール
* RLSが効いているロール
   * anon(匿名)
   * ログイン済み?ロール

### postgresの関数を作るとmutation/queryが作られる?

postgresの関数を作るとmutation/queryが作られる? っぽい?

[Functions - pg_graphql](https://supabase.github.io/pg_graphql/functions/) によると

>Functions marked immutable or stable are available on the query type. Functions marked with the default volatile category are available on the mutation type

とのこと。 `immutable` ないし `stable` な関数を作るとqueryに、 それ以外は mutationになるということ、か? このへんは動作確認していない。


### ✎まとめ

* 便利そうですね

<script type="text/javascript" src="/js/prism.js" async></script>
