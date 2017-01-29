+++
date = "2017-01-29T23:16:08+09:00"
draft = false
title = "AmazonDriveをamazon.co.jpで使う"
slug = "amazon_drive_japanese"
tags = ["amazon_drive"]
image = "images/heteroconger_hassi.jpg"

+++

撮ったホームビデオのバックアップを置く場所に困ってきたので、[Amazon Drive](https://www.amazon.co.jp/clouddrive/home)を契約しました。

<!--more-->


### アップロードしていく

専用のアプリをインストールします。

インストールすると、バーに常駐しやがります。

開くとこんな感じです。

<img alt="amazon_drive" src="/images/amazon_drive_no_sync.png" width=400>

「同期せずにアップロードします」を使います。

アップロードするファイルを選択する画面。

<img alt="amazon_drive" src="/images/amazon_drive_upload.png" width=400>

適当にアップロードしていきます。

<img alt="amazon_drive" src="/images/amazon_drive_app.png" width=400>

アップロードし終わった後の状態。

<img alt="amazon_drive" src="/images/amazon_drive_usage.png" width=400>

べんりですね。

### GoogleDriveとかDropboxとの比較

GoogleDriveとかDropboxとかって、なんかやたらとすぐ「同期(sync)」しようとするUIな気がしていて、
どうもそこが気に入らない。

油断するとすぐ手元のSSDの容量を食ってしまう。

どうやら自分には「同期」というものが難しすぎるらしい。

AmazonDriveは「同期せずにアップロードします」というボタンがわかりやすいところにある。**それが良かった。**

(全体的に使いやすい!というわけではありません👿)

### CLIツールの運用はあきらめた

マウントしたい欲求はあったのですが、

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article"><h4><a href="https://github.com/yadayada/acd_cli">yadayada/acd_cli</a></h4><p>acd_cli - A command line interface and FUSE filesystem for Amazon (Cloud) Drive</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

このツールが良さげなのですが、あまり手元の環境汚したくないので、Dockerに入れて試したんですが、うまく動きませんでした… 🐳

誰かいい感じにDockerとか使ってやってくれ…


### amazon.co.jpとamazon.comの比較

アップロードしまくったあとから気づいたのですが、
amazon.co.jpとamazon.comとで、結構値段が違うんですね…

amazon.comのほうが良かったかな…

https://www.amazon.co.jp/clouddrive/home **13,800円/年**

<img alt="amazon_drive" src="/images/amazon-co-jp-drive.png" width=400>

https://www.amazon.com/clouddrive/home **59.99ドル/年**

<img alt="amazon_drive" src="/images/amazon-com-drive.png" width=400>

amazon.comのほうが良かった感。 アメリカだとロケーション的に遠い、とかあるのかな?

ちなみにGoogle Driveだと1TBで9.99ドル/月ですので、微妙なところです。1TB以上アップロードする予定があるなら、Google DriveよりAmazon Driveのほうがちょっとお得でしょうか。

### Macが英語設定だとハマる

Sierraをクリーンインストールした後にハマりました。

なぜかamazon.comに接続しようとしよる…

英語設定だからか？とあたりをつけてサポートに聞いたところ、(以下抜粋)

> ご指摘の通りPC設定の言語が英語の場合、正常にAmazon.co.jpにてアクセスいただけない場合がございます。
> そのため、お手数ですがですがご利用のPCにて下記の環境設定についてご確認ください
> ・アップルメニュー＞「言語と地域」＞地域と言語＞日本となっているか
> ・ 地域と時間帯が日本になっているか
> ・カレンダーが西暦になっているか
> https://support.apple.com/kb/PH21561?locale=ja_JP&viewlocale=ja_JP

みたいな返事が返ってきました。

ググると同じことで悩んでた人がちらほら…

> <blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article-full"><h4><a href="http://enoki.hatenablog.com/entry/2016/01/21/151910">Amazon Cloud Driveのデスクトップアプリでamazon.co.jpにサインインできないとき - THE えのき</a></h4><p>日本でもプライム・フォトがプライム会員向けにスタートしました。 Amazon.co.jp: Amazon Prime 早速デスクトップアプリをダウンロードしてみました。 が、 サインイン出来ない... 右上に「Use your existing amazon.com account.」と書いてあるので、どうやら amazon.com のアカウントを必要としているみたいです。 システムの言語が英語なので、それが原因なのかな〜と思い、とりあえず英語から日本語に変更してみました。 方法がわからない人は↓のサイトでも参考にしてください。 日本語に変更した後、 Amazon Cloud Drive を起動すると... 「 Amazon.co.jp アカウントを使用」になってますね。 システムの言語を見てどの国の Amazon を利用しているのか判断しているんでしょうか？ はい 無事サインインできました👏 一度サインインしてしまえば、システムの言語を英語に戻した後もサインイン状態は継続していました。 ファイルのアップロードもバッチリ。 合計25GB弱のデータをアップロードしてみましたが、1時間ほどで終わりました。 Macの アクティビティモニターだと転送速度が7~10MB/sでした。 かなり早いですね🎉 写真ファイルは別にカウントされるみたいですね。 今後もバシバシRAWファイルをアップロードしようと思います。 試しにサインアウトしたあと再度サインインしようとしたら、「Use your existing amazon.com account.」と表示されていたので、もう一度日本語に設定する必要がありそうです。 サインインするタイミングでのシステムの言語にあわせてどの国の Amazon を利用するのか決めてる雰囲気です。 Macでは地域を設定することができるので、そっちを見てログイン先を変えるほうがいいような気がします。 というわけで問い合わせ済み。</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

こちらも。

> <blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article"><h4><a href="https://gist.github.com/pn11/2784bc5985b69be3f00ce490b69cf241">Mac を英語で使っている場合、 Amazon Cloud Drive のデスクトップクライアントは、System Preferences ＞ Language & Region ＞ Advanced ＞Format language で 日本語を選択すると amazon.co.jp にログインできる。</a></h4><p>Mac を英語で使っている場合、 Amazon Cloud Drive のデスクトップクライアントは、System Preferences ＞ Language & Region ＞ Advanced ＞Format language で 日本語を選択すると amazon.co.jp にログインできる。</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

なんかめんどくさそうなので日本語に戻ってきてしまいました😅


### ✎まとめ

AmazonDriveをamazon.comで使ってる人がいましたら感想聞きたいです!!
