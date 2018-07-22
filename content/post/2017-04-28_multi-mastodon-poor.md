+++
date = "2017-04-28T14:16:36+09:00"
draft = false
title = "複数mastodonを考える 🐘   🐘   🐘"
slug = "multi-mastodon-poor"
tags = ["mastodon", "terraform"]
image = "images/cloudcraft-mastodon.png"

+++

terraformの練習がてら、複数のmastodonインスタンス🐘を立ててみました。

<!--more-->

RedisとPostgresの運用をラクしようとするとElastiCacheとRDSを使うことになります。

しかし、**がんばってRDSを1台で運用**したとしても、
以下のように、Redisだけで3インスタンス目で38ドルもかかってしまいます。

| # 🐘   | ElastiCache    | RDS                |
|-----|----------------|--------------------|
| 1台目 | $0/mo.(初年度無料枠)   | $0/mo.(初年度無料枠)        |
| 2台目 | $19/mo. (無料枠 + 1台) | $0/mo.(無料枠1台でがんばる) |
| 3台目 | $38/mo.(無料枠 + 2台) | $0/mo.(無料枠1台でがんばる) |

## ケチケチ作戦

そこで、**Redisも1台だけ**にしてしまいます。

| # 🐘   | ElastiCache    | RDS                |
|-----|----------------|--------------------|
| 1台目 | $0/mo.(初年度無料枠)   | $0/mo.(初年度無料枠)        |
| 2台目 | $0/mo.(無料枠1台でがんばる) | $0/mo.(無料枠1台でがんばる) |
| 3台目 | $0/mo.(無料枠1台でがんばる) | $0/mo.(無料枠1台でがんばる) |


その他はこんな構成です。

<img alt="slack" src="/images/cloudcraft-mastodon.png" width=1600>


これでEC2代だけになったわ♡ と思ったところ、そんなにうまくはいきませんでした。

動作確認したところ、**どうも🐘のキャッシュが他の🐘に影響を与えてしまっている**、、

## ケチケチ作戦ワークアラウンド

こういうふうにやっていきます。

```diff
--- a/config/initializers/redis.rb
+++ b/config/initializers/redis.rb
@@ -4,5 +4,6 @@ Redis.current = Redis.new(
   host: ENV.fetch('REDIS_HOST') { 'localhost' },
   port: ENV.fetch('REDIS_PORT') { 6379 },
   password: ENV.fetch('REDIS_PASSWORD') { false },
+  db: ENV.fetch('REDIS_DB') { 0 }.to_i,
   driver: :hiredis
 )
diff --git a/streaming/index.js b/streaming/index.js
index a1e7eaca..29ded9e2 100644
--- a/streaming/index.js
+++ b/streaming/index.js
@@ -39,7 +39,8 @@ const wss    = new WebSocket.Server({ server })
 const redisClient = redis.createClient({
   host:     process.env.REDIS_HOST     || '127.0.0.1',
   port:     process.env.REDIS_PORT     || 6379,
-  password: process.env.REDIS_PASSWORD
+  password: process.env.REDIS_PASSWORD,
+  db:       process.env.REDIS_DB || 0
 })

 const subs = {}
```

REDIS_DBという環境変数を誕生させdbを隔離します。

これでいまんとこ大丈夫だけど、redis詳しくないし、何か間違っている気もする🎲保証はしない

インスタンスごとに0,1,2,3...と値を入れます。

このへんの制御もterraformでやる。

### ✎まとめ

terraform楽しいです
<script type="text/javascript" src="/js/prism.js" async></script>
