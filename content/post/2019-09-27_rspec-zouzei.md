+++
date = "2019-09-27T11:30:16+09:00"
draft = false
title = "macOSの時計を10月1日にしてテスト実行すると消費税のせいでfailするテストが見つかって便利でした 😔"
slug = "rspec-zouzei"
tags = ["rspec","ruby","rails"]
image = "defimg/1.jpg"
+++

<!--more-->

普段こんなこと絶対やらないんですが、今回は便利でした。

具体的にはこの画面で「日付と時刻を自動的に設定」をオフにして日付を未来にします。

<img alt="" src="/images/clock.jpg" width=800>

<br>


## 現在時刻による分岐処理

消費税の値は基本的にDBに保存しているんですが、どうしてもパフォーマンスの理由とかいろいろの理由とかで、ベタ書きの箇所もあります。

もちろん、**ちゃんと[ActiveSupport::Testing::TimeHelpers](https://api.rubyonrails.org/v6.0/classes/ActiveSupport/Testing/TimeHelpers.html) とか使ってテスト書いてます。**

ですが、まあ、漏れもありますよね 😉

10/1にいきなり開発ブランチのCIがコケることがなくなって嬉しいです。

ご利用は自己責任で......


<script type="text/javascript" src="/js/prism.js" async></script>
