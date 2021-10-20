+++
date = "2021-10-20T18:06:34+09:00"
draft = false
title = "Heroku 商用 コツ"
slug = "heroku_tips"
tags = ["heroku"]
image = "defimg/1.jpg"
+++

誰かと認識合わせるときのために便利そうなので、

Herokuを商用で使うときのコツを書いていきます。

主に2020年時点での知識なんで、古かったらごめんなさい。認識違ったらそっと教えて下さい。


<!--more-->

----

### 1. Heroku Postgresは使う

<br>

Heroku Postgresは、使ったこと無いけど(ごめんなさい) **評判悪いの聞いたこと無いから、たぶん良いものなんだと思います** 😚

### 2. Heroku Redisは使う

<br>

15ドル/月 払うだけでHigh Availabilityになるはず。安心してセッション管理とかに使えると思います。

AWS ElastiCache はいろいろできすぎて少し複雑なので(雑)、 個人的にはHeroku Redisのほうがおすすめ。


### 3. SendGridアドオンは使わない

<br>

Railsチュートリアル https://railstutorial.jp/ とかだとSendGrid使えってなってるかもです。

が、Herokuのアドオンだと(スパム対策起因による?)謎のエラーが出て送れなくてハマることがあるのはそこそこ有名です。

例:

* https://qiita.com/osakana9114/items/2e0529812f787123e09d
* https://kikutaro777.hatenablog.com/entry/2020/04/13/234948

アドオンのサポートはすごく悪く、

対処するのは時間の無駄ですので、

はじめから **AWS SESとか使ったり、SendGridと直接契約したりすると良いと思います**

### 4. MySQLアドオン(ClearDB)は使わない

<br>

(特にこれ2020年の知識なんで古かったらごめんなさい)

無料プランが一見便利なんですが、MySQL5.5で辛いです。

```
$ heroku addons:create cleardb:ignite  --version=5.7
```

ってやると **エラーにならずに 無事5.5で立ち上がりました。😚 辛い。**

54ドル/月 ぐらい払ってスタンダードプランにするとちゃんと5.7で動きます 😚

ClearDBどうしても使いたい場合はキャラクタセット(utf8mb4使いたい)で少しハマるので、以下のエントリーが参考になるかもです

* https://xyk.hatenablog.com/entry/2015/01/14/143508

まあはじめから **AWSのAurora MySQLとか使うと良いと思います😚**

8系は使えませんが....

#### 脇道: Review Apps でDBどうするの

[Heroku Review Apps](https://devcenter.heroku.com/articles/github-integration-review-apps)(GitHubでPR作るごとに環境ができるアレ)すごい便利なんですが、DB設定どうするのが最適解なのかよくわかっていません

* PRごとにまっさらなDBが欲しいならClearDBアドオンの無料枠でいいかもしれないが、MySQLは5.5で動いてしまう

という問題があります。

解決策としては、ハコはステージング用のAurora用意しておいて毎度 `rails db:create` するのがいいのかもしれません。このへんは工夫すればなんとかなりそうな気はします


### 5. ログ系アドオンは使えない

<br>

問題があってサポートにチケット書いたことが2回あったのですが、まともな返事なかったのでおすすめしません。

papertrailはもしかしたらマシかもしれませんが、SendGridにしてもなんにしても、third party系のアドオンのサポートのレスをまともにもらったことがないので、安心して商用で使えるかと言われると個人的な経験的にはかなり疑問です。

ログどうするかという話としては、(herokuでは使ったことないけど) アプリケーションの中から **AWSのCloudWatchLogsとか使うと良いのかもしれません😚**

アドオン使う場合、papertrail使うにしてもなんにしても、ログをためとく場所として**AWS S3のバケット使うハメにはなるかと思います**

### 6. CDNは別途用意しとこ

<br>

国内向けなら、usリージョンにしてもeuリージョンにしても遠いと思うので、別途CDNを準備するのが良いと思います。

### 7. Review Appsについて

<br>

[Heroku Review Apps](https://devcenter.heroku.com/articles/github-integration-review-apps)(GitHubでPR作るごとに環境ができるアレ) の悪いところは、あまりない印象です!

敢えていうと、RailsでAssets Precompileに時間のかかるようなアプリだとビルドに時間がかかってしまい、たとえば**10分間隔ぐらいで続けて(GitHubのPR側で)git pushすると後続のデプロイが失敗して若干萎える感じになります。**

そういうことがあり、Review Appsみたいな仕組みは AWSで自分で組みたくなってしまいます。

### ここまでの前提として

ここまで、

1. herokuのサポートに金は払わない
  * 当然heroku enterpriseは使わない
2. 中規模・そこそこの可用性は欲しい

という前提で書いてきました

### 結局: IaaSサイドで用意するものが多くない？

結局、

* Aurora(とくにMySQL使いたい場合)
* S3
* CloudWatchLogs
* SES(メール)
* CDN

とかは **AWSで用意するのが現実的かなと思うのです。**

で、それを設定できる人って、IaC系のツール(CloudFormation,Terraform)を操作できたりして、 **コンピューティングの部分のインフラ構築(ECS, AppRunner, etc.)も自分でできる人がそこそこ多い**気がするんですよね。

そうなってくると、「**もうちょっと頑張れば**Herokuじゃなくていいじゃん」という話になってきてしまう。

**もうちょっと頑張る** だけで 以下のようなメリットが見えてくるんですよね

* デプロイ時のdocker buildのキャッシュ最適化とかができる
* そこそこ不満のないレビュー環境を作れる
* (Aurora+Herokuでやった場合に比べて) VPCの中でDB接続が閉じるので速度的にも有利


### 最近の私

で、少なくとも自分は、↑のメリットが大きいので、Heroku使わずに全部AWSに寄せるかなあという感じのことが多いです。

<script type="text/javascript" src="/js/prism.js" async></script>
