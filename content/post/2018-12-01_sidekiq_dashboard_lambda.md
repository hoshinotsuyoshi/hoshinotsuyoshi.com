+++
date = "2018-12-02T00:26:53+09:00"
draft = false
title = "💎AWS Lambdaでrubyを動かしてSidekiqのダッシュボードをサーバーレスで動かしてみる"
slug = "sidekiq_dashboard_lambda"
tags = ["sidekiq","ruby","lambda"]
image = "images/serverless-sidekiq-web.png"

+++

ついに [AWS Lambdaがrubyをサポート](https://aws.amazon.com/jp/blogs/compute/announcing-ruby-support-for-aws-lambda/)しました。💎

サンプルとして、AWS公式からSAM(AWS Serverless Application Model)でWebアプリを動かすやつ [aws-samples/serverless-sinatra-sample](https://github.com/aws-samples/serverless-sinatra-sample)が出てました↓。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-type="article"><h4><a href="https://github.com/aws-samples/serverless-sinatra-sample">aws-samples/serverless-sinatra-sample</a></h4><p>Demo code for running Ruby Sinatra on AWS Lambda. Contribute to aws-samples/serverless-sinatra-sample development by creating an account on GitHub.</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

(なんとsinatra!!)

このサンプルは、CloudFormation動かしたことない私でも、特につまづくことなく超簡単に動きました。

今回は、これを元に少し改造して **Sidekiq::Web(Sidekiq付属のダッシュボード)をAWS Lambdaで動かしてみる** ことにしました。そのことについて書きます。

<!--more-->

## 様子

<br/>

それで動いたのがこちらです。

動いた!! わーい。

<img alt="slack" src="/images/sidekiq_web_site_image.jpg" width=800>

**中身が空のRedisで試してるんで、実際運用してみると不具合あるかもしれません。あしからず。**

## 構成

<br/>

構成は以下の通り。Redisにアクセスしたいので、LambdaはVPC内で動かします。

<img alt="slack" src="/images/serverless-sidekiq-web.png" width=800>

## ソースコード

今回作ったSAMのコード類は、こちら↓に置きました。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article"><h4><a href="https://github.com/hoshinotsuyoshi/serverless-sidekiq-web">hoshinotsuyoshi/serverless-sidekiq-web</a></h4><p>Sidekiq::Web monitor powered by AWS lambda. Only 200+ lines. - hoshinotsuyoshi/serverless-sidekiq-web</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

## ポイント

やってみて自分的にポイントだと思ったことは、以下の通りです。

1. [aws-samples/serverless-sinatra-sample](https://github.com/aws-samples/serverless-sinatra-sample) の[公式サンプルlambda.rb](https://github.com/aws-samples/serverless-sinatra-sample/blob/6f4fe279/lambda.rb) を読んだ
  * 以下に説明します。
2. config.ruを書いた
  * 以下に説明します。
3. SCRIPT_NAMEの調整
  * パスにステージの名前が入るとCSSが破滅してうまく動かないので調整。
    * これ複雑なので省略。あとで別エントリーに書くかも。
4. SAM(AWS Serverless Application Model)を動かす
  * ググるとわかるので説明省略
5. VPCでlambdaを動かす
  * ググるとわかるので説明省略
6. 認証
  * これ大変だったので今回は省略します。実装はできましたがSAMのコードには落とし込みませんでした。あとで別エントリーに(ry

## ポイントの説明

<br/>

### 1. [公式サンプルlambda.rb](https://github.com/aws-samples/serverless-sinatra-sample/blob/6f4fe279/lambda.rb) を読む

<br/>

このスクリプトの動きを読んでいきます。

#### rackアプリをグローバル変数に入れる

まず[4-6行目](https://github.com/aws-samples/serverless-sinatra-sample/blob/6f4fe279/lambda.rb#L4-L6)。

```ruby
# Global object that responds to the call method. Stay outside of the handler
# to take advantage of container reuse
$app ||= Rack::Builder.parse_file("#{File.dirname(__FILE__)}/app/config.ru").first
```

ここでは app/config.ru に書いてある情報からappを抜き出してグローバル変数(!)に入れています。

handerメソッドの外側でキャッシュするとコンテナが使い回されたときに性能が良いから、というようなコメントが書かれています。

#### #callを呼ぶ

次に、一気に飛んで[29-30行目](https://github.com/aws-samples/serverless-sinatra-sample/blob/6f4fe279/lambda.rb#L29-L30)。

```ruby
# Response from Rack must have status, headers and body
status, headers, body = $app.call(env)
```

rackアプリは`#call`というメソッドを呼ぶとHTTPステータスコード、HTTPレスポンスヘッダー、HTTPレスポンスボディを配列で返す、

ということをどこかで学んだ気がしますが、そのようなことが書かれています。

#### Hash(レスポンス)を返す

[38-53行目](https://github.com/aws-samples/serverless-sinatra-sample/blob/6f4fe279/lambda.rb#L38-L53)。

```ruby
    # We return the structure required by AWS API Gateway since we integrate with it
    # https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
    response = {
      "statusCode" => status,
      "headers" => headers,
      "body" => body_content
    }

  # (...snip...)

  # By default, the response serializer will call #to_json for us
  response
```

 `By default, the response serializer will call #to_json for us` とあるように、Hashを返してあげればよいようです。

...というわけで、lambda.rbは **APIゲートウェイから渡ってきたデータ」を「どうRackアプリに渡してどう返してあげるか」が書いてある** 、ということがわかりました(小並感)。

### config.ruを書く

<br>

つぎにlambda.rbから呼ばれるconfig.ruを書くのですが、

今回はSidekiq::Webという超簡単なやつがテーマなので、config.ruは以下のとおりで済んでしまいます(まあ、簡単そうだからSidekiq::Webを選んだのですが)。

```ruby
# frozen_string_literal: true

require 'sidekiq/web'

redis_config = { size: 1, db: 0, host: ENV['REDIS_HOST'] }

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

run Rack::URLMap.new('/sidekiq' => Sidekiq::Web)
```

今回環境変数 `REDIS_HOST`は、CloudFormationのテンプレートファイルにパラメータとして埋め込み、
デプロイ(`$ aws cloudformation deploy`)するときに、--parameter-overridesオプションで渡すようにしました。

デプロイコマンドは[ここ](https://github.com/hoshinotsuyoshi/serverless-sidekiq-web#deployment)に書いときましたのでご参考までに。


### まとめ!!

以上です!

今回はSAM(AWS Serverless Application Model)の力を借りて、Sidekiq::Webをデプロイしてみました。

VPC内のLambdaですが、やはり最初のレスポンスは遅いものの、連続して画面を叩いていれば、やはりコンテナが使い回されるのか、それほど遅くも感じなかったです。ちゃんと測っていませんが、使い物にはなるかなと思いました。

Sinatraでアプリを書けばサーバーレスで動く!時代が来ましたね!(?)

<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20181201-1" %}}
